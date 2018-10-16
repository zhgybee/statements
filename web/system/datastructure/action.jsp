<%@page import="com.system.variable.VariableService"%>
<%@page import="org.json.JSONArray"%>
<%@page import="org.apache.commons.lang3.ArrayUtils"%>
<%@page import="java.util.Set"%>
<%@page import="java.util.Map"%>
<%@page import="org.apache.commons.lang3.StringUtils"%>
<%@page import="com.system.utils.SystemUtils"%>
<%@page import="com.system.datasource.DataSource"%>
<%@page import="java.sql.Connection"%>
<%@page import="com.system.datastructure.DataStructure"%>
<%@page import="com.system.SystemProperty"%>
<%@page import="org.json.JSONException"%>
<%@page import="org.json.JSONObject"%>
<%@page import="com.system.utils.ThrowableUtils"%>
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
			Connection connection = null;
			try
			{
				String id = request.getParameter("id");
				String value = request.getParameter("value");
				JSONObject column = new JSONObject( request.getParameter("column") );
				if(column != null)
				{
					JSONObject table = column.getJSONObject("table");
					if(table != null)
					{
						String tablename = table.optString("name");
						String columnname = column.optString("name");
						
						DataStructure datastructure = SystemProperty.DATASTRUCTURES.get(tablename);
						connection = DataSource.connection(SystemProperty.DATASOURCE);
						DataSource datasource = new DataSource(connection);	
						datasource.execute("update "+tablename+" set "+columnname+" = ?, CREATE_DATE = CURRENT_TIMESTAMP where ID = ?", value, id);
						
						JSONObject editor = column.optJSONObject("editor");
						if(editor != null)
						{
							JSONArray callbacks = editor.optJSONArray("callback");
							if(callbacks != null)
							{
								for(int i =  0 ; i < callbacks.length() ; i++)
								{
									JSONObject item = SystemProperty.SQLBUILDER.get(callbacks.optString(i));
									if(item != null)
									{
										String sql = item.optString("sql");
										sql = VariableService.parseUrlVariable(sql, 0, request);
										sql = VariableService.parseSysVariable(sql, request);
										datasource.execute(sql);
									}
									else
									{
										message.message(ServiceMessage.FAILURE, "SQL构建起中不存在["+callbacks.optString(i)+"]。");
									}
								}
							}
							
						}
						
						connection.commit();
					}
				}
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
		else if(mode.equals("2"))
		{
			Connection connection = null;
			try
			{
				String statementId = request.getParameter("statement");
				String substatementId = request.getParameter("substatement");
				String name = request.getParameter("name");
				connection = DataSource.connection(SystemProperty.DATASOURCE);
				DataSource datasource = new DataSource(connection);	
				datasource.execute("insert into "+name+"(ID, STATEMENT_ID, SUBSTATEMENT_ID, CREATE_USER_ID, CREATE_DATE) values(?, ?, ?, ?, CURRENT_TIMESTAMP)", SystemUtils.uuid(), statementId, substatementId, sessionuser.getId());
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
			String code = request.getParameter("code");
			DataStructure datastructure = SystemProperty.DATASTRUCTURES.get(code);
			if(datastructure != null)
			{
				Map<String, JSONObject> columnmap = datastructure.getColumns();
				Set<String> columnnames = columnmap.keySet();
				columnnames.remove("ID");
				
				String columnitem = StringUtils.join(columnnames, ", ");
				Connection connection = null;
				try
				{
					String[] ids = StringUtils.defaultString(request.getParameter("ids"), "").split(",");
					if(ids.length > 0)
					{				
						connection = DataSource.connection(SystemProperty.DATASOURCE);
						DataSource datasource = new DataSource(connection);	

						String tablename = datastructure.getProperty().optString("name");
						for(String id : ids)
						{
							datasource.execute("insert into "+tablename+"(ID, "+columnitem+") select '"+SystemUtils.uuid()+"', "+columnitem+" from "+tablename+" where ID = ?", id);
						}
						connection.commit();
					}
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
			else
			{
				message.message(ServiceMessage.FAILURE, "表结构配置文件错误。");
			}
		}
		else if(mode.equals("4"))
		{
			Connection connection = null;
			try
			{
				String[] ids = StringUtils.defaultString(request.getParameter("ids"), "").split(",");
				String code = request.getParameter("code");
				DataStructure datastructure = SystemProperty.DATASTRUCTURES.get(code);
				if(datastructure != null)
				{
					if(ids.length > 0)
					{				
						connection = DataSource.connection(SystemProperty.DATASOURCE);
						DataSource datasource = new DataSource(connection);	
	
						String tablename = datastructure.getProperty().optString("name");
						for(String id : ids)
						{
							datasource.execute("delete from "+tablename+" where ID = ?", id);
						}
						connection.commit();
					}
				}
				else
				{
					message.message(ServiceMessage.FAILURE, "表结构配置文件错误。");
				}
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