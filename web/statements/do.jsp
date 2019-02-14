
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
			String statementId = request.getParameter("statement");
			Connection connection = null;
			try
			{
				connection = DataSource.connection(SystemProperty.DATASOURCE);	
				DataSource datasource = new DataSource(connection);	
				datasource.execute("delete from T_STATEMENT where id = ?", statementId);
				datasource.execute("delete from T_SUBSTATEMENT where STATEMENT_ID = ?", statementId);
				datasource.execute("delete from T_STATEMENT_TRANSACTOR where STATEMENT_ID = ?", statementId);
				datasource.execute("delete from T_STATEMENT_SHEET where STATEMENT_ID = ?", statementId);
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
			/* 添加修改项目 */
			String id = StringUtils.defaultString(request.getParameter("id"), "");
			String title = StringUtils.defaultString(request.getParameter("title"), "");
			String legalperson = StringUtils.defaultString(request.getParameter("legalperson"), "");
			String startdate = StringUtils.defaultString(request.getParameter("startdate"), "");
			String enddate = StringUtils.defaultString(request.getParameter("enddate"), "");
			String accountant = StringUtils.defaultString(request.getParameter("accountant"), "");
			String accountantofficer = StringUtils.defaultString(request.getParameter("accountantofficer"), "");			
			String description = StringUtils.defaultString(request.getParameter("description"), "");			
			String sheets = StringUtils.defaultString(request.getParameter("sheets"), "");
						
			Connection connection = null;
			try
			{
				connection = DataSource.connection(SystemProperty.DATASOURCE);	
				DataSource datasource = new DataSource(connection);	

				if(id.equals(""))
				{
					id = SystemUtils.uuid();
					datasource.execute("insert into T_STATEMENT(ID, CODE, TITLE, STARTDATE, ENDDATE, LEGALPERSON, ACCOUNTANT, ACCOUNTANTOFFICER, STATUS, DESCRIPTION, CREATE_USER_ID, CREATE_DATE) values(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, CURRENT_TIMESTAMP)", 
							id, "", title, startdate, enddate, legalperson, accountant, accountantofficer, "001", description, sessionuser.getId());
				}
				else
				{
					datasource.execute("update T_STATEMENT set CODE = ?, TITLE = ?, STARTDATE = ?, ENDDATE = ?, LEGALPERSON = ?, ACCOUNTANT = ?, ACCOUNTANTOFFICER = ?, STATUS = ?, DESCRIPTION = ? where ID = ?", 
							"", title, startdate, enddate, legalperson, accountant, accountantofficer, "001", description, id);
					datasource.execute("delete from T_STATEMENT_SHEET where STATEMENT_ID = ?", id);
				}

				if(!sheets.equals(""))
				{
					JSONArray array = new JSONArray(sheets);
					
					for(int i = 0 ; i < array.length() ; i++)
					{
						JSONObject sheet = array.optJSONObject(i);
						datasource.execute("insert into T_STATEMENT_SHEET(STATEMENT_ID, SHEET_ID) VALUES(?, ?)", id, sheet.optString("id"));
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
		else if(mode.equals("3"))
		{
			/* 增加一个子项目 */
			String title = StringUtils.defaultString(request.getParameter("title"), "");
			String statementId = StringUtils.defaultString(request.getParameter("statement"), "");
			String parentId = StringUtils.defaultString(request.getParameter("parent"), "");
			String manageruser = StringUtils.defaultString(request.getParameter("manageruser"), "");
			String description = StringUtils.defaultString(request.getParameter("description"), "");

			Connection connection = null;
			try
			{
				connection = DataSource.connection(SystemProperty.DATASOURCE);	
				DataSource datasource = new DataSource(connection);	
				String id = SystemUtils.uuid();
				datasource.execute("insert into T_SUBSTATEMENT(ID, STATEMENT_ID, PARENT_ID, MANAGER_USER_ID, TITLE, STATUS, DESCRIPTION, CREATE_USER_ID, CREATE_DATE) values(?, ?, ?, ?, ?, ?, ?, ?, CURRENT_TIMESTAMP)", 
						id, statementId, parentId, manageruser, title, "001", description, sessionuser.getId());

				Data sheets = datasource.find("select * from T_STATEMENT_SHEET where STATEMENT_ID = ?", statementId);
				
				for(Datum sheet : sheets)
				{
					datasource.execute("insert into T_STATEMENT_TRANSACTOR(ID, STATEMENT_ID, SUBSTATEMENT_ID, SHEET_ID, TRANSACTOR_USER_ID, STATUS, DESCRIPTION, CREATE_USER_ID, CREATE_DATE) values(?, ?, ?, ?, ?, ?, ?, ?, CURRENT_TIMESTAMP)", 
							SystemUtils.uuid(), statementId, id, sheet.getString("SHEET_ID"), manageruser, "001", "", sessionuser.getId());
				}
				
				Datum statement = datasource.get("select * from T_STATEMENT where ID = ?", statementId);
				JSONObject types = new JSONObject(FileUtils.readFileToString(new File(SystemProperty.PATH + SystemProperty.FILESEPARATOR + "config" + SystemProperty.FILESEPARATOR + "startor.json"), "UTF-8"));
				JSONArray sqlmaps = types.getJSONArray("default");
				if(sqlmaps != null)
				{
					for(int i = 0 ; i < sqlmaps.length() ; i++)
					{
						JSONObject sqlmap = sqlmaps.getJSONObject(i);
						
						String sql = sqlmap.optString("sql");
						sql = StringUtils.replace(sql, "[STATEMENT_ID]", statementId);
						sql = StringUtils.replace(sql, "[STARTDATE]", statement.getString("STARTDATE"));
						sql = StringUtils.replace(sql, "[MANAGERUSER]", manageruser);
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
			/* 删除一个子项目 */
			String substatementId = request.getParameter("substatement");
			Connection connection = null;
			try
			{
				connection = DataSource.connection(SystemProperty.DATASOURCE);	
				DataSource datasource = new DataSource(connection);	
				datasource.execute("delete from T_SUBSTATEMENT where id = ?", substatementId);
				datasource.execute("delete from T_STATEMENT_TRANSACTOR where SUBSTATEMENT_ID = ?", substatementId);
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
		else if(mode.equals("5"))
		{
			/* 修改填表人 */ 
			String transactorId = request.getParameter("transactor");
			String transactoruser = request.getParameter("transactoruser");
			Connection connection = null;
			try
			{
				connection = DataSource.connection(SystemProperty.DATASOURCE);	
				DataSource datasource = new DataSource(connection);	
				datasource.execute("update T_STATEMENT_TRANSACTOR set TRANSACTOR_USER_ID = ? where id = ?", transactoruser, transactorId);
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