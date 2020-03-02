<%@page import="org.json.JSONException"%>
<%@page import="org.json.JSONArray"%>
<%@page import="java.io.File"%>
<%@page import="org.apache.commons.io.FileUtils"%>
<%@page import="org.json.JSONObject"%>
<%@page import="com.system.utils.StatementUtils"%>
<%@page import="java.util.HashSet"%>
<%@page import="java.util.Set"%>
<%@page import="org.apache.commons.lang3.ArrayUtils"%>
<%@page import="com.system.datasource.Datum"%>
<%@page import="com.system.utils.ServiceMessage"%>
<%@page import="com.system.utils.ThrowableUtils"%>
<%@page import="org.apache.commons.lang3.StringUtils"%>
<%@page import="com.system.datasource.Data"%>
<%@page import="com.system.SystemProperty"%>
<%@page import="com.system.datasource.DataSource"%>
<%@page import="java.sql.Connection"%>
<%@page contentType="text/html; charset=utf-8"%>

<%

	ServiceMessage message = new ServiceMessage();
	String statementmode = StringUtils.defaultString(request.getParameter("statementmode"), "0");
	String substatementId = StringUtils.defaultString(request.getParameter("substatement"), "");
	
	JSONObject configs = new JSONObject( FileUtils.readFileToString(new File(SystemProperty.PATH + SystemProperty.FILESEPARATOR + "config" + SystemProperty.FILESEPARATOR + "checkup.json"), "UTF-8" ));
	
	
	Connection connection = null;
	try
	{
		JSONArray warnings = new JSONArray();
		connection = DataSource.connection(SystemProperty.DATASOURCE);	
		DataSource datasource = new DataSource(connection);	
		
		JSONArray items = configs.optJSONArray(statementmode);
		
		
		for(int i = 0 ; i < items.length() ; i++)
		{
			JSONObject checkup =  items.optJSONObject(i);
			String description = checkup.optString("description");
			JSONObject item1 = checkup.optJSONObject("item1");
			JSONObject item2 = checkup.optJSONObject("item2");
			
			Data data1 = datasource.find(toSql(item1.optString("sql"), statementmode, substatementId));
			Data data2 = datasource.find(toSql(item2.optString("sql"), statementmode, substatementId));

			JSONArray details = warning(item1.optString("name"), item2.optString("name"), data1, data2);
			if(details.length() > 0)
			{
				JSONObject warning = new JSONObject();
				warning.put("details", details);
				warning.put("description", description);
				
				
				warnings.put(warning);
			}
		}
		
		
		
		message.resource("warnings", warnings);
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
	out.println(message);

%>

<%!
	public String toSql(String sql, String statementmode, String substatementId)
	{
		return "select * from ("+sql+") where SUBSTATEMENT_ID = '"+substatementId+"' and MODE = '"+statementmode+"'";
	}

	public JSONArray warning(String name1, String name2, Data data1, Data data2) throws JSONException
	{
		
		Datum datum1 = null;
		Datum datum2 = null;
		
		if(data1.size() > 0)
		{
			double count = 0;

			datum1 = new Datum();
			for(Datum datum : data1)
			{
				Set<String> keys = datum.keySet();
				for(String key : keys)
				{
					count += datum.getDouble(key);

					if(!key.equals("STATEMENT_ID") && !key.equals("SUBSTATEMENT_ID") && !key.equals("SUBSTATEMENT_ID"))
					{
						if(datum1.containsKey(key))
						{
							datum1.put(key, datum1.getDouble(key) + datum.getDouble(key));
						}
						else
						{
							datum1.put(key, datum.getDouble(key));
						}
					}
				}
			}
			
			//如果所有总数为0，也相当于未填
			if(count == 0)
			{
				datum1 = null;
			}
		}
		if(data2.size() > 0)
		{
			double count = 0;

			datum2 = new Datum();
			for(Datum datum : data2)
			{
				Set<String> keys = datum.keySet();
				for(String key : keys)
				{
					count += datum.getDouble(key);

					if(!key.equals("STATEMENT_ID") && !key.equals("SUBSTATEMENT_ID") && !key.equals("SUBSTATEMENT_ID"))
					{
						if(datum2.containsKey(key))
						{
							datum2.put(key, datum2.getDouble(key) + datum.getDouble(key));
						}
						else
						{
							datum2.put(key, datum.getDouble(key));
						}
					}
				}
			}
			
			//如果所有总数为0，也相当于未填
			if(count == 0)
			{
				datum2 = null;
			}
		}
		
		
		
		
		
		JSONArray warnings = new JSONArray();
		if(datum1 != null && datum2 != null)
		{
			Set<String> keys = datum1.keySet();
			for(String key : keys)
			{
				if(!key.equals("STATEMENT_ID") && !key.equals("SUBSTATEMENT_ID") && !key.equals("MODE"))
				{
					double value1 = datum1.getDouble(key);
					double value2 = datum2.getDouble(key);

					if(value1 != value2)
					{
						JSONObject warning = new JSONObject();
						warning.put("name", key);
						warning.put("item1", name1);
						warning.put("value1", value1);
						warning.put("item2", name2);
						warning.put("value2", value2);
						warnings.put(warning);
					}
				}
			}
		}
		else
		{
			if(datum1 != null && datum2 == null)
			{
				Set<String> keys = datum1.keySet();
				for(String key : keys)
				{
					if(!key.equals("STATEMENT_ID") && !key.equals("SUBSTATEMENT_ID") && !key.equals("MODE"))
					{
						String value1 = datum1.getString(key);
						JSONObject warning = new JSONObject();
						warning.put("name", "数据不完整");
						warning.put("item1", name1);
						warning.put("value1", value1);
						warning.put("item2", name2);
						warning.put("value2", "");
						warnings.put(warning);
					}
				}
			}
			else if(datum1 == null && datum2 != null)
			{
				Set<String> keys = datum2.keySet();
				for(String key : keys)
				{
					if(!key.equals("STATEMENT_ID") && !key.equals("SUBSTATEMENT_ID") && !key.equals("MODE"))
					{
						String value2 = datum2.getString(key);
						JSONObject warning = new JSONObject();
						warning.put("name", "数据不完整");
						warning.put("item1", name1);
						warning.put("value1", "");
						warning.put("item2", name2);
						warning.put("value2", value2);
						warnings.put(warning);
					}
				}
			}

		}	

		return warnings;
	}
%>

