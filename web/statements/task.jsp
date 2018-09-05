<%@page import="com.system.datastructure.DataStructure"%>
<%@page import="org.json.JSONArray"%>
<%@page import="java.io.File"%>
<%@page import="org.apache.commons.io.FileUtils"%>
<%@page import="org.json.JSONObject"%>
<%@page import="org.apache.commons.lang3.StringUtils"%>
<%@page import="org.apache.commons.lang3.ArrayUtils"%>
<%@page import="com.system.datasource.Datum"%>
<%@page import="com.system.SessionUser"%>
<%@page import="com.system.utils.ServiceMessage"%>
<%@page import="com.system.utils.ThrowableUtils"%>
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
			String status = StringUtils.defaultString(request.getParameter("status"), "011");
			Connection connection = null;
			try
			{
				connection = DataSource.connection(SystemProperty.DATASOURCE);	
				DataSource datasource = new DataSource(connection);	
				Data tasks = datasource.find("select * from T_TRANSACTOR left join (select T_TASK.ID as 'TASK_ID', T_TASK.TITLE, T_TASK.TYPE, T_TASK.DESCRIPTION, T_USER.NAME as 'USERNAME', T_USER.ICON as 'USERICON' from T_TASK left join T_USER on T_USER.ID = T_TASK.CREATE_USER_ID ) T_TASK on T_TASK.TASK_ID = T_TRANSACTOR.TASK_ID where T_TRANSACTOR.USER_ID = ? and T_TRANSACTOR.STATUS = ? order by T_TRANSACTOR.CREATE_DATE desc", 
						sessionuser.getId(), status);

				message.resource("rows", tasks);
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
				connection = DataSource.connection(SystemProperty.DATASOURCE);	
				DataSource datasource = new DataSource(connection);	
				Data tasks = datasource.find("select * from T_TASK where CREATE_USER_ID = ? order by CREATE_DATE desc", sessionuser.getId());
				
				if(tasks.size() > 0)
				{
					String[] ids = new String[]{};
					for(Datum task : tasks)
					{
						ids = ArrayUtils.add(ids, "'"+task.getString("ID")+"'");
					}
					Data transactors = datasource.find("select T_USER.NAME as 'USERNAME', T_USER.ICON as 'USERICON', T_TRANSACTOR.* from T_TRANSACTOR left join T_USER on T_TRANSACTOR.USER_ID = T_USER.ID where T_TRANSACTOR.TASK_ID in ("+StringUtils.join(ids, ",")+") order by CREATE_DATE");
					
					for(Datum task : tasks)
					{
						Data thistransactors = new Data();
						for(Datum transactor : transactors)
						{
							if( transactor.getString("TASK_ID").equals( task.getString("ID") ) )
							{
								thistransactors.add(transactor);
							}
						}
						if(thistransactors.size() > 0)
						{
							task.put("TRANSACTOR", thistransactors);
						}
					}
				}
				message.resource("rows", tasks);
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
		else if(mode.equals("3"))
		{
			String id = StringUtils.defaultString(request.getParameter("id"), "");
			Connection connection = null;
			try
			{
				connection = DataSource.connection(SystemProperty.DATASOURCE);	
				DataSource datasource = new DataSource(connection);	
				Datum task = datasource.get("select * from T_TRANSACTOR left join (select T_TASK.ID as 'TASK_ID', T_TASK.TITLE, T_TASK.TYPE, T_TASK.DESCRIPTION, T_USER.NAME as 'USERNAME', T_USER.ICON as 'USERICON' from T_TASK left join T_USER on T_USER.ID = T_TASK.CREATE_USER_ID ) T_TASK on T_TASK.TASK_ID = T_TRANSACTOR.TASK_ID where T_TRANSACTOR.USER_ID = ? and T_TRANSACTOR.ID = ? order by T_TRANSACTOR.CREATE_DATE desc", 
						sessionuser.getId(), id);
				message.resource("rows", task);
				
				JSONObject types = new JSONObject(FileUtils.readFileToString(new File(SystemProperty.PATH + SystemProperty.FILESEPARATOR + "statements" + SystemProperty.FILESEPARATOR + "statement.json"), "UTF-8"));
				JSONArray statements = types.getJSONArray(task.getString("TYPE"));
				for(int i = 0 ; i < statements.length() ; i++)
				{
					JSONObject statement = statements.getJSONObject(i);
					DataStructure datastructure = SystemProperty.DATASTRUCTURES.get(statement.optString("code"));
					String table = datastructure.getProperty().optString("name");
					statement.put("table", table);
					
					Datum count = datasource.get("select count(ID) as 'COUNT' from "+table+" where TASK_ID = ?", task.getString("TASK_ID"));
					statement.put("count", count.getInt("COUNT"));
				}
				message.resource("statements", statements);
				
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