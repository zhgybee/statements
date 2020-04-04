
<%@page import="com.system.SessionUser"%>
<%@page import="org.apache.commons.lang3.StringUtils"%>
<%@page import="java.util.Calendar"%>
<%@page import="com.system.utils.SystemUtils"%>
<%@page import="com.system.utils.ThrowableUtils"%>
<%@page import="com.system.utils.ServiceMessage"%>
<%@page import="com.system.SystemProperty"%>
<%@page import="com.system.datasource.Data"%>
<%@page import="com.system.datasource.DataSource"%>
<%@page import="java.sql.Connection"%>

<%@page contentType="text/html; charset=utf-8"%>

<%
	
	ServiceMessage message = new ServiceMessage();
	SessionUser sessionuser = SessionUser.getSessionUser(session);
	
	if(sessionuser != null)
	{
		String mode = request.getParameter("mode");
	
		if(mode.equals("1"))
		{
			String id = request.getParameter("id");
			Connection connection = null;
			try
			{
				connection = DataSource.connection(SystemProperty.DATASOURCE);	
				DataSource datasource = new DataSource(connection);	
				datasource.execute("delete from T_USER where id = ?", id);
				connection.commit();
			}
			catch(Exception e)
			{
				if(connection != null)
				{
					connection.rollback();
				};
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
			String name = StringUtils.defaultString(request.getParameter("name"), "");
			String code = StringUtils.defaultString(request.getParameter("code"), "");
			String loginname = StringUtils.defaultString(request.getParameter("loginname"), "");
			String password = StringUtils.defaultString(request.getParameter("password"), "");
			String role = StringUtils.defaultString(request.getParameter("role"), "");
			Connection connection = null;
			try
			{
				connection = DataSource.connection(SystemProperty.DATASOURCE);	
				DataSource datasource = new DataSource(connection);	
				datasource.execute("INSERT INTO T_USER(ID, NAME, CODE, LOGINNAME, PASSWORD, ROLE, CREATE_DATE) VALUES(?, ?, ?, ?, ?, ?, NOW())", SystemUtils.uuid(), name, code, loginname, password, role);
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