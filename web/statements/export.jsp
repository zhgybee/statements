<%@page import="com.system.datasource.Datum"%>
<%@page import="java.util.Set"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="com.system.variable.VariableService"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="org.json.JSONObject"%>
<%@page import="java.io.File"%>
<%@page import="org.apache.commons.io.FileUtils"%>
<%@page import="org.json.JSONArray"%>
<%@page import="com.system.utils.ThrowableUtils"%>
<%@page import="com.system.SystemProperty"%>
<%@page import="com.system.datasource.Data"%>
<%@page import="com.system.datasource.DataSource"%>
<%@page import="java.sql.Connection"%>
<%@page import="com.system.SessionUser"%>
<%@page import="com.system.utils.ServiceMessage"%>

<%@page contentType="text/html; charset=utf-8"%>

<%
	ServiceMessage message = new ServiceMessage();
	SessionUser sessionuser = SessionUser.getSessionUser(session);
	
	if(sessionuser != null)
	{
		List<String> warnings = new ArrayList<String>();
		
		String id = request.getParameter("id");
		
		JSONArray items = new JSONArray( FileUtils.readFileToString(new File(SystemProperty.PATH + SystemProperty.FILESEPARATOR + "config" + SystemProperty.FILESEPARATOR + "report" + SystemProperty.FILESEPARATOR + id+".json"), "UTF-8" ));

		Map<String, String> sqls = new HashMap<String, String>();
		for(int i = 0 ; i < items.length() ; i++)
		{
			JSONObject item = items.optJSONObject(i);
			if(item.has("dateset"))
			{				
				String code = item.optString("dateset");
				
				JSONObject dataset = SystemProperty.SQLBUILDER.get(code);
				if(dataset != null)
				{
					String sql = dataset.optString("sql");
					sql = VariableService.parseUrlVariable(sql, 0, request);
					sql = VariableService.parseSysVariable(sql, request);
					sqls.put(code, sql);
				}
				else
				{
					warnings.add("SQL构建器中不存在["+code+"]。");
				}
			}
		}
		
		Map<String, Data> dateset = new HashMap<String, Data>();
		Connection connection = null;
		try
		{
			connection = DataSource.connection(SystemProperty.DATASOURCE);	
			DataSource datasource = new DataSource(connection);	
			Set<String> keys = sqls.keySet();
			for(String key : keys)
			{
				String sql = sqls.get(key);
				Data data = datasource.find(sql);
				dateset.put(key, data);
			}
		}
		catch(Exception e)
		{
			Throwable throwable = ThrowableUtils.getThrowable(e);
			warnings.add(throwable.getMessage());
		}
		finally
		{
			if(connection != null)
			{
				connection.close();
			}
		}
		
		
		
		
		
		StringBuffer xml = new StringBuffer();
		xml.append("<?xml version=\"1.0\"?>");

		xml.append("<w:wordDocument xmlns:w=\"http://schemas.microsoft.com/office/word/2003/wordml\">");
		xml.append("<w:body>");
		for(int i = 0 ; i < items.length() ; i++)
		{
			JSONObject item = items.optJSONObject(i);
			
			String type = item.optString("type");
			Data data = null;
			if(item.has("dateset"))
			{				
				data = dateset.get(item.optString("dateset"));
			}
			
			if(type.equals("text"))
			{
				String content = item.optString("content");
				if(data != null && data.size() > 0)
				{
					content = VariableService.parseDataVariable(content, data.get(0));
				}
				xml.append("<w:p>");
				xml.append("	<w:r>");
				xml.append("		<w:t>"+content+"</w:t>");
				xml.append("	</w:r>");
				xml.append("</w:p>");
				xml.append("<w:p/>");
			}
			else if(type.equals("table"))
			{				
				JSONArray columns = item.optJSONArray("columns");
				
				xml.append("<w:tbl>");
				
				
				xml.append("<w:tblPr>");
				xml.append("	<w:tblW w:w=\"0\" w:type=\"auto\"/>");
				xml.append("	<w:jc w:val=\"center\"/>");
				xml.append("	<w:tblBorders>");
				xml.append("		<w:top w:val=\"single\" w:sz=\"4\" wx:bdrwidth=\"10\" w:space=\"0\" w:color=\"auto\"/>");
				xml.append("		<w:bottom w:val=\"single\" w:sz=\"4\" wx:bdrwidth=\"10\" w:space=\"0\" w:color=\"auto\"/>");
				xml.append("		<w:left w:val=\"single\" w:sz=\"4\" wx:bdrwidth=\"10\" w:space=\"0\" w:color=\"auto\"/>");
				xml.append("		<w:right w:val=\"single\" w:sz=\"4\" wx:bdrwidth=\"10\" w:space=\"0\" w:color=\"auto\"/>");
				xml.append("		<w:insideH w:val=\"single\" w:sz=\"4\" wx:bdrwidth=\"10\" w:space=\"0\" w:color=\"auto\"/>");
				xml.append("		<w:insideV w:val=\"single\" w:sz=\"4\" wx:bdrwidth=\"10\" w:space=\"0\" w:color=\"auto\"/>");
				xml.append("	</w:tblBorders>");
				xml.append("</w:tblPr>");
				
				xml.append("<w:tr>");
				xml.append("	<w:trPr>");
				xml.append("		<w:trHeight w:val=\"450\" w:h-rule=\"atLeast\"/>");
				xml.append("	</w:trPr>");
				for(int j = 0 ; j < columns.length() ; j++)
				{
					JSONObject column = columns.optJSONObject(j);
					xml.append("	<w:tc>");
					xml.append("		<w:tcPr>");
					xml.append("			<w:tcW w:w=\""+column.optInt("width")+"\" w:type=\"dxa\"/>");
					xml.append("			<w:shd w:val=\"clear\" w:color=\"auto\" w:fill=\"C7DAF1\"/>");
					xml.append("			<w:vAlign w:val=\"center\"/>");
					xml.append("		</w:tcPr>");
					xml.append("		<w:p>");
					xml.append("			<w:pPr>");
					xml.append("				<w:jc w:val=\"center\"/>");
					xml.append("			</w:pPr>");
					xml.append("			<w:r>");
					xml.append("				<w:t>"+column.optString("title")+"</w:t>");
					xml.append("			</w:r>");
					xml.append("		</w:p>");
					xml.append("	</w:tc>");
				}		
				xml.append("</w:tr>");
				
				

				if(data != null)
				{
					for(Datum datum : data)
					{
						xml.append("<w:tr>");
						xml.append("	<w:trPr>");
						xml.append("		<w:trHeight w:val=\"450\" w:h-rule=\"atLeast\"/>");
						xml.append("	</w:trPr>");
						for(int j = 0 ; j < columns.length() ; j++)
						{
							JSONObject column = columns.optJSONObject(j);
							xml.append("	<w:tc>");
							xml.append("		<w:tcPr>");
							xml.append("			<w:tcW w:w=\""+column.optInt("width")+"\" w:type=\"dxa\"/>");
							xml.append("			<w:vAlign w:val=\"center\"/>");
							xml.append("		</w:tcPr>");
							xml.append("		<w:p>");
							xml.append("			<w:pPr>");
							xml.append("				<w:jc w:val=\"center\"/>");
							xml.append("			</w:pPr>");
							xml.append("			<w:r>");
							xml.append("				<w:t>"+datum.getString(column.optString("name"))+"</w:t>");
							xml.append("			</w:r>");
							xml.append("		</w:p>");
							xml.append("	</w:tc>");
						}
						xml.append("</w:tr>");
					}
				}
				
				
				
				
				xml.append("</w:tbl>");
				xml.append("<w:p/>");
			}
			
		}
		xml.append("</w:body>");
		xml.append("</w:wordDocument>");
		
		
		FileUtils.writeStringToFile(new File("D:\\123.doc"), xml.toString(), "UTF-8");
		
		if(warnings.size() > 0)
		{
			for(String warning : warnings)
			{
				message.message(ServiceMessage.FAILURE, warning);
			}
		}
	}
	else
	{
		message.message(ServiceMessage.FAILURE, "登录用户失效，请重新登录。");
	}
	
	out.println(message);
%>