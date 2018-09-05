
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
				datasource.execute("delete from T_TASK where id = ?", id);
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
			String code = StringUtils.defaultString(request.getParameter("code"), "");
			String title = StringUtils.defaultString(request.getParameter("title"), "");
			String type = StringUtils.defaultString(request.getParameter("type"), "");
			String transactor = StringUtils.defaultString(request.getParameter("transactor"), "");
			String description = StringUtils.defaultString(request.getParameter("description"), "");
			Connection connection = null;
			try
			{
				connection = DataSource.connection(SystemProperty.DATASOURCE);	
				DataSource datasource = new DataSource(connection);	
				String id = SystemUtils.uuid();
				datasource.execute("INSERT INTO T_TASK(ID, CODE, TITLE, TYPE, STATUS, DESCRIPTION, CREATE_USER_ID, CREATE_DATE) VALUES(?, ?, ?, ?, ?, ?, ?, CURRENT_TIMESTAMP)", 
						id, code, title, type, "001", description, sessionuser.getId());
				
				if(!transactor.equals(""))
				{
					String[] transactors = transactor.split(",");
					for(int i = 0 ; i < transactors.length ; i++)
					{
						datasource.execute("INSERT INTO T_TRANSACTOR(ID, TASK_ID, USER_ID, STATUS, CREATE_DATE) VALUES(?, ?, ?, ?, CURRENT_TIMESTAMP)", 
								SystemUtils.uuid(), id, transactors[i], "011");
					}
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