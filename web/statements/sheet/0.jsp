<%@page import="com.system.utils.SystemUtils"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashSet"%>
<%@page import="com.statement.ConfigService"%>
<%@page import="org.apache.commons.lang3.ArrayUtils"%>
<%@page import="org.json.JSONArray"%>
<%@page import="java.io.File"%>
<%@page import="org.apache.commons.io.FileUtils"%>
<%@page import="org.json.JSONObject"%>
<%@page import="com.system.datasource.Datum"%>
<%@page import="org.apache.commons.lang3.StringUtils"%>
<%@page import="com.system.utils.ThrowableUtils"%>
<%@page import="com.system.datasource.Data"%>
<%@page import="com.system.SystemProperty"%>
<%@page import="com.system.datasource.DataSource"%>
<%@page import="java.sql.Connection"%>
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
			String merge = StringUtils.defaultString(request.getParameter("merge"), "");
			String children = StringUtils.defaultString(request.getParameter("children"), "");
			
			Connection connection = null;
			try
			{
				connection = DataSource.connection(SystemProperty.DATASOURCE);	
				DataSource datasource = new DataSource(connection);	
				Data sheets = datasource.find("select * from T_STATEMENT_SHEET where STATEMENT_ID = ?", statementId);
				String[] sheetIds = new String[]{};
				for(Datum sheet : sheets)
				{
					sheetIds = ArrayUtils.add(sheetIds, sheet.getString("SHEET_ID"));
				}

				ConfigService configService = new ConfigService("0001");
				
				JSONArray items =  configService.getItems(sheetIds);
				
				StringBuffer sql = new StringBuffer();
				
				sql.append("select T01.*, QMJF.JFJE as 'QMJFJE', QMDF.DFJE as 'QMDFJE', QCJF.JFJE as 'QCJFJE', QCDF.DFJE as 'QCDFJE' from T01 ");
				sql.append("left join (select JFKM, sum(JFJE) as 'JFJE' from T02 where STATEMENT_ID = ? and SUBSTATEMENT_ID = ? and MERGE = ? group by JFKM) QMJF on T01.XMBH = QMJF.JFKM ");
				sql.append("left join (select DFKM, sum(DFJE) as 'DFJE' from T02 where STATEMENT_ID = ? and SUBSTATEMENT_ID = ? and MERGE = ? group by DFKM) QMDF on T01.XMBH = QMDF.DFKM ");
				sql.append("left join (select JFKM, sum(JFJE) as 'JFJE' from T03 where STATEMENT_ID = ? and SUBSTATEMENT_ID = ? and MERGE = ? group by JFKM) QCJF on T01.XMBH = QCJF.JFKM ");
				sql.append("left join (select DFKM, sum(DFJE) as 'DFJE' from T03 where STATEMENT_ID = ? and SUBSTATEMENT_ID = ? and MERGE = ? group by DFKM) QCDF on T01.XMBH = QCDF.DFKM ");
				sql.append("where T01.STATEMENT_ID = ? and T01.SUBSTATEMENT_ID = ? and MERGE = ?");
				
				Data data = datasource.find(sql.toString(), statementId, substatementId, merge, 
						statementId, substatementId, merge, 
						statementId, substatementId, merge, 
						statementId, substatementId, merge, 
						statementId, substatementId, merge);
				
				
				Map<String, Datum> itemmap = new HashMap<String, Datum>();
				for(Datum datum : data)
				{
					itemmap.put(datum.getString("XMBH"), datum);
				}
				
				//防止修改内存中的配置文件
				JSONArray resources = new JSONArray();
				for(int i = 0 ; i < items.length() ; i++)
				{
					JSONObject item = new JSONObject(items.optJSONObject(i).toString());
					String code = item.optString("code");
					Datum datum = itemmap.get(code);
					if(datum != null)
					{
						double qmsdh = 0;
						double qcsdh = 0;
						if(item.optString("mode").equals("1"))
						{
							qmsdh = datum.getDouble("QMSDQ") + datum.getDouble("QMJFJE") - datum.getDouble("QMDFJE");
							qcsdh = datum.getDouble("QCSDQ") + datum.getDouble("QCJFJE") - datum.getDouble("QCDFJE");
						}
						else
						{
							qmsdh = datum.getDouble("QMSDQ") - datum.getDouble("QMJFJE") + datum.getDouble("QMDFJE");
							qcsdh = datum.getDouble("QCSDQ") - datum.getDouble("QCJFJE") + datum.getDouble("QCDFJE");
						}
						datum.put("QMSDH", qmsdh);
						datum.put("QCSDH", qcsdh);
						item.put("resource", datum);
					}
					resources.put(item);
				}
				

				message.resource("itemmap", itemmap);
				message.resource("items", resources);
				
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
				String tablename = "T01";
				String columnname = request.getParameter("name");
				String key = StringUtils.defaultString(request.getParameter("key"), "");
				String value = request.getParameter("value");
				connection = DataSource.connection(SystemProperty.DATASOURCE);
				DataSource datasource = new DataSource(connection);	
				if(key.equals(""))
				{
					String statementId = request.getParameter("statement");
					String substatementId = request.getParameter("substatement");
					String merge = request.getParameter("merge");
					String itemname = request.getParameter("itemname");
					String itemcode = request.getParameter("itemcode");
					datasource.execute("insert into "+tablename+"(ID, XM, XMBH, "+columnname+", MERGE, STATEMENT_ID, SUBSTATEMENT_ID, CREATE_USER_ID, CREATE_DATE) values(?, ?, ?, ?, ?, ?, ?, ?, CURRENT_TIMESTAMP)", 
							SystemUtils.uuid(), itemname, itemcode, value, merge, statementId, substatementId, sessionuser.getId());
				}
				else
				{
					datasource.execute("update "+tablename+" set "+columnname+" = ?, CREATE_DATE = CURRENT_TIMESTAMP where ID = ?", value, key);
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