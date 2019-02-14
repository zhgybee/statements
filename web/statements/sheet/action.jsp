<%@page import="com.system.datasource.Datum"%>
<%@page import="com.system.datasource.Data"%>
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
				String tableId = StringUtils.defaultString(request.getParameter("table"), "");
				DataStructure datastructure = SystemProperty.DATASTRUCTURES.get(tableId);
				if(datastructure != null)
				{
					String tablename = datastructure.getProperty().optString("table");
					JSONObject column = new JSONObject( request.getParameter("column") );
					String key = request.getParameter("key");
					String value = request.getParameter("value");
					if(column != null)
					{
						String columnname = column.optString("name");
						
						connection = DataSource.connection(SystemProperty.DATASOURCE);
						DataSource datasource = new DataSource(connection);	
						datasource.execute("update "+tablename+" set "+columnname+" = ?, CREATE_DATE = CURRENT_TIMESTAMP where ID = ?", value, key);
						
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
										message.message(ServiceMessage.FAILURE, "SQL构建器中不存在["+callbacks.optString(i)+"]。");
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
				String tableId = StringUtils.defaultString(request.getParameter("table"), "");
				DataStructure datastructure = SystemProperty.DATASTRUCTURES.get(tableId);
				if(datastructure != null)
				{
					String tablename = datastructure.getProperty().optString("table");
					connection = DataSource.connection(SystemProperty.DATASOURCE);
					DataSource datasource = new DataSource(connection);	
					
					String sql = null;
					JSONObject property = datastructure.getProperty();
					if(property != null)
					{
						JSONObject sqls =  property.optJSONObject("sqls");
						if(sqls != null)
						{
							if(sqls.has("add"))
							{
								JSONObject dataset = SystemProperty.SQLBUILDER.get( sqls.optString("add") );
								if(dataset != null)
								{
									sql = dataset.optString("sql");
									sql = VariableService.parseUrlVariable(sql, 0, request);
									sql = VariableService.parseSysVariable(sql, request);	
								}
							}
						}
					}
					
					if(sql != null)
					{							
						datasource.execute(sql);
					}
					else
					{
						datasource.execute("insert into "+tablename+"(ID, STATEMENT_ID, SUBSTATEMENT_ID, CREATE_USER_ID, CREATE_DATE) values(?, ?, ?, ?, CURRENT_TIMESTAMP)", SystemUtils.uuid(), statementId, substatementId, sessionuser.getId());
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
		else if(mode.equals("3"))
		{

			String tableId = StringUtils.defaultString(request.getParameter("table"), "");
			DataStructure datastructure = SystemProperty.DATASTRUCTURES.get(tableId);
			if(datastructure != null)
			{
				Connection connection = null;
				try
				{
					String tablename = datastructure.getProperty().optString("table");
					connection = DataSource.connection(SystemProperty.DATASOURCE);
					DataSource datasource = new DataSource(connection);	
					
					Data columns = datasource.find("PRAGMA table_info('"+tablename+"')");
					
					String[] columnnames = new String[]{};
					
					for(Datum column : columns)
					{
						String columnname = column.getString("name");
						if(!columnname.equals("ID"))
						{
							columnnames = ArrayUtils.add(columnnames, columnname);
						}
					}
					String columnitem = StringUtils.join(columnnames, ", ");
					
					String[] ids = StringUtils.defaultString(request.getParameter("ids"), "").split(",");
					if(ids.length > 0)
					{				
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
				String tableId = StringUtils.defaultString(request.getParameter("table"), "");
				DataStructure datastructure = SystemProperty.DATASTRUCTURES.get(tableId);
				if(datastructure != null)
				{
					if(ids.length > 0)
					{				
						connection = DataSource.connection(SystemProperty.DATASOURCE);
						DataSource datasource = new DataSource(connection);	

						String tablename = datastructure.getProperty().optString("table");
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