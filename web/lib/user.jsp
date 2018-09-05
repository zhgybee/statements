<%@page import="com.system.SessionUser"%>

<%@page contentType="text/html; charset=utf-8"%>

	
<%
	SessionUser sessionuser = SessionUser.getSessionUser(session);
	if(sessionuser != null)
	{
%>

		app.USERNAME = '<%=sessionuser.getName()%>';
		app.USERICON = '<%=sessionuser.getIcon()%>';
		app.USERROLE = '<%=sessionuser.getRole()%>';

<%
	}
%>