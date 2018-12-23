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
			ConfigService configService = new ConfigService("0001");
			JSONArray tables = configService.getTables(sheetId);
			if(tables != null)
			{
				message.resource("tables", tables);			
			}
		}
	}
	else
	{
		message.message(ServiceMessage.FAILURE, "登录用户失效，请重新登录。");
	}
	
	out.println(message);
%>




