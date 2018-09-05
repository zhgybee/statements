
<%@page import="org.json.JSONArray"%>
<%@page import="com.system.SystemProperty"%>
<%@page import="org.apache.commons.io.FileUtils"%>
<%@page import="java.io.File"%>
<%@page import="com.system.datasource.Datum"%>
<%@page import="org.json.JSONObject"%>
<%@page import="com.system.datasource.Data"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="com.system.datasource.DataSource"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.util.Calendar"%>
<%@page import="com.system.utils.SystemUtils"%>

<%@page contentType="text/html; charset=utf-8"%>

<%
	Connection connection = null;
	Data users = null;
	try
	{
		connection = DataSource.connection(SystemProperty.DATASOURCE);;
		DataSource dataSource = new DataSource(connection);
		users = dataSource.find("select * from T_USER");
	}
	catch(Exception e)
	{
		e.printStackTrace();
	}
	finally
	{
		if(connection != null)
		{
			connection.close();
		}
	}
	

	if(users != null)
	{
		JSONArray list = new JSONArray();
		JSONObject map = new JSONObject();
		for(Datum datum : users)
		{
			String id = datum.getString("ID");
			String name = datum.getString("NAME");
			map.put(id, name);

			JSONObject item = new JSONObject();
			item.put("k", id);
			item.put("v", name);
			list.put(item);
		}

		FileUtils.writeStringToFile(new File(SystemProperty.PATH+SystemProperty.FILESEPARATOR+"dictionary"+SystemProperty.FILESEPARATOR+"map"+SystemProperty.FILESEPARATOR+"user.json"), map.toString(), "UTF-8");
		FileUtils.writeStringToFile(new File(SystemProperty.PATH+SystemProperty.FILESEPARATOR+"dictionary"+SystemProperty.FILESEPARATOR+"list"+SystemProperty.FILESEPARATOR+"user.json"), list.toString(), "UTF-8");
	}
%>