
<%@page import="com.system.utils.ThrowableUtils"%>
<%@page import="org.apache.commons.lang3.StringUtils"%>
<%@page import="com.system.SystemProperty"%>
<%@page import="java.io.File"%>
<%@page import="com.system.office.XLSUtils"%>
<%@page contentType="text/html; charset=utf-8"%>

<%

	String id = request.getParameter("id");
	
	File file = new File(SystemProperty.PATH + SystemProperty.FILESEPARATOR +"system"+SystemProperty.FILESEPARATOR+"report"+SystemProperty.FILESEPARATOR+"template"+SystemProperty.FILESEPARATOR + id+".xls");
	
	if(file.exists())
	{
		try
		{
			String html = XLSUtils.toHtml(file);
			
			String js = "<script type=\"text/javascript\" src=\"../../../lib/jquery.js\"></script>";
			js += "<script type=\"text/javascript\" src=\"../../../lib/app.js\"></script>";
			js += "<script type=\"text/javascript\" src=\"template.js\"></script>";
			html = StringUtils.replace(html, "</head>", js+"</head>");
			
			html = StringUtils.replace(html, "</style>", "</style><link rel=\"stylesheet\" href=\"template.css\" />");
			
			out.println("<!doctype html>"+html);
		}
		catch(Exception e)
		{
			Throwable throwable = ThrowableUtils.getThrowable(e);
			out.println("<!doctype html><head></head><body style=\"padding-top:30px\"><p style=\"text-align:center; font-size:40px; color:#cccccc\">解析表格文件错误："+throwable.getMessage()+"</p></body></html>");
		}
	}
	else
	{
		out.println("<!doctype html><head></head><body style=\"padding-top:30px\"><p style=\"text-align:center; font-size:40px; color:#cccccc\">未上传表格文件</p></body></html>");
	}
%>