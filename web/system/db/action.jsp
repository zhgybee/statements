<%@page import="org.json.JSONObject"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="org.apache.commons.io.FileUtils"%>
<%@page import="java.io.File"%>
<%@page import="com.system.SystemProperty"%>

<%@page contentType="text/html; charset=utf-8"%>

<%
	String urlAction = request.getParameter("action");

	if(urlAction.equals("backup"))
	{
		SimpleDateFormat simpleFormat = new SimpleDateFormat("yyyyMMddHHmmss");
		String name = simpleFormat.format(new Date());
	
		File source = SystemProperty.DATASOURCE;
	
		File target = new File(SystemProperty.PATH + SystemProperty.FILESEPARATOR + "db" + SystemProperty.FILESEPARATOR + name);
	
		FileUtils.copyFile(source, target);
	}
	else if(urlAction.equals("delete"))
	{
		String name = request.getParameter("name");
		if(name != null && !name.equals(""))
		{
			File file = new File(SystemProperty.PATH + SystemProperty.FILESEPARATOR + "db" + SystemProperty.FILESEPARATOR + name);
			file.delete();
		}
	}
	else if(urlAction.equals("activate")) 
	{
		String name = request.getParameter("name");
		
		SystemProperty.DATASOURCE = new File(SystemProperty.PATH + SystemProperty.FILESEPARATOR + "db" + SystemProperty.FILESEPARATOR + name);
		
		File source = new File(SystemProperty.PATH + SystemProperty.FILESEPARATOR + "config" + SystemProperty.FILESEPARATOR + "config.json");
		
		String content = FileUtils.readFileToString(source, "UTF-8");
		
		JSONObject object = new JSONObject(content);
		
		object.put("datasource", name);
		
		FileUtils.writeStringToFile(source, object.toString(4), "UTF-8");
	}
%>







