<%@page import="com.system.datastructure.DataStructure"%>
<%@page import="com.system.utils.SystemUtils"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashSet"%>
<%@page import="com.statement.ConfigService"%>
<%@page import="org.apache.commons.lang3.ArrayUtils"%>
<%@page import="org.json.JSONArray"%>
<%@page import="java.io.File"%>
<%@page import="org.apache.commons.io.FileUtils"%>
<%@page import="org.json.JSONObject"%>
<%@page import="com.system.datasource.Datum"%>
<%@page import="org.apache.commons.lang3.StringUtils"%>
<%@page import="com.system.utils.ThrowableUtils"%>
<%@page import="com.system.datasource.Data"%>
<%@page import="com.system.SystemProperty"%>
<%@page import="com.system.datasource.DataSource"%>
<%@page import="java.sql.Connection"%>
<%@page import="com.system.SessionUser"%>
<%@page import="com.system.utils.ServiceMessage"%>
<%@page contentType="text/html; charset=utf-8"%>

<%

	ServiceMessage message = new ServiceMessage();
	SessionUser sessionuser = SessionUser.getSessionUser(session);
	
	if(sessionuser != null)
	{
		String mode = request.getParameter("mode");
	
		if(mode.equals("1"))
		{
			String statementId = StringUtils.defaultString(request.getParameter("statement"), "");
			String substatementId = StringUtils.defaultString(request.getParameter("substatement"), "");
			String statementmode = StringUtils.defaultString(request.getParameter("statementmode"), "");
			String children = StringUtils.defaultString(request.getParameter("children"), "");
			
			Connection connection = null;
			try
			{
				connection = DataSource.connection(SystemProperty.DATASOURCE);	
				DataSource datasource = new DataSource(connection);	


				DataStructure datastructure = SystemProperty.DATASTRUCTURES.get("T0003");
				Data items = null;
				if(statementmode.equals("2") || statementmode.equals("1"))
				{
					//合并抵消或哈达：取所有单表的合并数据
					String sql = "select * from T04 where SUBSTATEMENT_ID in ("+children+") and MODE = '0'";
					items = datasource.find(sql);
					items = SystemUtils.merge(items, datastructure.getProperty().optJSONArray("columns"));
				}
				else if(statementmode.equals("0"))
				{
					String sql = "select * from T04 where SUBSTATEMENT_ID = ? and MODE = '0'";
					items = datasource.find(sql, substatementId);
				}

				Map<String, Datum> itemmap = new HashMap<String, Datum>();
				for(Datum datum : items)
				{
					itemmap.put(datum.getString("BM"), datum);
				}
				
				message.resource("itemmap", itemmap);
				message.resource("items", items);
			}
			catch(Exception e)
			{
				Throwable throwable = ThrowableUtils.getThrowable(e);
				message.message(ServiceMessage.FAILURE, throwable.getMessage());
			}
			finally
			{
				if(connection != null)
				{
					connection.close();
				}
			}
		}
		else if(mode.equals("2"))
		{
			Connection connection = null;
			try
			{
				String columnname = request.getParameter("name");
				String key = StringUtils.defaultString(request.getParameter("key"), "");
				String value = request.getParameter("value");
				connection = DataSource.connection(SystemProperty.DATASOURCE);
				DataSource datasource = new DataSource(connection);	
				
				String statementId = request.getParameter("statement");
				String substatementId = request.getParameter("substatement");
				String statementmode = request.getParameter("statementmode");
				
				Data items = datasource.find("select ID from T04 where STATEMENT_ID = ? and SUBSTATEMENT_ID = ? and MODE = '0' and BM = ?", statementId, substatementId, key);
				
				if(items.size() == 0)
				{
					datasource.execute("insert into T04(ID, BM, "+columnname+", MODE, STATEMENT_ID, SUBSTATEMENT_ID, CREATE_USER_ID, CREATE_DATE) values(?, ?, ?, ?, ?, ?, ?, NOW())", 
							SystemUtils.uuid(), key, value, "0", statementId, substatementId, sessionuser.getId());
				}
				else
				{
					datasource.execute("update T04 set "+columnname+" = ?, CREATE_DATE = NOW() where STATEMENT_ID = ? and SUBSTATEMENT_ID = ? and MODE = ? and BM = ?", 
							value, statementId, substatementId, "0", key);
				}
				connection.commit();
			}
			catch(Exception e)
			{
				if(connection != null)
				{
					connection.rollback();
				}
				Throwable throwable = ThrowableUtils.getThrowable(e);
				message.message(ServiceMessage.FAILURE, throwable.getMessage());
			}
			finally
			{
				if(connection != null)
				{
					connection.close();
				}
			}
		}
	}
	else
	{
		message.message(ServiceMessage.FAILURE, "登录用户失效，请重新登录。");
	}
	out.println(message);
%>