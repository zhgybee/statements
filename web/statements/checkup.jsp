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
	String ismerge = StringUtils.defaultString(request.getParameter("merge"), "0");
	String statementId = StringUtils.defaultString(request.getParameter("statement"), "");
	String substatementId = StringUtils.defaultString(request.getParameter("substatement"), "");
	String children = StringUtils.defaultString(request.getParameter("children"), "");
	
	JSONArray configs = new JSONArray( FileUtils.readFileToString(new File(SystemProperty.PATH + SystemProperty.FILESEPARATOR + "config" + SystemProperty.FILESEPARATOR + "checkup.json"), "UTF-8" ));
	
	
	Connection connection = null;
	try
	{
		JSONArray warnings = new JSONArray();
		connection = DataSource.connection(SystemProperty.DATASOURCE);	
		DataSource datasource = new DataSource(connection);	

		
		for(int i = 0 ; i < configs.length() ; i++)
		{
			JSONObject checkup =  configs.optJSONObject(i);
			String description = checkup.optString("description");
			JSONObject item1 = checkup.optJSONObject("item1");
			JSONObject item2 = checkup.optJSONObject("item2");
			
			Datum datum1 = datasource.get(toSql(item1.optString("sql"), ismerge, statementId, substatementId, children));
			Datum datum2 = datasource.get(toSql(item2.optString("sql"), ismerge, statementId, substatementId, children));

			JSONArray details = warning(item1.optString("name"), item2.optString("name"), datum1, datum2);
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
	public String toSql(String sql, String ismerge, String statementId, String substatementId, String children)
	{
		if(ismerge.equals("1"))
		{
			if(substatementId.equals(""))
			{
				return "select * from ("+sql+") where STATEMENT_ID = '"+statementId+"'";
			}
			else
			{
				return "select * from ("+sql+") where SUBSTATEMENT_ID in ("+children+")";
			}
		}
		else
		{
			return "select * from ("+sql+") where SUBSTATEMENT_ID = '"+substatementId+"'";
		}
	}

	public JSONArray warning(String name1, String name2, Datum datum1, Datum datum2) throws JSONException
	{
		JSONArray warnings = new JSONArray();

		if(datum1 != null && datum2 != null)
		{
			Set<String> keys = datum1.keySet();
			for(String key : keys)
			{
				if(!key.equals("STATEMENT_ID") && !key.equals("SUBSTATEMENT_ID"))
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
					if(!key.equals("STATEMENT_ID") && !key.equals("SUBSTATEMENT_ID"))
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
					if(!key.equals("STATEMENT_ID") && !key.equals("SUBSTATEMENT_ID"))
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

