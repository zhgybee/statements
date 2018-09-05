<%@page import="com.system.utils.ThrowableUtils"%>
<%@page import="java.util.Calendar"%>
<%@page import="org.json.JSONArray"%>
<%@page import="com.system.datasource.DataSource"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="net.lingala.zip4j.exception.ZipException"%>
<%@page import="org.apache.commons.io.FileUtils"%>
<%@page import="org.json.JSONObject"%>
<%@page import="com.system.utils.ZipUtils"%>
<%@page import="com.system.SystemProperty"%>
<%@page import="java.io.File"%>
<%@page import="com.system.utils.SystemUtils"%>
<%@page contentType="text/html;charset=UTF-8" %>

<%
	String code = "0";
	String message = "";
	
	String urlFilename = request.getParameter("filename");
	if(urlFilename != null)
	{
		String uuid = SystemUtils.uuid();
		File source = new File(SystemProperty.PATH + SystemProperty.FILESEPARATOR + "version" + SystemProperty.FILESEPARATOR + "package" + SystemProperty.FILESEPARATOR + urlFilename);
		File decompress = new File(SystemProperty.PATH + SystemProperty.FILESEPARATOR + "version" + SystemProperty.FILESEPARATOR + "package" + SystemProperty.FILESEPARATOR + uuid);	
			
		try
		{
			ZipUtils.decompress(source, decompress);			
		}
		catch(ZipException e)
		{
			code = "1";
			message += e.getMessage()+"&#10;";
		}
		
		String packagename = SystemProperty.PATH + SystemProperty.FILESEPARATOR + "version" + SystemProperty.FILESEPARATOR + "package" + SystemProperty.FILESEPARATOR + uuid;
		
		JSONObject overview = new JSONObject(FileUtils.readFileToString(new File(packagename + SystemProperty.FILESEPARATOR + "overview.json"), "UTF-8"));
		
		List<String> sqls = new ArrayList<String>();
		File sqlpath = new File(packagename + SystemProperty.FILESEPARATOR + "sql");
		
		if(sqlpath.exists() && sqlpath.exists())
		{
			File[] items = sqlpath.listFiles();
			for(File item : items)
			{
				String[] array = FileUtils.readFileToString(item, "UTF-8").split(";");
				for(String sql : array)
				{
					sqls.add(sql);
				}
			}
		}
		
		Connection connection = null;
		try
		{                   
			connection = DataSource.connection(SystemProperty.DATASOURCE);
			DataSource datasource = new DataSource(connection);
			for(int i = 0 ; i < sqls.size() ; i++)
			{
				String sql = sqls.get(i);
				sql = sql.trim();
				try
				{
					datasource.execute(sql);
				}
				catch(Exception e)
				{
					code = "2";
					Throwable throwable = ThrowableUtils.getThrowable(e);
					message += (i + 1)+"："+throwable.getMessage()+"&#10;";
				}
			} 
			connection.commit();
		}
		catch(Exception e)
		{
			code = "1";
			message += e.getMessage()+"&#10;";
		}
		finally
		{
			if(connection != null)
			{
				connection.close();
			}
		}    

		if(!code.equals("1"))
		{
			File programpath = new File(packagename + SystemProperty.FILESEPARATOR + "program");
			File target = new File(SystemProperty.PATH);
			
			if(programpath.exists() && target.exists())
			{
				File[] items = programpath.listFiles();
				for(File item : items)
				{
					if(item.isFile())
					{
						FileUtils.copyFileToDirectory(item, target);
					}
					else if(item.isDirectory())
					{
						FileUtils.copyDirectoryToDirectory(item, target);
					}
				}
			}
		}

		if(!code.equals("1"))
		{
			File configsfile = new File(SystemProperty.PATH + SystemProperty.FILESEPARATOR + "version" + SystemProperty.FILESEPARATOR + "config.json");
			JSONObject configs = new JSONObject(FileUtils.readFileToString(configsfile, "UTF-8"));
			
			configs.put("version", overview.optString("version"));
			
			JSONArray history = configs.optJSONArray("history");
			if(history != null)
			{
				overview.put("date", SystemUtils.toString(Calendar.getInstance(), "yyyy-MM-dd"));
				history.put(overview);
			}
			FileUtils.writeStringToFile(configsfile, configs.toString(4), "UTF-8");
		}
		
	}
	JSONObject result = new JSONObject();
	result.put("CODE", code);
	result.put("MESSAGE", message);
	out.println(result);
%>