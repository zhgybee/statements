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
			String substatementId = StringUtils.defaultString(request.getParameter("substatement"), "");
			String statementmode = StringUtils.defaultString(request.getParameter("statementmode"), "");
			String children = StringUtils.defaultString(request.getParameter("children"), "");
			
			Connection connection = null;
			try
			{
				connection = DataSource.connection(SystemProperty.DATASOURCE);	
				DataSource datasource = new DataSource(connection);	
				
				DataStructure datastructure = SystemProperty.DATASTRUCTURES.get("T0002");
				Data items = null;
				if(statementmode.equals("2") || statementmode.equals("1"))
				{
					//合并抵消或哈达：审定前为所有单表审定后（审定前+调整）的合计，调整分录取合并抵消环境下的数据

					items = datasource.find("select * from T05 where SUBSTATEMENT_ID in ("+children+") and MODE = '0'");
					for(Datum item : items)
					{
						item.put("BQSDQ", item.getDouble("BQSDQ") + item.getDouble("BQTZS"));
						item.put("SQSDQ", item.getDouble("SQSDQ") + item.getDouble("SQTZS"));
					}
					items = SystemUtils.merge(items, datastructure.getProperty().optJSONArray("columns"));

					
					//得到合并抵消环境下的调整数
					Data changers = datasource.find("select * from T05 where SUBSTATEMENT_ID  = ?  and MODE = '1'", substatementId);
					Map<String, String> changermap = new HashMap<String, String>();
					for(Datum changer : changers)
					{
						changermap.put("BQ"+changer.getString("BM"), changer.getString("BQTZS"));
						changermap.put("SQ"+changer.getString("BM"), changer.getString("SQTZS"));
					}

					for(Datum item : items)
					{
						item.put("BQTZS", changermap.get("BQ"+item.getString("BM")));
						item.put("SQTZS", changermap.get("BQ"+item.getString("BM")));
					}


				}
				else if(statementmode.equals("0"))
				{
					items = datasource.find("select * from T05 where SUBSTATEMENT_ID = ? and MODE = 0", substatementId);
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
				
				Data items = datasource.find("select ID from T05 where STATEMENT_ID = ? and SUBSTATEMENT_ID = ? and MODE = ? and BM = ?", statementId, substatementId, statementmode, key);
				
				if(items.size() == 0)
				{
					datasource.execute("insert into T05(ID, BM, "+columnname+", MODE, STATEMENT_ID, SUBSTATEMENT_ID, CREATE_USER_ID, CREATE_DATE) values(?, ?, ?, ?, ?, ?, ?, CURRENT_TIMESTAMP)", 
							SystemUtils.uuid(), key, value, statementmode, statementId, substatementId, sessionuser.getId());
				}
				else
				{
					datasource.execute("update T05 set "+columnname+" = ?, CREATE_DATE = CURRENT_TIMESTAMP where STATEMENT_ID = ? and SUBSTATEMENT_ID = ? and MODE = ? and BM = ?", 
							value, statementId, substatementId, statementmode, key);
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