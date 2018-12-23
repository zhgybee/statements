
<%@page import="java.util.Objects"%>
<%@page import="java.util.Set"%>
<%@page import="java.io.IOException"%>
<%@page import="org.json.JSONException"%>
<%@page import="org.json.JSONObject"%>
<%@page import="org.apache.commons.io.FileUtils"%>
<%@page import="java.io.File"%>
<%@page import="org.json.JSONArray"%>
<%@page import="com.system.SystemProperty"%>
<%@page contentType="text/html; charset=utf-8"%>
<%
	try
	{
		JSONObject configs = new JSONObject( FileUtils.readFileToString(new File(SystemProperty.PATH + SystemProperty.FILESEPARATOR + "config" + SystemProperty.FILESEPARATOR + "config.json"), "UTF-8" ));
		SystemProperty.DATASOURCE = new File( SystemProperty.PATH + SystemProperty.FILESEPARATOR + "db" + SystemProperty.FILESEPARATOR + configs.optString("datasource") ) ;

		JSONArray variables = configs.getJSONArray("variable");
		for(int i = 0 ; i < variables.length() ; i++)
		{
			JSONObject variable = variables.getJSONObject(i);
			SystemProperty.VARIABLES.put(variable.getString("name"), variable.getString("classname"));
		}
		
		File structures = new File(SystemProperty.PATH + SystemProperty.FILESEPARATOR + "config" + SystemProperty.FILESEPARATOR + "datastructure.json");
		if(structures.exists())
		{
			JSONArray datastructures = new JSONArray(FileUtils.readFileToString(structures, "UTF-8"));
			SystemProperty.DATASTRUCTURES.initialise(datastructures);
		}
		
		File sqls = new File(SystemProperty.PATH + SystemProperty.FILESEPARATOR + "config" + SystemProperty.FILESEPARATOR + "sqls.json");
		if(sqls.exists())
		{
			JSONArray items = new JSONArray(FileUtils.readFileToString(sqls, "UTF-8"));
			for(int i = 0 ; i < items.length() ; i++)
			{
				JSONObject item = items.getJSONObject(i);
				SystemProperty.SQLBUILDER.put(item.optString("code"), item);
			}
		}
		
		SystemProperty.STATEMENTMAP = new JSONObject( FileUtils.readFileToString(new File(SystemProperty.PATH + SystemProperty.FILESEPARATOR + "config" + SystemProperty.FILESEPARATOR + "statement.json"), "UTF-8" ));
		
		Set<?> versions = SystemProperty.STATEMENTMAP.keySet();
		
		for(Object object : versions)
		{
			String version = Objects.toString(object);
			JSONObject statement = SystemProperty.STATEMENTMAP.optJSONObject(version);
			JSONArray sheets = statement.optJSONArray("sheets");
			JSONObject sheetmap = new JSONObject();
			
			for(int i = 0 ; i < sheets.length() ; i++)
			{
				JSONObject sheet = sheets.optJSONObject(i);
				sheetmap.put(sheet.optString("id"), sheet);
			}
			
			statement.put("sheetmap", sheetmap);
		}
		
		
	}
	catch (Exception e)
	{
		e.printStackTrace();
	}
%>