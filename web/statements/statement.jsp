<%@page import="java.util.HashSet"%>
<%@page import="java.util.Set"%>
<%@page import="com.system.utils.SystemUtils"%>
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
			String status = StringUtils.defaultString(request.getParameter("status"), "001");
			Connection connection = null;
			try
			{
				connection = DataSource.connection(SystemProperty.DATASOURCE);	
				DataSource datasource = new DataSource(connection);	
				//在工作台中，一个项目的子项目管理人员或者子项目的工作人员可以查询到该项目
				Data statements = datasource.find("select T_USER.NAME as 'USERNAME', T_USER.ICON as 'USERICON', T_STATEMENT.* from T_STATEMENT left join T_USER on T_STATEMENT.CREATE_USER_ID = T_USER.ID where T_STATEMENT.ID in (select STATEMENT_ID from T_STATEMENT_TRANSACTOR where TRANSACTOR_USER_ID = ? and STATUS = ? group by STATEMENT_ID) or T_STATEMENT.ID in (select STATEMENT_ID from T_SUBSTATEMENT where MANAGER_USER_ID = ?) order by T_STATEMENT.CREATE_DATE desc", 
						sessionuser.getId(), status, sessionuser.getId());
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
		else if(mode.equals("2"))
		{
			Connection connection = null;
			try
			{
				connection = DataSource.connection(SystemProperty.DATASOURCE);	
				DataSource datasource = new DataSource(connection);	
				Data statements = datasource.find("select T_USER.NAME as 'USERNAME', T_USER.ICON as 'USERICON', T_STATEMENT.* from T_STATEMENT left join T_USER on T_STATEMENT.CREATE_USER_ID = T_USER.ID where T_STATEMENT.CREATE_USER_ID = ? order by CREATE_DATE desc", sessionuser.getId());
				
				if(statements.size() > 0)
				{
					String[] ids = new String[]{};
					for(Datum statement : statements)
					{
						ids = ArrayUtils.add(ids, "'"+statement.getString("ID")+"'");
					}
					Data substatements = datasource.find("select T_USER.NAME as 'USERNAME', T_USER.ICON as 'USERICON', T_SUBSTATEMENT.* from T_SUBSTATEMENT left join T_USER on T_SUBSTATEMENT.MANAGER_USER_ID = T_USER.ID where T_SUBSTATEMENT.STATEMENT_ID in ("+StringUtils.join(ids, ",")+") order by CREATE_DATE");
					
					for(Datum statement : statements)
					{
						Data currents = new Data();
						for(Datum substatement : substatements)
						{
							if( substatement.getString("STATEMENT_ID").equals( statement.getString("ID") ) )
							{
								currents.add(substatement);
							}
						}
						if(currents.size() > 0)
						{
							statement.put("SUBSTATEMENTS", currents);
						}
					}
				}
				message.resource("rows", statements);
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
		else if(mode.equals("4"))
		{
			String code = StringUtils.defaultString(request.getParameter("code"), "");				
			DataStructure datastructure = SystemProperty.DATASTRUCTURES.get(code);
			message.resource("datastructure", datastructure.getProperty());			
		}
		else if(mode.equals("5"))
		{
			String statementId = StringUtils.defaultString(request.getParameter("statement"), "");
			
			Connection connection = null;
			try
			{
				connection = DataSource.connection(SystemProperty.DATASOURCE);	
				DataSource datasource = new DataSource(connection);	
				
				
				Datum statement = datasource.get("select T_USER.NAME as 'USERNAME', T_USER.ICON as 'USERICON', T_STATEMENT.* from T_STATEMENT left join T_USER on T_STATEMENT.CREATE_USER_ID = T_USER.ID where T_STATEMENT.ID = ?", 
					statementId);
				message.resource("statement", statement);

				Data substatements = datasource.find("select T_USER.NAME as 'USERNAME', T_USER.ICON as 'USERICON', T_SUBSTATEMENT.* from T_SUBSTATEMENT left join T_USER on T_SUBSTATEMENT.MANAGER_USER_ID = T_USER.ID where T_SUBSTATEMENT.STATEMENT_ID = ? order by T_SUBSTATEMENT.CREATE_DATE desc", 
					statementId);
				
				String createuser = statement.getString("CREATE_USER_ID");
				if(createuser.equals(sessionuser.getId()))
				{
					//如果当前人员是总项目负责人
					message.resource("substatements", substatements);
					statement.put("ISCREATOR", "1");
				}
				else
				{
					statement.put("ISCREATOR", "0");
					//当前人员管理的子项目（包括下级）
					Set<Datum> container = new HashSet<Datum>();
					for(Datum substatement : substatements)
					{
						String manageruesr = substatement.getString("MANAGER_USER_ID");
						if(manageruesr.equals(sessionuser.getId()))
						{
							container.add(substatement);
							container.addAll(getChildSubStatements(new HashSet<Datum>(), substatement, substatements));
						}
					}
					
					for(Datum substatement : container)
					{
						substatement.remove("ISFIND");
					}
					
					//当前人员工作的子项目
					Data statements = datasource.find("select T_USER.NAME as 'USERNAME', T_USER.ICON as 'USERICON', T_SUBSTATEMENT.* from T_SUBSTATEMENT left join T_USER on T_SUBSTATEMENT.MANAGER_USER_ID = T_USER.ID where T_SUBSTATEMENT.ID in (select SUBSTATEMENT_ID from T_STATEMENT_TRANSACTOR where TRANSACTOR_USER_ID = ?  group by SUBSTATEMENT_ID) order by T_SUBSTATEMENT.CREATE_DATE desc", 
						sessionuser.getId());

					container.addAll(statements);

					//设置当前人员是否是子项目的管理员
					for(Datum substatement : container)
					{
						String manageruesr = substatement.getString("MANAGER_USER_ID");
						if(manageruesr.equals(sessionuser.getId()))
						{
							substatement.put("ISMANAGER", "1");
						}
						else
						{
							substatement.put("ISMANAGER", "0");
						}
					}
					message.resource("substatements", container);
				}
				

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
		else if(mode.equals("6"))
		{
			String ismerge = StringUtils.defaultString(request.getParameter("merge"), "0");
			String statementId = StringUtils.defaultString(request.getParameter("statement"), "");
			String substatementId = StringUtils.defaultString(request.getParameter("substatement"), "");
			Connection connection = null;
			try
			{
				
				connection = DataSource.connection(SystemProperty.DATASOURCE);	
				DataSource datasource = new DataSource(connection);	
				
				Datum statement = datasource.get("select * from T_STATEMENT where ID = ?", statementId);
				Data substatements = datasource.find("select * from T_SUBSTATEMENT where STATEMENT_ID = ?", statementId);
				Datum substatement = null;
				if(statement != null)
				{
					boolean iscreaotr = statement.getString("CREATE_USER_ID").equals(sessionuser.getId());
					boolean ismanager = false;
					for(Datum item : substatements)
					{
						if(item.getString("ID").equals(substatementId))
						{
							ismanager = item.getString("MANAGER_USER_ID").equals(sessionuser.getId());
							substatement = item;
						}
					}
					
					String[] substatementIds = new String[]{};
					Data sheets = null;
					/*
						取出项目表格
							查看总项目：取出所有表格（总项目对应的表格）
							相差子项目：
								项目创建人：取出该子项目中的所有表格
								子项目负责人：取出该子项目中的所有表格
								项目工作人员：取出自己负责的表格
					*/
					if(substatement == null)
					{
						sheets = datasource.find("select CODE as 'SHEETCODE', NAME as 'SHEETNAME' from T_SHEET where ID in (select SHEET_ID from T_STATEMENT_SHEET where STATEMENT_ID = ?)", statementId);
					}
					else
					{
						StringBuffer sql = new StringBuffer();
						sql.append("select T_USER.NAME as 'USERNAME', T_USER.ICON as 'USERICON', T_SHEET.CODE as 'SHEETCODE', T_SHEET.NAME as 'SHEETNAME', T_STATEMENT_TRANSACTOR.* from T_STATEMENT_TRANSACTOR ");
						sql.append("left join T_SHEET on T_STATEMENT_TRANSACTOR.SHEET_ID = T_SHEET.ID ");
						sql.append("left join T_USER on T_STATEMENT_TRANSACTOR.TRANSACTOR_USER_ID = T_USER.ID ");	
						if(ismanager || iscreaotr)
						{
							sql.append("where T_STATEMENT_TRANSACTOR.SUBSTATEMENT_ID = ?");		
							sheets = datasource.find(sql.toString(), substatementId);
						}
						else
						{
							sql.append("where T_STATEMENT_TRANSACTOR.SUBSTATEMENT_ID = ? and TRANSACTOR_USER_ID = ?");	
							sheets = datasource.find(sql.toString(), substatementId, sessionuser.getId());
						}					
						
						//找到当前子下面的下级项目
						Set<Datum> children = new HashSet<Datum>();
						children.addAll(getChildSubStatements(new HashSet<Datum>(), substatement, substatements));
						children.add(substatement);
						for(Datum child : children)
						{
							substatementIds = ArrayUtils.add(substatementIds, "'"+child.getString("ID")+"'");
						}
					}

					
					for(Datum sheet : sheets)
					{
						String code = StringUtils.defaultString(sheet.getString("SHEETCODE"), "");
						if(!code.equals(""))
						{
							DataStructure datastructure = SystemProperty.DATASTRUCTURES.get(code);
							String tablename = datastructure.getProperty().optString("name");
							Datum count = null;
							
							/*
								取出表格数据
									合并数据：
									    查看总项目：取出该项目中所有表格数据，根据项目ID得到数据
									    查看子项目：取出子项目的所有数据，包括下级子项目
									不合并数据：取出子项目中的所有数据，根据子项目ID得到表格数据
							*/
							
							if(ismerge.equals("1"))
							{
								if(substatement == null)
								{
									count = datasource.get("select count(ID) as 'COUNT' from "+tablename+" where STATEMENT_ID = ?", statementId);
								}
								else
								{
									count = datasource.get("select count(ID) as 'COUNT' from "+tablename+" where SUBSTATEMENT_ID in ("+StringUtils.join(substatementIds, ",")+")");
								}
							}
							else
							{
								count = datasource.get("select count(ID) as 'COUNT' from "+tablename+" where SUBSTATEMENT_ID = ?", substatementId);
							}
							sheet.put("COUNT", count.getInt("COUNT"));
						}
						
					}
					message.resource("sheets", sheets);
					message.resource("children", substatementIds);
				}
				

			}
			catch(Exception e)
			{
				Throwable throwable = ThrowableUtils.getThrowable(e);
				message.message(ServiceMessage.FAILURE, throwable.getMessage());
				e.printStackTrace();
			}
			finally
			{
				if(connection != null)
				{
					connection.close();
				}
			}	
		}
		else if(mode.equals("7"))
		{
			String statementId = StringUtils.defaultString(request.getParameter("statement"), "");
			
			Connection connection = null;
			try
			{
				connection = DataSource.connection(SystemProperty.DATASOURCE);	
				DataSource datasource = new DataSource(connection);	
				Data substatements = datasource.find("select T_USER.NAME as 'USERNAME', T_USER.ICON as 'USERICON', T_SUBSTATEMENT.* from T_SUBSTATEMENT left join T_USER on T_SUBSTATEMENT.MANAGER_USER_ID = T_USER.ID where T_SUBSTATEMENT.STATEMENT_ID = ? order by T_SUBSTATEMENT.CREATE_DATE desc", 
						statementId);
				message.resource("substatements", substatements);
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
		else if(mode.equals("test"))
		{
		}
	}
	else
	{
		message.message(ServiceMessage.FAILURE, "登录用户失效，请重新登录。");
	}
	
	out.println(message);
%>

<%!

	public Set<Datum> getChildSubStatements(Set<Datum> container, Datum parent, Data substatements)
	{
		if(parent != null)
		{
			for(Datum substatement : substatements)
			{
				if(substatement.getString("PARENT_ID").equals(parent.getString("ID")))
				{
					container.add(substatement);
					if(substatement.getString("ISFIND").equals(""))
					{
						container.addAll(getChildSubStatements(new HashSet<Datum>(), substatement, substatements));
					}
				}
			}
			
			//表示该节点已查找子节点，不必再次查找，防止父子节点设置错误导致死循环
			parent.put("ISFIND", "1");
		}
		return container;
	}

%>