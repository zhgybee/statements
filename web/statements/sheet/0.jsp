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
				Data sheets = datasource.find("select * from T_STATEMENT_SHEET where STATEMENT_ID = ?", statementId);
				String[] sheetIds = new String[]{};
				for(Datum sheet : sheets)
				{
					sheetIds = ArrayUtils.add(sheetIds, sheet.getString("SHEET_ID"));
				}

				ConfigService configService = new ConfigService("0001");
				
				JSONArray items =  configService.getItems(sheetIds);
				
				Data data = datasource.find("select * from T01 where STATEMENT_ID = ? and SUBSTATEMENT_ID = ?", statementId, substatementId);
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
	}
	else
	{
		message.message(ServiceMessage.FAILURE, "登录用户失效，请重新登录。");
	}
	out.println(message);
%>