<%@page import="org.json.JSONObject"%>
<%@page import="java.util.HashMap"%>
<%@page import="org.json.JSONArray"%>
<%@page import="com.statement.ConfigService"%>
<%@page import="java.math.BigDecimal"%>
<%@page import="java.util.Set"%>
<%@page import="com.system.datasource.Datum"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.LinkedHashMap"%>
<%@page import="com.system.SystemProperty"%>
<%@page import="com.system.utils.ThrowableUtils"%>
<%@page import="com.system.datasource.Data"%>
<%@page import="com.system.datasource.DataSource"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.net.URLDecoder"%>
<%@page import="org.apache.commons.lang3.StringUtils"%>
<%@page contentType="text/html; charset=utf-8"%>



<!doctype html>
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" /> 
<title></title>
<link rel="stylesheet" href="../../style/css/app.css" />
<link rel="stylesheet" href="../../lib/font-awesome/css/font-awesome.min.css" />
<link rel="stylesheet" href="table.css" />
<style>

thead th{padding:0px 5px}

</style>
</head>
<body>
<%
	String table = request.getParameter("tablename");
	String children = StringUtils.defaultString(request.getParameter("children"), "");

	children = URLDecoder.decode(children, "UTF-8");
	
	Map<String, Double> items1 = new LinkedHashMap<String, Double>();
	Map<String, Double> items2 = new LinkedHashMap<String, Double>();
	Connection connection = null;
	try
	{
		connection = DataSource.connection(SystemProperty.DATASOURCE);	
		DataSource datasource = new DataSource(connection);	
		
		Data data = datasource.find("select * from "+table+" T where SUBSTATEMENT_ID in ("+children+") and (MODE = 0 or MODE = 1)");

		for(Datum datum : data)
		{
			String jfkm = datum.getString("JFKM");
			String jferkm = datum.getString("JFEJKM");
			double jfje = datum.getDouble("JFJE");
			
			if(!jfkm.equals(""))
			{
				String key1 = jfkm+","+jferkm;
				Double value1 = items1.get(key1);
				if(value1 == null)
				{
					items1.put(key1, jfje);
				}
				else
				{
					items1.put(key1, value1 + jfje);
				}
			}

			String dfkm = datum.getString("DFKM");
			String dfejkm = datum.getString("DFEJKM");
			double dfje = datum.getDouble("DFJE");
			if(!dfkm.equals(""))
			{
				String key2 = dfkm+","+dfejkm;
				Double value2 = items2.get(key2);
				if(value2 == null)
				{
					items2.put(key2, dfje);
				}
				else
				{
					items2.put(key2, value2 + dfje);
				}
			}
		}
		
	}
	catch(Exception e)
	{ 
		Throwable throwable = ThrowableUtils.getThrowable(e);
		out.println(e.getMessage());
	}
	finally
	{
		if(connection != null)
		{
			connection.close();
		}
	}

	String version = "0001";
	ConfigService configService = new ConfigService(version);
	JSONArray items = configService.getItems();
	Map<String, String> codes = new HashMap<String, String>();

	for(int i = 0 ; i < items.length() ; i++)
	{
		JSONObject item = items.optJSONObject(i);
		if(!item.optString("code").equals(""))
		{
			codes.put(item.optString("code"), item.optString("name"));
		}
	}

%>
<table style="width:100%">
<tr><td colspan="3" style="background-color:#f1f5fa">借方</td></tr>
<tr><td style="width:30%">科目</td><td style="width:30%">二级科目</td><td>金额</td></tr>
<%
	Set<String> key1s = items1.keySet();
	for(String key1 : key1s)
	{
		String[] array = key1.split(",");
		String title = "";
		String subtitle = "";
		
		if(array.length == 2)
		{
			title = array[0];
			subtitle = array[1];
		}
		else if(array.length == 1)
		{
			title = array[0];
		}
		
		
%>
<tr><td><%=codes.get(title)%></td><td><%=subtitle%></td><td class="monery-value"><%=new BigDecimal( items1.get(key1) ).toString()%></td></tr>
<%
	}
%>
</table>
<br/><br/>

<table style="width:100%">
<tr><td colspan="3" style="background-color:#f1f5fa">贷方</td></tr>
<tr><td style="width:30%">科目</td><td style="width:30%">二级科目</td><td>金额</td></tr>
<%
	Set<String> key2s = items2.keySet();
	for(String key2 : key2s)
	{
		String[] array = key2.split(",");
		String title = "";
		String subtitle = "";
		
		if(array.length == 2)
		{
			title = array[0];
			subtitle = array[1];
		}
		else if(array.length == 1)
		{
			title = array[0];
		}
		
		
%>
<tr><td><%=codes.get(title)%></td><td><%=subtitle%></td><td class="monery-value"><%=new BigDecimal( items2.get(key2) ).toString()%></td></tr>
<%
	}
%>
</table>



<script type="text/javascript" src="../../lib/jquery.js"></script>
<script type="text/javascript" src="../../lib/app.js"></script>
<script type="text/javascript" src="datastructure.js"></script>
<script type="text/javascript">
	

	var structureutils = new DataStructureUtils();
	
	$(function()
	{
		$.each($(".monery-value"), function(i, ele)
		{
			$(ele).text( app.changeMoney($(ele).text()) )
		});
	});

</script>
</body>
</html>








