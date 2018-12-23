
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
		String version = request.getParameter("version");
		ConfigService configService = new ConfigService(version);
		
		JSONArray sheets = configService.getSheets();
		if(sheets != null)
		{
			message.resource("sheets", sheets);			
		}
	}
	else
	{
		message.message(ServiceMessage.FAILURE, "登录用户失效，请重新登录。");
	}
	
	out.println(message);
%>			