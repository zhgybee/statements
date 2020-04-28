<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
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
			
			JSONArray sheetitems =  configService.getItems(sheetIds);
			
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
				data = flush(sheetitems, data);
				
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
			
			Map<String, Map<String, Datum>> resources = new HashMap<String, Map<String, Datum>>();
			
			Map<String, Datum> items = new HashMap<String, Datum>();
			for(Datum datum : data)
			{
				items.put(datum.getString("XMBH"), datum);
			}
			resources.put("T01", items);
			
			

			datastructure = SystemProperty.DATASTRUCTURES.get("T0002");
			data = null;
			if(statementmode.equals("2") || statementmode.equals("1"))
			{
				//合并抵消或哈达：审定前为所有单表审定后（审定前+调整）的合计，调整分录取合并抵消环境下的数据

				data = datasource.find("select * from T05 where SUBSTATEMENT_ID in ("+children+") and MODE = '0'");
				for(Datum datum : data)
				{
					datum.put("BQSDQ", datum.getDouble("BQSDQ") + datum.getDouble("BQTZS"));
					datum.put("SQSDQ", datum.getDouble("SQSDQ") + datum.getDouble("SQTZS"));
				}
				data = SystemUtils.merge(data, datastructure.getProperty().optJSONArray("columns"));

				
				//得到合并抵消环境下的调整数
				Data changers = datasource.find("select * from T05 where SUBSTATEMENT_ID  = ?  and MODE = '1'", substatementId);
				Map<String, String> changermap = new HashMap<String, String>();
				for(Datum changer : changers)
				{
					changermap.put("BQ"+changer.getString("BM"), changer.getString("BQTZS"));
					changermap.put("SQ"+changer.getString("BM"), changer.getString("SQTZS"));
				}

				for(Datum datum : data)
				{
					datum.put("BQTZS", changermap.get("BQ"+datum.getString("BM")));
					datum.put("SQTZS", changermap.get("BQ"+datum.getString("BM")));
				}


			}
			else if(statementmode.equals("0"))
			{
				data = datasource.find("select * from T05 where SUBSTATEMENT_ID = ? and MODE = 0", substatementId);
			}


			items = new HashMap<String, Datum>();
			for(Datum datum : data)
			{
				items.put(datum.getString("BM"), datum);
			}
			resources.put("T05", items);
			
			

			datastructure = SystemProperty.DATASTRUCTURES.get("T0003");
			data = null;
			if(statementmode.equals("2") || statementmode.equals("1"))
			{
				//合并抵消或哈达：取所有单表的合并数据
				String sql = "select * from T04 where SUBSTATEMENT_ID in ("+children+") and MODE = '0'";
				data = datasource.find(sql);
				data = SystemUtils.merge(data, datastructure.getProperty().optJSONArray("columns"));
			}
			else if(statementmode.equals("0"))
			{
				String sql = "select * from T04 where SUBSTATEMENT_ID = ? and MODE = '0'";
				data = datasource.find(sql, substatementId);
			}

			for(Datum datum : data)
			{
				items.put(datum.getString("BM"), datum);
			}
			resources.put("T03", items);
			
			
			

			datastructure = SystemProperty.DATASTRUCTURES.get("T0004");
			data = null;
			if(statementmode.equals("2") || statementmode.equals("1"))
			{
				//合并抵消或哈达：取所有单表的合并数据
				String sql = "select * from T06 where SUBSTATEMENT_ID in ("+children+") and MODE = '0'";
				data = datasource.find(sql);
				data = SystemUtils.merge(data, datastructure.getProperty().optJSONArray("columns"));
			}
			else if(statementmode.equals("0"))
			{
				String sql = "select * from T06 where SUBSTATEMENT_ID = ? and MODE = '0'";
				data = datasource.find(sql, substatementId);
			}

			for(Datum datum : data)
			{
				items.put(datum.getString("BM"), datum);
			}
			resources.put("T06", items);
			
			message.resource("resources", resources);
			
			
			
			
			
			
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



%>