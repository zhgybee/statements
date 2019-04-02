
<%@page import="com.system.datastructure.DataStructure"%>
<%@page import="java.util.HashSet"%>
<%@page import="com.system.utils.SystemUtils"%>
<%@page import="java.util.Set"%>
<%@page import="java.util.Map"%>
<%@page import="org.json.JSONObject"%>
<%@page import="org.apache.commons.lang3.ArrayUtils"%>
<%@page import="com.statement.ConfigService"%>
<%@page import="com.system.datasource.Datum"%>
<%@page import="com.system.datasource.Data"%>
<%@page import="com.system.utils.ThrowableUtils"%>
<%@page import="com.system.datasource.DataSource"%>
<%@page import="java.sql.Connection"%>
<%@page import="org.apache.commons.lang3.StringUtils"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="com.system.Gatherer"%>
<%@page import="java.io.File"%>
<%@page import="com.system.SystemProperty"%>
<%@page import="org.apache.commons.io.FileUtils"%>
<%@page import="org.json.JSONArray"%>
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
			String statementId = StringUtils.defaultString(request.getParameter("statement"), "");
			String substatementId = StringUtils.defaultString(request.getParameter("substatement"), "");
			String statementmode = StringUtils.defaultString(request.getParameter("statementmode"), "0");
			
			Connection connection = null;
			String[] sheetIds = new String[]{};
			
			//得到当前用户在一个分项目内可以操作的表格
			try
			{
				connection = DataSource.connection(SystemProperty.DATASOURCE);	
				DataSource datasource = new DataSource(connection);	
				Data transactors = datasource.find("select * from T_STATEMENT_TRANSACTOR where SUBSTATEMENT_ID = ? and TRANSACTOR_USER_ID = ?", 
						substatementId, sessionuser.getId());
				for(Datum transactor : transactors)
				{
					sheetIds = ArrayUtils.add(sheetIds, transactor.getString("SHEET_ID"));
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
			
			//根据表格得到数据库表
			String[] tableIds = new String[]{};
			
			ConfigService configService = new ConfigService("0001");
			JSONArray tables = configService.getTables(sheetIds);
			for(int i = 0 ; i < tables.length() ; i++)
			{
				JSONObject table = tables.optJSONObject(i);
				if(table.optBoolean("import"))
				{
					tableIds = ArrayUtils.add(tableIds, table.optString("id"));
				}
			}
			
			//根据所能操作的数据库表，取得excel中的数据，并导入相应的表中
			String folder = request.getParameter("folder");
			String name = request.getParameter("name");
			
			File source = new File(SystemProperty.PATH + SystemProperty.FILESEPARATOR + folder + SystemProperty.FILESEPARATOR + name);
			JSONObject configs = new JSONObject(FileUtils.readFileToString(new File(SystemProperty.PATH + SystemProperty.FILESEPARATOR + "config" + SystemProperty.FILESEPARATOR + "import.json"), "UTF-8"));
		
	
			Gatherer gatherer = new Gatherer();
			gatherer.source = source;
			gatherer.configs = configs;
			
			if(gatherer.startor(tableIds))
			{
			
				List<String> sqls = new ArrayList<String>();
				
				Set<String> removeitems = new HashSet<String>();
				for(Gatherer.Dataset dataset : gatherer.datasets)
				{
					String tablename = dataset.tableName;
	
					removeitems.add(tablename);
					
					Map<String, String> values = dataset.values;	
					Set<String> columns = values.keySet();
					
					String[] cs = new String[]{};
					String[] vs = new String[]{};
					
					cs = ArrayUtils.add(cs, "ID");
					cs = ArrayUtils.add(cs, "STATUS");
					cs = ArrayUtils.add(cs, "STATEMENT_ID");
					cs = ArrayUtils.add(cs, "SUBSTATEMENT_ID");
					cs = ArrayUtils.add(cs, "MODE");
					cs = ArrayUtils.add(cs, "CREATE_USER_ID");
					cs = ArrayUtils.add(cs, "CREATE_DATE");
					
					vs = ArrayUtils.add(vs, "'"+SystemUtils.uuid()+"'");
					vs = ArrayUtils.add(vs, "'1'");
					vs = ArrayUtils.add(vs, "'"+statementId+"'");
					vs = ArrayUtils.add(vs, "'"+substatementId+"'");
					vs = ArrayUtils.add(vs, "'"+statementmode+"'");
					vs = ArrayUtils.add(vs, "'"+sessionuser.getId()+"'");
					vs = ArrayUtils.add(vs, "CURRENT_TIMESTAMP");
					
					for(String column : columns)
					{
						cs = ArrayUtils.add(cs, column);
						String value = values.get(column);
						value = StringUtils.replace(value, "'", "''");					
						vs = ArrayUtils.add(vs, "'"+value+"'");
					}
					
					String sql = "insert into "+tablename+"("+StringUtils.join(cs, ", ")+") values("+StringUtils.join(vs, ", ")+")";
					sqls.add(sql);
				}
				
				for(String removeitem : removeitems)
				{
					sqls.add(0, "delete from "+removeitem+" where SUBSTATEMENT_ID = '"+substatementId+"' and MODE = '"+statementmode+"'");
				}
				
				try
				{
					connection = DataSource.connection(SystemProperty.DATASOURCE);	
					DataSource datasource = new DataSource(connection);	
					for(String sql : sqls)
					{
						datasource.execute(sql);
					}
					
					Data logs = datasource.find("select ID from T_STATEMENT_LOG where SUBSTATEMENT_ID = ? and MODE = ?", substatementId, statementmode);
					if(logs.size() == 0)
					{
						datasource.execute("insert into T_STATEMENT_LOG(ID, SUBSTATEMENT_ID, EDIT_USER_ID, EDIT_DATE, MODE) values(?, ?, ?, datetime('now','localtime'), ?)", SystemUtils.uuid(), substatementId, sessionuser.getId(), statementmode);
					}
					else
					{
						datasource.execute("update T_STATEMENT_LOG set EDIT_USER_ID = ?, EDIT_DATE = datetime('now','localtime') where SUBSTATEMENT_ID = ? and MODE = ?", sessionuser.getId(), substatementId, statementmode);
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
			else
			{
				List<String> warnings = gatherer.warnings;
				for(String warning : warnings)
				{
					message.message(ServiceMessage.FAILURE, warning);
				}
			}
		}
		else if(mode.equals("2"))
		{
			String statementId = StringUtils.defaultString(request.getParameter("statement"), "");
			String substatementId = StringUtils.defaultString(request.getParameter("substatement"), "");
			String statementmode = StringUtils.defaultString(request.getParameter("statementmode"), "0");
			
			Connection connection = null;
			String[] sheetIds = new String[]{};
			
			//得到当前用户在一个分项目内可以操作的表格
			try
			{
				connection = DataSource.connection(SystemProperty.DATASOURCE);	
				DataSource datasource = new DataSource(connection);	
				Data transactors = datasource.find("select * from T_STATEMENT_TRANSACTOR where SUBSTATEMENT_ID = ? and TRANSACTOR_USER_ID = ?", 
						substatementId, sessionuser.getId());
				for(Datum transactor : transactors)
				{
					sheetIds = ArrayUtils.add(sheetIds, transactor.getString("SHEET_ID"));
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
			
			//根据表格得到数据库表
			String[] tableIds = new String[]{};
			
			ConfigService configService = new ConfigService("0001");
			JSONArray tables = configService.getTables(sheetIds);
			for(int i = 0 ; i < tables.length() ; i++)
			{
				JSONObject table = tables.optJSONObject(i);
				if(table.optBoolean("import"))
				{
					tableIds = ArrayUtils.add(tableIds, table.optString("id"));
				}
			}
			
			try
			{
				connection = DataSource.connection(SystemProperty.DATASOURCE);	
				DataSource datasource = new DataSource(connection);	

				int count = 0;
				
				for(String tableId : tableIds)
				{
					DataStructure datastructure = SystemProperty.DATASTRUCTURES.get(tableId);
					if(datastructure != null)
					{
						String tablename = datastructure.getProperty().optString("table");
						Datum countmap = datasource.get("select count(ID) as 'COUNT' from "+tablename+" where SUBSTATEMENT_ID = ? and MODE = ?", substatementId, statementmode);
						if(countmap.getInt("COUNT") > 0)
						{
							count = countmap.getInt("COUNT");
							break;
						}
					}
				}
				message.resource("count", count);
				
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