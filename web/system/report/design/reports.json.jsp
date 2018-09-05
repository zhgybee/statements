
<%@page import="java.util.Arrays"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Comparator"%>
<%@page import="java.util.Collections"%>
<%@page import="com.system.utils.ThrowableUtils"%>
<%@page import="com.system.utils.SystemUtils"%>
<%@page import="org.json.JSONArray"%>
<%@page import="org.apache.commons.io.FileUtils"%>
<%@page import="org.json.JSONObject"%>
<%@page import="java.io.File"%>
<%@page import="com.system.SystemProperty"%>
<%@page contentType="text/html; charset=utf-8"%>

<%
	JSONObject result = new JSONObject();
	JSONArray reportsresult = new JSONArray();

	File directory = new File(SystemProperty.PATH + SystemProperty.FILESEPARATOR +"system"+SystemProperty.FILESEPARATOR+"report"+SystemProperty.FILESEPARATOR+"config");

	List<File> files = Arrays.asList(directory.listFiles());
	
	Collections.sort(files, new Comparator<File>() 
	{
		public int compare(File file, File cast) 
		{
			if (file.lastModified() < cast.lastModified()) 
			{
				return 1;
			} 
			else if (file.lastModified() > cast.lastModified()) 
			{
				return -1;
			}
			else
			{
				return 0;
			} 
        }
	});
	
	
	
	for(File file : files)
	{
		String filename = file.getName();
		int length = filename.indexOf(".");
		if(length == -1)
		{
			length = filename.length();
		}
		
		JSONObject reportresult = new JSONObject();
		String code = "0";
		String id = filename.substring(0, length);
		String title = null;
		String message = "";
		try
		{
			JSONObject report = new JSONObject(FileUtils.readFileToString(file, "UTF-8"));
			title = report.optString("TITLE", id);
		}
		catch(Exception e)
		{
			code = "1";
			Throwable throwable = ThrowableUtils.getThrowable(e);
			message = "报表配置文件错误："+throwable.getMessage();
		}
		
		File template = new File(SystemProperty.PATH + SystemProperty.FILESEPARATOR +"system"+SystemProperty.FILESEPARATOR+"report"+SystemProperty.FILESEPARATOR+"template"+SystemProperty.FILESEPARATOR + id + ".xls");
		if(template.exists())
		{
			reportresult.put("TEMPLATE", id);
		}
		else
		{
			code = "1";
			message = "未上传模板文件";
		}
		
		reportresult.put("CODE", code);
		reportresult.put("ID", id);
		reportresult.put("TITLE", title);
		reportresult.put("MESSAGE", message);
		
		reportsresult.put(reportresult);
	}
	
	

	JSONArray templateresult = new JSONArray();
	
	directory = new File(SystemProperty.PATH + SystemProperty.FILESEPARATOR +"system"+SystemProperty.FILESEPARATOR+"report"+SystemProperty.FILESEPARATOR+"template");

	files = Arrays.asList(directory.listFiles());
	
	for(File file : files)
	{
		String filename = file.getName();
		int length = filename.indexOf(".");
		if(length == -1)
		{
			length = filename.length();
		}
		
		String name = filename.substring(0, length);
		File report = new File(SystemProperty.PATH + SystemProperty.FILESEPARATOR +"system"+SystemProperty.FILESEPARATOR+"report"+SystemProperty.FILESEPARATOR+"config"+SystemProperty.FILESEPARATOR + name + ".json");
		if(!report.exists())
		{
			templateresult.put(filename);
		}
	}

	result.put("REPORTS", reportsresult);
	result.put("TRASHTEMPLATE", templateresult);
	
	
	out.println(result);
%>