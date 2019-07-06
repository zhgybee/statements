<%@page import="org.json.JSONException"%>
<%@page import="com.system.datastructure.DataStructure"%>
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
			String statementmode = StringUtils.defaultString(request.getParameter("statementmode"), "");
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
				
				

				DataStructure datastructure = SystemProperty.DATASTRUCTURES.get("T0001");
				Data data = null;
				if(statementmode.equals("2") || statementmode.equals("1"))
				{
					StringBuffer sql = new StringBuffer();
					
					//合并抵消或哈达：审定前为所有单表审定后的合计，调整分录取合并抵消环境下的数据

					
					//得到所有单体审定后合计
					data = datasource.find("select * from V01 where SUBSTATEMENT_ID in ("+children+") and MODE = '0'");
					//合并审定前及调整分录
					data = SystemUtils.merge(data, datastructure.getProperty().optJSONArray("columns"));
					//计算审定后
					data = flush(items, data);
					
					//得到合并抵消环境下的调整分类
					Data qmjftzs = datasource.find("select JFKM, sum(JFJE) as 'JFJE' from T02 where SUBSTATEMENT_ID = ? and MODE = '1' group by JFKM", substatementId);
					Data qmdftzs = datasource.find("select DFKM, sum(DFJE) as 'DFJE' from T02 where SUBSTATEMENT_ID = ? and MODE = '1' group by DFKM", substatementId);
					Data qcjftzs = datasource.find("select JFKM, sum(JFJE) as 'JFJE' from T03 where SUBSTATEMENT_ID = ? and MODE = '1' group by JFKM", substatementId);
					Data qcdftzs = datasource.find("select DFKM, sum(DFJE) as 'DFJE' from T03 where SUBSTATEMENT_ID = ? and MODE = '1' group by DFKM", substatementId);

					Map<String, String> qmjftzmap = new HashMap<String, String>();
					for(Datum qmjftz : qmjftzs)
					{
						qmjftzmap.put(qmjftz.getString("JFKM"), qmjftz.getString("JFJE"));
					}
					Map<String, String> qmdftzmap = new HashMap<String, String>();
					for(Datum qmdftz : qmdftzs)
					{
						qmdftzmap.put(qmdftz.getString("DFKM"), qmdftz.getString("DFJE"));
					}
					Map<String, String> qcjftzmap = new HashMap<String, String>();
					for(Datum qcjftz : qcjftzs)
					{
						qcjftzmap.put(qcjftz.getString("JFKM"), qcjftz.getString("JFJE"));
					}
					Map<String, String> qcdftzmap = new HashMap<String, String>();
					for(Datum qcdftz : qcdftzs)
					{
						qcdftzmap.put(qcdftz.getString("DFKM"), qcdftz.getString("DFJE"));
					}
					
					for(Datum datum : data)
					{
						String name = datum.getString("XMBH");
						//审定后转为审定前
						datum.put("QMSDQ", datum.get("QMSDH"));
						datum.put("QCSDQ", datum.get("QCSDH"));
						
						//设置调整分录为合并抵消环境下的调整分类
						datum.put("QMJFJE", qmjftzmap.get(name));
						datum.put("QMDFJE", qmdftzmap.get(name));
						datum.put("QCJFJE", qcjftzmap.get(name));
						datum.put("QCDFJE", qcdftzmap.get(name));
					}
				}
				else if(statementmode.equals("0"))
				{
					//单体：试算表直接取单体环境下子项目数据
					data = datasource.find("select * from V01 where SUBSTATEMENT_ID = ? and MODE = '0'", substatementId);
				}
				
				
				
				Map<String, Datum> itemmap = new HashMap<String, Datum>();
				for(Datum datum : data)
				{
					itemmap.put(datum.getString("XMBH"), datum);
				}
				JSONArray resources = flush(items, itemmap);
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
				//改成通过项目id和科目编号取得数据20190706（在一次性发起多条填数时，如果是同行数据填写，两个输入框都会没有key，最终导致都是新增）
				String key = StringUtils.defaultString(request.getParameter("key"), "");
				String value = request.getParameter("value");
				connection = DataSource.connection(SystemProperty.DATASOURCE);
				DataSource datasource = new DataSource(connection);	

				String statementId = request.getParameter("statement");
				String substatementId = request.getParameter("substatement");
				String statementmode = request.getParameter("statementmode");
				String itemname = request.getParameter("itemname");
				String itemcode = request.getParameter("itemcode");
				
				Data data = datasource.find("select ID from "+tablename+" where STATEMENT_ID = ? and SUBSTATEMENT_ID = ? and XMBH = ?", statementId, substatementId, itemcode);
				
				if(data.size() == 0)
				{
					datasource.execute("insert into "+tablename+"(ID, XM, XMBH, "+columnname+", MODE, STATEMENT_ID, SUBSTATEMENT_ID, CREATE_USER_ID, CREATE_DATE) values(?, ?, ?, ?, ?, ?, ?, ?, CURRENT_TIMESTAMP)", 
							SystemUtils.uuid(), itemname, itemcode, value, statementmode, statementId, substatementId, sessionuser.getId());
				}
				else
				{
					datasource.execute("update "+tablename+" set "+columnname+" = ?, CREATE_DATE = CURRENT_TIMESTAMP where STATEMENT_ID = ? and SUBSTATEMENT_ID = ? and XMBH = ?", value, statementId, substatementId, itemcode);
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
			String children = StringUtils.defaultString(request.getParameter("children"), "");
			Data substatements = null;
			Connection connection = null;
			try
			{
				connection = DataSource.connection(SystemProperty.DATASOURCE);	
				DataSource datasource = new DataSource(connection);	
				
				substatements = datasource.find("select * from T_SUBSTATEMENT where ID in ("+children+") order by CREATE_DATE");
				message.resource("substatements", substatements);
			}
			catch(Exception e)
			{ 
				Throwable throwable = ThrowableUtils.getThrowable(e);
				out.println(e.getMessage());
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

<%!


public Data flush(JSONArray items, Data data) throws JSONException
{
	Map<String, Datum> itemmap = new HashMap<String, Datum>();
	for(Datum datum : data)
	{
		itemmap.put(datum.getString("XMBH"), datum);
	}
	for(int i = 0 ; i < items.length() ; i++)
	{
		JSONObject item = items.optJSONObject(i);
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
		}
	}	
	return data;
}

public JSONArray flush(JSONArray items, Map<String, Datum> itemmap) throws JSONException
{
	JSONArray resources = new JSONArray();
	for(int i = 0 ; i < items.length() ; i++)
	{
		//防止修改内存中的配置文件
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
	return resources;
}


%>