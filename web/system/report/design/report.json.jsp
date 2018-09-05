
<%@page import="java.util.List"%>
<%@page import="com.system.datasource.DataSource"%>
<%@page import="java.sql.Connection"%>
<%@page import="org.apache.commons.lang3.StringUtils"%>
<%@page import="com.system.utils.ThrowableUtils"%>
<%@page import="org.json.JSONArray"%>
<%@page import="org.apache.commons.io.FileUtils"%>
<%@page import="org.json.JSONObject"%>
<%@page import="com.system.SystemProperty"%>
<%@page import="java.io.File"%>
<%@page contentType="text/html; charset=utf-8"%>

<%

	JSONObject result = new JSONObject();

	String id = request.getParameter("id");
	String bit = StringUtils.defaultString(request.getParameter("bit"), "0");
	File file = new File(SystemProperty.PATH + SystemProperty.FILESEPARATOR +"system"+SystemProperty.FILESEPARATOR+"report"+SystemProperty.FILESEPARATOR+"config"+SystemProperty.FILESEPARATOR + id+".json");

	String code = "0";
	try
	{
		JSONObject report = new JSONObject(FileUtils.readFileToString(file, "UTF-8"));
		
		if(bit.equals("0"))
		{
			report.remove("ITEMS");
			result.put("MESSAGE", report);
		}
		else if(bit.equals("1"))
		{
			String row = request.getParameter("row");
			String col = request.getParameter("col");
			
			JSONArray items = report.optJSONArray("ITEMS");
			for(int i = 0 ; i < items.length() ; i++)
			{
				JSONObject item = items.optJSONObject(i);
				if(row.equals(item.optString("ROW")) && col.equals(item.optString("COL")))
				{
					result.put("MESSAGE", item);
					break;
				}
			}
		}
		else if(bit.equals("2"))
		{
			JSONObject itemmap = new JSONObject();
			JSONArray items = report.optJSONArray("ITEMS");
			for(int i = 0 ; i < items.length() ; i++)
			{
				JSONObject item = items.optJSONObject(i);
				itemmap.put(item.optString("ROW")+"-"+item.optString("COL"), "1");
			}
			result.put("MESSAGE", itemmap);
		}
		else if(bit.equals("3"))
		{
			JSONArray names = new JSONArray();
			
			String key = request.getParameter("key");
			JSONObject source = report.optJSONObject("SOURCE");
			JSONObject sqls = source.optJSONObject("SQLS");
			JSONObject sql = sqls.getJSONObject(key);

			Connection connection = null;
			try
			{
				connection = DataSource.connection(SystemProperty.DATASOURCE);
				DataSource datasource = new DataSource(connection);
				List<String> columnnames = datasource.getColumnNames(sql.optString("SQL"));
				for(String columnname : columnnames)
				{
					names.put(columnname);
				}
				result.put("MESSAGE", names);
			}
			catch(Exception e)
			{
				Throwable throwable = ThrowableUtils.getThrowable(e);
				String message = throwable.getMessage();
				result.put("MESSAGE", message);
				code = "1";
			}
			finally
			{
				if(connection != null)
				{
					if(!connection.isClosed())
					{
						connection.close();
					}
				}
			}
		}
	}
	catch(Exception e)
	{
		Throwable throwable = ThrowableUtils.getThrowable(e);
		result.put("MESSAGE", throwable.getMessage());
		code = "1";
	}

	result.put("CODE", code);
	out.println(result);
%>
