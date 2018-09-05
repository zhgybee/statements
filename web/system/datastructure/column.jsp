
<%@page import="java.util.Set"%>
<%@page import="org.json.JSONObject"%>
<%@page import="java.util.Map"%>
<%@page import="org.apache.commons.lang3.StringUtils"%>
<%@page import="com.system.SystemProperty"%>
<%@page import="com.system.datastructure.DataStructure"%>
<%@page import="org.json.JSONArray"%>
<%@page contentType="text/html; charset=utf-8"%>


<%
	JSONArray result = new JSONArray();
	
	DataStructure datastructure = SystemProperty.DATASTRUCTURES.get(StringUtils.defaultString(request.getParameter("code"), ""));

	
	if(datastructure != null)
	{
		Map<String, JSONObject> columns = datastructure.getColumns();		
		Set<String> keys = columns.keySet();
		for(String key : keys)
		{
			JSONObject column = columns.get(key);
			if(column.has("datagrid"))
			{
				result.put(column);
			}
		}
	}
	
	out.println(result.toString());
	

%>