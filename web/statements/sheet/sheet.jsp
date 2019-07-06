
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="com.system.datasource.Datum"%>
<%@page import="java.net.URLDecoder"%>
<%@page import="com.system.SystemProperty"%>
<%@page import="com.system.utils.ThrowableUtils"%>
<%@page import="com.system.datasource.Data"%>
<%@page import="com.system.datasource.DataSource"%>
<%@page import="java.sql.Connection"%>
<%@page import="org.apache.commons.lang3.StringUtils"%>
<%@page import="org.json.JSONArray"%>
<%@page import="com.statement.ConfigService"%>
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
			String sheetId = request.getParameter("sheet");
			String statementId = StringUtils.defaultString(request.getParameter("statement"), "");
			String substatementId = StringUtils.defaultString(request.getParameter("substatement"), "");
			String statementmode = StringUtils.defaultString(request.getParameter("statementmode"), "");
			String children = StringUtils.defaultString(request.getParameter("children"), "");
			children = URLDecoder.decode(children, "UTF-8");
			
			ConfigService configService = new ConfigService("0001");
			JSONArray tables = configService.getTables(sheetId);
			if(tables != null)
			{
				message.resource("tables", tables);			
			}

			Connection connection = null;
			try
			{
				connection = DataSource.connection(SystemProperty.DATASOURCE);	
				DataSource datasource = new DataSource(connection);	
				

				Data allsubstatements = datasource.find("select * from T_SUBSTATEMENT where STATEMENT_ID = ?", statementId);				
				List<String> parentIds = new ArrayList<String>();
				for(Datum substatement : allsubstatements)
				{
					parentIds.add(substatement.getString("PARENT_ID"));
				}

				Data substatements = datasource.find("select * from T_SUBSTATEMENT where ID in ("+children+")");
				for(Datum substatement : substatements)
				{
					if( parentIds.contains(substatement.get("ID")) )
					{
						substatement.put("ISCHILD", "1");
					}
				}

				message.resource("substatements", substatements);
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




