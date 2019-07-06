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

	String mode = request.getParameter("mode");
	Object dictionary = null;
	Connection connection = null;
	try
	{
		String statementId = StringUtils.defaultString(request.getParameter("statement"), "");
		String version = "0001";
		connection = DataSource.connection(SystemProperty.DATASOURCE);	
		DataSource datasource = new DataSource(connection);	
		Data sheets = datasource.find("select * from T_STATEMENT_SHEET where STATEMENT_ID = ?", statementId);
		String[] sheetIds = new String[]{};
		for(Datum sheet : sheets)
		{
			sheetIds = ArrayUtils.add(sheetIds, sheet.getString("SHEET_ID"));
		}
		ConfigService configService = new ConfigService(version);

		
		if(mode.equals("1"))
		{
			JSONArray resources = new JSONArray();
			
			JSONArray items =  configService.getItems(sheetIds);
			for(int i = 0 ; i < items.length() ; i++)
			{
				JSONObject item = items.optJSONObject(i);
				boolean iseditor = item.optBoolean("editor");
				if(iseditor)
				{
					JSONObject resource = new JSONObject();
					resource.put("k", item.optString("code"));
					resource.put("v", item.optString("name"));
					resources.put(resource);
				}
			}
			dictionary = resources;
		}
		else if(mode.equals("2"))
		{
			JSONObject resources = new JSONObject();
			
			JSONArray items =  configService.getItems(sheetIds);
			for(int i = 0 ; i < items.length() ; i++)
			{
				JSONObject item = items.optJSONObject(i);
				boolean iseditor = item.optBoolean("editor");
				if(iseditor)
				{
					resources.put(item.optString("code"), item.optString("name"));
				}
			}
			dictionary = resources;
		}
		
	}
	catch(Exception e)
	{
		Throwable throwable = ThrowableUtils.getThrowable(e);
		JSONObject resource = new JSONObject();
		resource.put("k", "");
		resource.put("v", throwable.getMessage());
	}
	finally
	{
		if(connection != null)
		{
			connection.close();
		}
	}
	
	out.println(dictionary);
%>