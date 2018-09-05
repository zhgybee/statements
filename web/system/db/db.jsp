<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.math.RoundingMode"%>
<%@page import="java.math.BigDecimal"%>
<%@page import="org.json.JSONObject"%>
<%@page import="org.json.JSONArray"%>
<%@page import="java.io.File"%>
<%@page import="com.system.SystemProperty"%>

<%@page contentType="text/html; charset=utf-8"%>
<%
	File path = new File(SystemProperty.PATH + SystemProperty.FILESEPARATOR + "db");
	File[] dbs = path.listFiles();
	
	SimpleDateFormat simpleFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	
	JSONArray array = new JSONArray();
	for(int i = 0 ; i < dbs.length ; i++)
	{
		File db = dbs[i];
		double size = Double.parseDouble(String.valueOf(db.length())) / 1024 / 1024;
		BigDecimal bigdecimal = new BigDecimal(size);  
		JSONObject object = new JSONObject();
		object.put("name", db.getName());
		object.put("date", simpleFormat.format(new Date(db.lastModified())));
		object.put("size", bigdecimal.setScale(2, RoundingMode.HALF_UP).doubleValue() + "M");
		
		if(db.getName().equals(SystemProperty.DATASOURCE.getName()))
		{
			object.put("activation", true);
		}
		else
		{
			object.put("activation", false);
		}
		
		array.put(object);
	}
	
	out.println(array.toString());
	
%>