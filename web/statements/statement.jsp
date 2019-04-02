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
				Data statements = datasource.find("select T_USER.NAME as 'USERNAME', T_USER.ICON as 'USERICON', T_STATEMENT.* from T_STATEMENT left join T_USER on T_STATEMENT.CREATE_USER_ID = T_USER.ID where T_STATEMENT.ID in (select STATEMENT_ID from T_STATEMENT_TRANSACTOR where TRANSACTOR_USER_ID = ? and STATUS = ? group by STATEMENT_ID) or T_STATEMENT.ID in (select STATEMENT_ID from T_SUBSTATEMENT where MANAGER_USER_ID = ?)  or T_STATEMENT.ID in (select STATEMENT_ID from T_STATEMENT_SHARER where USER_ID = ? group by STATEMENT_ID) order by T_STATEMENT.CREATE_DATE desc", 
						sessionuser.getId(), status, sessionuser.getId(), sessionuser.getId());
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
			/* 分页查询所有项目 */
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
				
				
				Data sharers = datasource.find("select USER_ID from T_STATEMENT_SHARER where STATEMENT_ID = ?", statementId);
				String[] sharerIds = new String[]{};
				for(Datum sharer : sharers)
				{
					sharerIds = ArrayUtils.add(sharerIds, sharer.getString("USER_ID"));
				}
				statement.put("SHARERS", StringUtils.join(sharerIds, ","));
				
				message.resource("statement", statement);
				
				Data substatements = datasource.find("select T_USER.NAME as 'USERNAME', T_USER.ICON as 'USERICON', T_SUBSTATEMENT.* from T_SUBSTATEMENT left join T_USER on T_SUBSTATEMENT.MANAGER_USER_ID = T_USER.ID where T_SUBSTATEMENT.STATEMENT_ID = ? order by T_SUBSTATEMENT.CREATE_DATE desc", 
					statementId);

				
				String createuser = statement.getString("CREATE_USER_ID");
				if(createuser.equals(sessionuser.getId()))
				{
					//如果当前人员是总项目负责人
					message.resource("substatements", substatements);
					statement.put("ISCREATOR", "1");
					statement.put("ISSHARER", "0");
				}
				else if(ArrayUtils.contains(sharerIds, sessionuser.getId()))
				{
					//如果当前人员是项目共享人员
					message.resource("substatements", substatements);
					statement.put("ISCREATOR", "0");
					statement.put("ISSHARER", "1");
				}
				else
				{
					statement.put("ISCREATOR", "0");
					statement.put("ISSHARER", "0");
					
					//当前人可以管理的子项目
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
					
					
					//当前人填写表格所在的子项目（从当前人员可以操作的表格查找）
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
			String statementmode = StringUtils.defaultString(request.getParameter("statementmode"), "0");
			String statementId = StringUtils.defaultString(request.getParameter("statement"), "");
			String substatementId = StringUtils.defaultString(request.getParameter("substatement"), "");
			String manager = StringUtils.defaultString(request.getParameter("manager"), "");
			String share = StringUtils.defaultString(request.getParameter("sharer"), "");
			
			Connection connection = null;
			try
			{
				connection = DataSource.connection(SystemProperty.DATASOURCE);	
				DataSource datasource = new DataSource(connection);	
				ConfigService configService = new ConfigService("0001");
				
				//得到项目的日志
				Datum log = datasource.get("select T_CREATOR.NAME as 'CREATEUSERNAME', T_CREATOR.ICON as 'CREATEUSERICON', T_STATEMENT_LOG.CREATE_DATE, T_EDITOR.NAME as 'EDITUSERNAME', T_EDITOR.ICON as 'EDITUSERICON', T_STATEMENT_LOG.EDIT_DATE from T_STATEMENT_LOG left join T_USER as T_CREATOR on T_STATEMENT_LOG.CREATE_USER_ID = T_CREATOR.ID left join T_USER as T_EDITOR on T_STATEMENT_LOG.EDIT_USER_ID = T_EDITOR.ID where T_STATEMENT_LOG.SUBSTATEMENT_ID = ? and T_STATEMENT_LOG.MODE = ?", substatementId, statementmode);

				Data substatements = datasource.find("select * from T_SUBSTATEMENT where STATEMENT_ID = ?", statementId);
				//得到所选择的子项目
				Datum substatement = null;
				for(Datum item : substatements)
				{
					if(item.getString("ID").equals(substatementId))
					{
						substatement = item;
					}
				}
				
				//得到项目表格
				Data sheets = null;
				if(manager.equals("1") || share.equals("1"))
				{	
					sheets = datasource.find("select T_USER.NAME as 'USERNAME', T_USER.ID as 'USERID', T_USER.ICON as 'USERICON', T_STATEMENT_TRANSACTOR.ID, T_STATEMENT_TRANSACTOR.SHEET_ID from T_STATEMENT_TRANSACTOR left join T_USER on T_STATEMENT_TRANSACTOR.TRANSACTOR_USER_ID = T_USER.ID where T_STATEMENT_TRANSACTOR.SUBSTATEMENT_ID = ?", substatementId);
					
				}
				else
				{
					sheets = datasource.find("select T_USER.NAME as 'USERNAME', T_USER.ID as 'USERID', T_USER.ICON as 'USERICON', T_STATEMENT_TRANSACTOR.ID, T_STATEMENT_TRANSACTOR.SHEET_ID from T_STATEMENT_TRANSACTOR left join T_USER on T_STATEMENT_TRANSACTOR.TRANSACTOR_USER_ID = T_USER.ID where T_STATEMENT_TRANSACTOR.SUBSTATEMENT_ID = ? and TRANSACTOR_USER_ID = ?", substatementId, sessionuser.getId());
				}

				//找到当前子项目下的下级项目（包括当前子项目）
				String[] substatementIds = new String[]{};
				Set<Datum> children = new HashSet<Datum>();
				children.addAll(StatementUtils.getChildSubStatements(new HashSet<Datum>(), substatement, substatements));
				children.add(substatement);
				for(Datum child : children)
				{
					substatementIds = ArrayUtils.add(substatementIds, "'"+child.getString("ID")+"'");
				}
				
				
				for(Datum sheet : sheets)
				{
					String sheetId = StringUtils.defaultString(sheet.getString("SHEET_ID"), "");
					
					if(!sheetId.equals(""))
					{
						JSONObject sheetconfig = configService.getSheet(sheetId);	
						

						//得到每个表格的数据量
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
										if(statementmode.equals("0"))
										{
											countmap = datasource.get("select count(ID) as 'COUNT' from "+tablename+" where SUBSTATEMENT_ID = ? and MODE = 0", substatementId);
										}
										else if(statementmode.equals("1"))
										{
											countmap = datasource.get("select count(ID) as 'COUNT' from "+tablename+" where SUBSTATEMENT_ID = ? and MODE = 1", substatementId);
										}
										else if(statementmode.equals("2"))
										{
											countmap = datasource.get("select count(ID) as 'COUNT' from "+tablename+" where SUBSTATEMENT_ID in ("+StringUtils.join(substatementIds, ",")+") and MODE = 0");
										}
										count += countmap.getInt("COUNT");
									}
								}
							}
						}
						
						//是否拥有表格的编辑权限
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
						sheet.put("SHEETTYPE", sheetconfig.optString("type"));
						sheet.put("CAPTION", sheetconfig.optString("caption"));
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
				message.resource("log", log);
				message.resource("children", substatementIds);
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