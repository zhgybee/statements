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
			String merge = StringUtils.defaultString(request.getParameter("merge"), "");
			String children = StringUtils.defaultString(request.getParameter("children"), "");
			
			Connection connection = null;
			try
			{
				connection = DataSource.connection(SystemProperty.DATASOURCE);	
				DataSource datasource = new DataSource(connection);	
				String sql = "select * from T04 where STATEMENT_ID = ? and SUBSTATEMENT_ID = ? and MERGE = ?";
				Data items = datasource.find(sql, statementId, substatementId, merge);
				

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
				String merge = request.getParameter("merge");
				
				Data items = datasource.find("select ID from T04 where STATEMENT_ID = ? and SUBSTATEMENT_ID = ? and MERGE = ? and BM = ?", statementId, substatementId, merge, key);
				
				if(items.size() == 0)
				{
					datasource.execute("insert into T04(ID, BM, "+columnname+", MERGE, STATEMENT_ID, SUBSTATEMENT_ID, CREATE_USER_ID, CREATE_DATE) values(?, ?, ?, ?, ?, ?, ?, CURRENT_TIMESTAMP)", 
							SystemUtils.uuid(), key, value, merge, statementId, substatementId, sessionuser.getId());
				}
				else
				{
					datasource.execute("update T04 set "+columnname+" = ?, CREATE_DATE = CURRENT_TIMESTAMP where STATEMENT_ID = ? and SUBSTATEMENT_ID = ? and MERGE = ? and BM = ?", 
							value, statementId, substatementId, merge, key);
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