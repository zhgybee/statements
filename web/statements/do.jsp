
<%@page import="com.system.datasource.Datum"%>
<%@page import="java.io.File"%>
<%@page import="com.system.variable.VariableService"%>
<%@page import="org.json.JSONArray"%>
<%@page import="org.apache.commons.io.FileUtils"%>
<%@page import="org.json.JSONObject"%>
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
			String title = StringUtils.defaultString(request.getParameter("title"), "");
			String type = StringUtils.defaultString(request.getParameter("type"), "");
			String legalperson = StringUtils.defaultString(request.getParameter("legalperson"), "");
			String startdate = StringUtils.defaultString(request.getParameter("startdate"), "");
			String enddate = StringUtils.defaultString(request.getParameter("enddate"), "");
			String accountant = StringUtils.defaultString(request.getParameter("accountant"), "");
			String accountantofficer = StringUtils.defaultString(request.getParameter("accountantofficer"), "");			
			String description = StringUtils.defaultString(request.getParameter("description"), "");
						
			Connection connection = null;
			try
			{
				connection = DataSource.connection(SystemProperty.DATASOURCE);	
				DataSource datasource = new DataSource(connection);	
				String id = SystemUtils.uuid();
				datasource.execute("INSERT INTO T_TASK(ID, CODE, TITLE, TYPE, STARTDATE, ENDDATE, LEGALPERSON, ACCOUNTANT, ACCOUNTANTOFFICER, STATUS, DESCRIPTION, CREATE_USER_ID, CREATE_DATE) VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, CURRENT_TIMESTAMP)", 
						id, "", title, type, startdate, enddate, legalperson, accountant, accountantofficer, "001", description, sessionuser.getId());
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
		else if(mode.equals("3"))
		{
			String trantitle = StringUtils.defaultString(request.getParameter("trantitle"), "");
			String statementId = StringUtils.defaultString(request.getParameter("statement"), "");
			String transactor = StringUtils.defaultString(request.getParameter("transactor"), "");
			String trandescription = StringUtils.defaultString(request.getParameter("trandescription"), "");

			Connection connection = null;
			try
			{
				connection = DataSource.connection(SystemProperty.DATASOURCE);	
				DataSource datasource = new DataSource(connection);	
				datasource.execute("INSERT INTO T_TRANSACTOR(ID, TITLE, DESCRIPTION, TASK_ID, USER_ID, STATUS, CREATE_DATE) VALUES(?, ?, ?, ?, ?, ?, CURRENT_TIMESTAMP)", 
					SystemUtils.uuid(), trantitle, trandescription, statementId, transactor, "011");
				
				
				Datum statement = datasource.get("select * from T_TASK where ID = ?", statementId);
				

				JSONObject types = new JSONObject(FileUtils.readFileToString(new File(SystemProperty.PATH + SystemProperty.FILESEPARATOR + "statements" + SystemProperty.FILESEPARATOR + "initialise.json"), "UTF-8"));
				JSONArray sqlmaps = types.getJSONArray(statement.getString("TYPE"));
				if(sqlmaps != null)
				{
					for(int i = 0 ; i < sqlmaps.length() ; i++)
					{
						JSONObject sqlmap = sqlmaps.getJSONObject(i);
						
						String sql = sqlmap.optString("sql");
						sql = StringUtils.replace(sql, "[TASK_ID]", statementId);
						sql = StringUtils.replace(sql, "[STARTDATE]", statement.getString("STARTDATE"));
						sql = StringUtils.replace(sql, "[TRANSACTOR]", transactor);
						sql = StringUtils.replace(sql, "[ENDDATE]", statement.getString("ENDDATE"));
						sql = StringUtils.replace(sql, "[LEGALPERSON]", statement.getString("LEGALPERSON"));
						sql = StringUtils.replace(sql, "[ACCOUNTANT]", statement.getString("ACCOUNTANT"));
						sql = StringUtils.replace(sql, "[ACCOUNTANTOFFICER]", statement.getString("ACCOUNTANTOFFICER"));					
						sql = VariableService.parseUrlVariable(sql, 0, request);
						sql = VariableService.parseSysVariable(sql, request);					
						datasource.execute(sql);
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
		else if(mode.equals("4"))
		{
			String id = request.getParameter("id");
			Connection connection = null;
			try
			{
				connection = DataSource.connection(SystemProperty.DATASOURCE);	
				DataSource datasource = new DataSource(connection);	
				datasource.execute("delete from T_TRANSACTOR where id = ?", id);
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
	}
	else
	{
		message.message(ServiceMessage.FAILURE, "登录用户失效，请重新登录。");
	}
	
	out.println(message);
%>