<%@page import="com.system.utils.StatementUtils"%>
<%@page import="org.apache.commons.lang3.math.NumberUtils"%>
<%@page import="java.util.Comparator"%>
<%@page import="java.util.Collections"%>
<%@page import="com.statement.ConfigService"%>
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
			int pagenumber = NumberUtils.toInt(request.getParameter("pagenumber"), 1);
			int pagesize = NumberUtils.toInt(request.getParameter("pagesize"), 10);
			String searcher = StringUtils.defaultString(request.getParameter("searcher"), "");
			Connection connection = null;
			try
			{
				connection = DataSource.connection(SystemProperty.DATASOURCE);	
				DataSource datasource = new DataSource(connection);	
				Data statements = null;
				Datum total = null;
				
				if(searcher.equals(""))
				{
					String sql = "select T_USER.NAME as 'USERNAME', T_USER.ICON as 'USERICON', T_STATEMENT.* from T_STATEMENT left join T_USER on T_STATEMENT.CREATE_USER_ID = T_USER.ID where T_STATEMENT.CREATE_USER_ID = ? order by CREATE_DATE desc";
					statements = datasource.find(datasource.toPage(sql, pagenumber, pagesize), sessionuser.getId());				
					sql = "select count(ID) as 'COUNT' from T_STATEMENT where CREATE_USER_ID = ?";
					total = datasource.get(sql, sessionuser.getId());
				}
				else
				{
					String sql = "select T_USER.NAME as 'USERNAME', T_USER.ICON as 'USERICON', T_STATEMENT.* from T_STATEMENT left join T_USER on T_STATEMENT.CREATE_USER_ID = T_USER.ID where (T_STATEMENT.TITLE like ? or T_STATEMENT.DESCRIPTION like ?) and T_STATEMENT.CREATE_USER_ID = ? order by CREATE_DATE desc";
					statements = datasource.find(datasource.toPage(sql, pagenumber, pagesize), "%"+searcher+"%", "%"+searcher+"%", sessionuser.getId());				
					sql = "select count(ID) as 'COUNT' from T_STATEMENT where (T_STATEMENT.TITLE like ? or T_STATEMENT.DESCRIPTION like ?) and CREATE_USER_ID = ?";
					total = datasource.get(sql, "%"+searcher+"%", "%"+searcher+"%", sessionuser.getId());
				}
				
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
				message.resource("total", total.getInt("COUNT"));
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

				Data sheets = datasource.find("select SHEET_ID as 'id' from T_STATEMENT_SHEET where STATEMENT_ID = ?", statementId);
				statement.put("SHEETS", sheets);
				
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
					
					//当前人可以操作的项目
					Set<Datum> container = new HashSet<Datum>();

					//当前人员管理的子项目（包括下级）
					//遍历所有项目，查找当前人所管理的项目（包括下级项目），并把这些项目全部设置管理标志
					for(Datum substatement : substatements)
					{
						String manageruesr = substatement.getString("MANAGER_USER_ID");
						if(manageruesr.equals(sessionuser.getId()))
						{
							container.add(substatement);
							container.addAll(StatementUtils.getChildSubStatements(new HashSet<Datum>(), substatement, substatements));
						}
					}
					Set<String> exist = new HashSet<String>();
					for(Datum substatement : container)
					{
						substatement.remove("ISFIND");
						substatement.put("MANAGER", "1");
						exist.add(substatement.getString("ID"));
					}
					
					
					//当前人填写表格所在的项目（从当前人员可以操作的表格查找）
					//设置管理标志位为0
					Data statements = datasource.find("select T_USER.NAME as 'USERNAME', T_USER.ICON as 'USERICON', T_SUBSTATEMENT.* from T_SUBSTATEMENT left join T_USER on T_SUBSTATEMENT.MANAGER_USER_ID = T_USER.ID where T_SUBSTATEMENT.ID in (select SUBSTATEMENT_ID from T_STATEMENT_TRANSACTOR where TRANSACTOR_USER_ID = ?  group by SUBSTATEMENT_ID) and T_SUBSTATEMENT.STATEMENT_ID = ? order by T_SUBSTATEMENT.CREATE_DATE desc", 
						sessionuser.getId(), statementId);
					
					for(Datum substatement : statements)
					{
						if(!exist.contains(substatement.getString("ID")))
						{
							substatement.put("MANAGER", "0");
							container.add(substatement);
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
			String manager = StringUtils.defaultString(request.getParameter("manager"), "");
			
			Connection connection = null;
			try
			{
				connection = DataSource.connection(SystemProperty.DATASOURCE);	
				DataSource datasource = new DataSource(connection);	
				
				ConfigService configService = new ConfigService("0001");
				
				//总项目
				Datum statement = datasource.get("select * from T_STATEMENT where ID = ?", statementId);
				Data substatements = datasource.find("select * from T_SUBSTATEMENT where STATEMENT_ID = ?", statementId);
				Datum substatement = null;
				if(statement != null)
				{
					//得到所选择的子项目
					for(Datum item : substatements)
					{
						if(item.getString("ID").equals(substatementId))
						{
							substatement = item;
						}
					}
					
					//子项目的下级项目
					String[] substatementIds = new String[]{};
					

					/*
						得到项目表格
							查看总项目（没有选择子项目）：取出所有表格（总项目对应的表格）
							查看子项目：
								负责人（manager）：取所有表格
								项目工作人员：取出自己负责的表格
					*/
					Data sheets = null;
					if(substatement == null)
					{
						sheets = datasource.find("select SHEET_ID from T_STATEMENT_SHEET where STATEMENT_ID = ?", statementId);
						for(Datum child : substatements)
						{
							substatementIds = ArrayUtils.add(substatementIds, "'"+child.getString("ID")+"'");
						}
					}
					else
					{
						StringBuffer sql = new StringBuffer();
						sql.append("select T_USER.NAME as 'USERNAME', T_USER.ID as 'USERID', T_USER.ICON as 'USERICON', T_STATEMENT_TRANSACTOR.ID, T_STATEMENT_TRANSACTOR.SHEET_ID from T_STATEMENT_TRANSACTOR ");
						sql.append("left join T_USER on T_STATEMENT_TRANSACTOR.TRANSACTOR_USER_ID = T_USER.ID ");	
						if(manager.equals("1"))
						{
							sql.append("where T_STATEMENT_TRANSACTOR.SUBSTATEMENT_ID = ?");		
							sheets = datasource.find(sql.toString(), substatementId);
						}
						else
						{
							sql.append("where T_STATEMENT_TRANSACTOR.SUBSTATEMENT_ID = ? and TRANSACTOR_USER_ID = ?");	
							sheets = datasource.find(sql.toString(), substatementId, sessionuser.getId());
						}
						
						//找到当前子项目下的下级项目（包括当前子项目）
						Set<Datum> children = new HashSet<Datum>();
						children.addAll(StatementUtils.getChildSubStatements(new HashSet<Datum>(), substatement, substatements));
						children.add(substatement);
						for(Datum child : children)
						{
							substatementIds = ArrayUtils.add(substatementIds, "'"+child.getString("ID")+"'");
						}
					}

					for(Datum sheet : sheets)
					{
						String sheetId = StringUtils.defaultString(sheet.getString("SHEET_ID"), "");
						
						if(!sheetId.equals(""))
						{
							JSONObject sheetconfig = configService.getSheet(sheetId);	
							
							
							
							int count = 0;
							JSONArray tables = sheetconfig.optJSONArray("tables");
							if(tables != null)
							{
								for(int i = 0 ; i < tables.length() ; i++)
								{
									JSONObject table = tables.optJSONObject(i);
									String tablecode = table.optString("id");
									if(!tablecode.equals(""))
									{
										DataStructure datastructure = SystemProperty.DATASTRUCTURES.get(tablecode);
										if(datastructure != null)
										{
											String tablename = datastructure.getProperty().optString("table");
											Datum countmap = null;
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
													countmap = datasource.get("select count(ID) as 'COUNT' from "+tablename+" where STATEMENT_ID = ?", statementId);
												}
												else
												{
													countmap = datasource.get("select count(ID) as 'COUNT' from "+tablename+" where SUBSTATEMENT_ID in ("+StringUtils.join(substatementIds, ",")+")");
												}
											}
											else
											{
												countmap = datasource.get("select count(ID) as 'COUNT' from "+tablename+" where SUBSTATEMENT_ID = ?", substatementId);
											}
											count += countmap.getInt("COUNT");
										}
									}
								}
							}
							
							boolean isEditor = false;	
							if(sheet.getString("USERID").equals(sessionuser.getId()))
							{
								isEditor = true;
							}
							else
							{
								isEditor = false;
							}

							
							sheet.put("EDITOR", isEditor);
							sheet.put("SHEETNAME", sheetconfig.optString("name"));
							sheet.put("MANAGERTABLE", sheetconfig.optString("manager"));
							sheet.put("SORT", sheetconfig.optString("sort"));
							sheet.put("COUNT", count);
						}
						
					}
					
					Collections.sort(sheets, new Comparator<Datum>() 
					{
						public int compare(Datum d1, Datum d2) 
						{
							if(d1.getInt("SORT") > d2.getInt("SORT"))
							{
								return 1;
							}
							else
							{
								return -1;
							}
						}
					});
					
					
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
	}
	else
	{
		message.message(ServiceMessage.FAILURE, "登录用户失效，请重新登录。");
	}
	
	out.println(message);
%>