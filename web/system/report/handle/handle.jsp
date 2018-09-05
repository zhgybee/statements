<%@page import="org.json.JSONArray"%>
<%@page import="org.apache.commons.lang3.StringUtils"%>
<%@page import="java.util.List"%>
<%@page import="com.system.utils.ThrowableUtils"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.system.variable.VariableService"%>
<%@page import="org.apache.commons.io.FileUtils"%>
<%@page import="com.report.Report"%>
<%@page import="com.system.datasource.DataSource"%>
<%@page import="java.sql.Connection"%>
<%@page import="org.json.JSONObject"%>
<%@page import="com.system.utils.SystemUtils"%>
<%@page import="com.system.SystemProperty"%>
<%@page import="java.io.File"%>
<%@page contentType="text/html; charset=utf-8"%>

<%
	
	String reportcode = request.getParameter("reportcode");
	String reportname = request.getParameter("reportname");
	String isCreateHtml = request.getParameter("html");

	File excelfile = new File(SystemProperty.PATH + SystemProperty.FILESEPARATOR + "temp" + SystemProperty.FILESEPARATOR + reportname + ".xls");
	File htmlfile = null;
	if(isCreateHtml != null)
	{
		htmlfile = new File(SystemProperty.PATH + SystemProperty.FILESEPARATOR + "temp" + SystemProperty.FILESEPARATOR + reportname + ".html");
	}
	
	File template = new File(SystemProperty.PATH + SystemProperty.FILESEPARATOR + "system" + SystemProperty.FILESEPARATOR + "report" + SystemProperty.FILESEPARATOR + "template" + SystemProperty.FILESEPARATOR + reportcode + ".xls");
	
	
	File file = new File(SystemProperty.PATH + SystemProperty.FILESEPARATOR + "system" + SystemProperty.FILESEPARATOR + "report" + SystemProperty.FILESEPARATOR + "config" + SystemProperty.FILESEPARATOR + reportcode+".json");
	String content = FileUtils.readFileToString(file, "UTF-8");
	content = VariableService.parseUrlVariable(content, 0, request);
	content = VariableService.parseSysVariable(content, request);
	
	JSONObject reportconfig = new JSONObject(content);
	
	JSONObject result = new JSONObject();
	
	Connection connection = null;
	Report report = null;
	try
	{
		connection = DataSource.connection(SystemProperty.DATASOURCE);
		
		report = new Report(connection);
		report.setTemplate(template);
		report.setExcel(excelfile);		
		report.setHtml(htmlfile);		
		report.setConfig(reportconfig);
		report.setLog(new ArrayList<String>());
		report.dataset();
	}
	catch(Exception e)
	{
		Throwable throwable = ThrowableUtils.getThrowable(e);
		String message = throwable.getMessage();
		result.put("CODE", "1");
		result.put("MESSAGE", "未知错误："+message+"！");
	}
	finally
	{
		if(connection != null)
		{
			connection.close();
		}
	}
	
	try
	{
		report.create();
		
		if(htmlfile != null && htmlfile.exists())
		{
			String html = FileUtils.readFileToString(htmlfile, "UTF-8");
			if(html != null)
			{
				html = StringUtils.replace(html, "</head>", "<script type=\"text/javascript\" src=\"../lib/jquery.js\"></script><script type=\"text/javascript\" src=\"../lib/app.js\"></script><script type=\"text/javascript\" src=\"../system/report/handle/handle.js\"></script></head>");
			}
			
			FileUtils.writeStringToFile(htmlfile, html, "UTF-8");
		}

		if(excelfile.exists())
		{
			result.put("CODE", "0");
			result.put("HTML", "temp/" + reportname + ".html");
			result.put("XLS", "temp/" + reportname + ".xls");
		}
		else
		{
			result.put("CODE", "1");
			result.put("MESSAGE", "报表文件（XLS格式）未生成！");
		}
	}
	catch(Exception e)
	{
		Throwable throwable = ThrowableUtils.getThrowable(e);
		String message = throwable.getMessage();
		result.put("CODE", "1");
		result.put("MESSAGE", "未知错误："+message+"！");
		e.printStackTrace();
	}
	
	JSONArray logs = new JSONArray();
	for(String log : report.getLog())
	{
		logs.put(log);
	}
	result.put("LOG", logs);
	out.println(result.toString());
	
%>
