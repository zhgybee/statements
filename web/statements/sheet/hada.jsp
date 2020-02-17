
<%@page import="com.system.variable.VariableService"%>
<%@page import="org.apache.commons.lang3.ArrayUtils"%>
<%@page import="java.util.LinkedHashMap"%>
<%@page import="java.util.LinkedHashSet"%>
<%@page import="com.system.datasource.Datum"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Set"%>
<%@page import="java.util.Map"%>
<%@page import="org.apache.commons.lang3.math.NumberUtils"%>
<%@page import="org.json.JSONObject"%>
<%@page import="org.json.JSONArray"%>
<%@page import="com.system.datastructure.DataStructure"%>
<%@page import="com.system.datasource.Data"%>
<%@page import="com.system.SystemProperty"%>
<%@page import="org.apache.commons.lang3.StringUtils"%>
<%@page import="com.system.utils.ThrowableUtils"%>
<%@page import="java.sql.Connection"%>
<%@page import="com.system.datasource.DataSource"%>
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
<div id="toolbar-panel" class="grid-toolbar-panel clearfix">
	<div class="left">
	</div>
	<div class="searcher-panel right">
		<div class="searcher-keyword-panel"><input type="text" placeholder="请输入搜索内容..."/><i class="fa fa-search"></i></div>
	</div>
</div>
<div id="container">
<table>
<%
	String children = StringUtils.defaultString(request.getParameter("children"), "");
	String tableId = StringUtils.defaultString(request.getParameter("table"), "");

	DataStructure datastructure = SystemProperty.DATASTRUCTURES.get(tableId);
	String tablename = datastructure.getProperty().optString("table");
	

	Map<String, Set<String>> dynamiccolumnmap = new HashMap<String, Set<String>>();
	Data substatements = null;
	Data data = null;
	Connection connection = null;
	try
	{
		connection = DataSource.connection(SystemProperty.DATASOURCE);	
		DataSource datasource = new DataSource(connection);	
		
		substatements = datasource.find("select * from T_SUBSTATEMENT where ID in ("+children+") order by CREATE_DATE");
		Data dynamicheaders = datasource.find("select * from T_HEADER where TABLE_ID = '"+tableId+"' and SUBSTATEMENT_ID in ("+children+") and MODE = 0"); 
		
		for(Datum dynamicheader : dynamicheaders)
		{
			String code = dynamicheader.getString("TAGCODE");
			String substatementId = dynamicheader.getString("SUBSTATEMENT_ID");
			JSONArray array = new JSONArray(dynamicheader.getString("TEXT"));
			Set<String> dynamiccolumns = new LinkedHashSet<String>();
			for(int k = 0 ; k < array.length() ; k++)
			{
				dynamiccolumns.add(array.optString(k));
			}
			dynamiccolumnmap.put(code+"-"+substatementId, dynamiccolumns);
		}
		data = datasource.find("select * from "+tablename+" where SUBSTATEMENT_ID in ("+children+") and MODE = 0");
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
	
	
	
	
	JSONArray header = datastructure.getProperty().optJSONArray("header");
	JSONArray columns = datastructure.getProperty().optJSONArray("columns");
	if(header == null)
	{
		header = new JSONArray();
		header.put(columns);		
	}
	
	String groupcolumnname = "";
	String[] hadacolumns = new String[]{};
	for(int i = 0 ; i < columns.length() ; i++)
	{
		JSONObject column = columns.optJSONObject(i);
		if(column.has("hada"))
		{
			JSONObject hada = column.optJSONObject("hada");
			if(hada.has("group"))
			{
				groupcolumnname = column.optString("name");
			}
			
			hadacolumns = ArrayUtils.add(hadacolumns, column.optString("name"));
			
		}
	}
	
	//组成哈达表的时候，需要把不同项目的每行数据组成一行
	
	//如果表结构配置文件中配置了哈达关键组字段，则数据按照哈达关键组字段组合
	//即每个项目的哈达关键组字段中内容相同的组合
	
	//如果表结构配置文件中没有配置了哈达关键组字段，则按照顺序组合每个项目
	
	Map<String, Datum> map = new LinkedHashMap<String, Datum>();
	Map<String, Data> groupdatamap = new HashMap<String, Data>();
	for(Datum datum : data)
	{
		if(!groupcolumnname.equals(""))
		{
			String groupname = datum.getString(groupcolumnname);
			Datum temp = new Datum();
			Set<String> keys = datum.keySet();
			for(String key : keys)
			{
				if(ArrayUtils.contains(hadacolumns, key))
				{
					if(key.equals(groupcolumnname))
					{
						temp.put(key, datum.get(key));
					}
					else
					{
						temp.put(key+"-"+datum.getString("SUBSTATEMENT_ID"), datum.get(key));
					}
				}
			}

			Datum item = map.get(groupname);
			if(item == null)
			{
				map.put(groupname, temp);
			}
			else
			{
				item.putAll(temp);
			}
		}
		else
		{
			Data groupdata = groupdatamap.get(datum.getString("SUBSTATEMENT_ID"));
			if(groupdata == null)
			{
				groupdata = new Data();
				groupdatamap.put(datum.getString("SUBSTATEMENT_ID"), groupdata);
			}

			Datum temp = new Datum();
			Set<String> keys = datum.keySet();
			for(String key : keys)
			{
				if(ArrayUtils.contains(hadacolumns, key))
				{
					if(key.equals(groupcolumnname))
					{
						temp.put(key, datum.get(key));
					}
					else
					{
						temp.put(key+"-"+datum.getString("SUBSTATEMENT_ID"), datum.get(key));
					}
				}
			}
			groupdata.add(temp);
		}
	}
	
	
	if(groupdatamap.size() > 0)
	{
		int max = 0;
		Set<String> groupIds = groupdatamap.keySet();
		for(String groupId : groupIds)
		{
			Data groupdata = groupdatamap.get(groupId);
			max = Math.max(max, groupdata.size());
		}
		
		for(int i = 0 ; i < max ; i++)
		{
			Datum tmp = new Datum();

			for(String groupId : groupIds)
			{
				Data groupdata = groupdatamap.get(groupId);
				
				if(groupdata.size() - 1 >= i)
				{
					tmp.putAll(groupdata.get(i));
				}
			}
			
			map.put(String.valueOf(i), tmp);
		}
	}
	
	out.println(map);


	
	Set<String> keys = map.keySet();
	
	
	
	StringBuffer statementhtml = new StringBuffer();
	StringBuffer headerhtml = new StringBuffer();
	StringBuffer bodyhtml = new StringBuffer();
	
	
	
	
	Map<String, Integer> colspans = new HashMap<String, Integer>();
	
	String grouptitle = "";
	for(int i = 0 ; i < header.length() ; i++)
	{
		JSONArray headercolumns = header.optJSONArray(i);
		
		headerhtml.append("<tr>");
		
		for(int j = 0 ; j < substatements.size() ; j++)
		{
			Datum substatement = substatements.get(j);
			
			if(colspans.get(substatement.getString("ID")) == null)
			{
				colspans.put(substatement.getString("ID"), 0);
			}
			
			for(int k = 0 ; k < headercolumns.length() ; k++)
			{
				JSONObject column = headercolumns.optJSONObject(k);
				String meaning = column.optString("meaning");
				String colspan = column.optString("colspan");
				String rowspan = column.optString("rowspan");
				if(column.has("hada"))
				{
					JSONObject hada = column.optJSONObject("hada");
					
					if(hada.has("group"))
					{
						grouptitle = column.optString("title");
					}
					
					if( !hada.has("group") )
					{
						if(!colspan.equals(""))
						{
							if(colspan.equals("auto"))
							{
								String target = column.optString("target");
								Set<String> dynamiccolumns = dynamiccolumnmap.get(target+"-"+substatement.getString("ID"));
								if(dynamiccolumns != null)
								{
									colspan = String.valueOf(dynamiccolumns.size());
								}
							}
						}
			
						if(meaning.equals("jsonobject"))
						{
							String target = column.optString("target");
							if(target.equals(""))
							{
								target = column.optString("name");
							}
							Set<String> dynamiccolumns = dynamiccolumnmap.get(target+"-"+substatement.getString("ID"));
							if(dynamiccolumns != null)
							{
								for(String dynamiccolumn : dynamiccolumns)
								{
									headerhtml.append("	<th>"+dynamiccolumn+"</th>");
									colspans.put(substatement.getString("ID"), colspans.get(substatement.getString("ID")) + 1);
								}
							}
							else
							{
								headerhtml.append("	<th>无</th>");
								colspans.put(substatement.getString("ID"), colspans.get(substatement.getString("ID")) + 1);
							}
						}
						else
						{
							headerhtml.append("	<th colspan=\""+colspan+"\" rowspan=\""+rowspan+"\">"+column.optString("title")+"</th>");

							if(colspan.equals(""))
							{
								colspans.put(substatement.getString("ID"), colspans.get(substatement.getString("ID")) + 1);
							}
						}
					}
				}
			}		
		}
		headerhtml.append("</tr>");
	}	

	statementhtml.append("<tr>");
	if(!grouptitle.equals(""))
	{
		statementhtml.append("<th rowspan=\""+(header.length() + 1)+"\">"+grouptitle+"</th>");
	}
	for(Datum substatement : substatements)
	{
		statementhtml.append("<th colspan=\""+colspans.get(substatement.getString("ID"))+"\">"+substatement.getString("TITLE")+"</th>");
	}
	statementhtml.append("</tr>");
	
	
	
	

	keys = map.keySet();
	for(String key : keys)
	{
		Datum datum = map.get(key);
		bodyhtml.append("<tr>");
		
		for(int j = 0 ; j < substatements.size() ; j++)
		{
			Datum substatement = substatements.get(j);
			for(int k = 0 ; k < columns.length() ; k++)
			{
				JSONObject column = columns.optJSONObject(k);
				String meaning = column.optString("meaning");
				String classname = "";
				if(column.has("modes"))
				{
					JSONArray modes = column.optJSONArray("modes");
					if(modes != null)
					{
						for(int n = 0 ; n < modes.length() ; n++)
						{
							if(modes.optString(n).equals("money"))
							{
								classname = "money";
							}
							if(modes.optString(n).equals("percent"))
							{
								classname = "percent";
							}
						}
					}
				}
				
				if(column.has("hada"))
				{
					String dictionary = null;
					if(column.has("dictionary"))
					{
						dictionary =  column.optJSONObject("dictionary").optString("map");
						dictionary = VariableService.parseUrlVariable(dictionary, 0, request);
					}

					JSONObject hada = column.optJSONObject("hada");

					if(j == 0 && hada.has("group"))
					{
						if(dictionary != null)
						{
							bodyhtml.append("	<td dictionary=\""+dictionary+"\">"+datum.getString(column.optString("name"))+"</td>");
						}
						else
						{
							bodyhtml.append("	<td class=\""+classname+"\">"+datum.getString(column.optString("name"))+"</td>");
						}
					}
					
					if( !hada.has("group") )
					{
						if(meaning.equals("jsonobject"))
						{
							Set<String> dynamiccolumns = dynamiccolumnmap.get(column.optString("name")+"-"+substatement.getString("ID"));
							if(dynamiccolumns != null)
							{
								JSONObject values = new JSONObject(datum.getString(column.optString("name")+"-"+substatement.getString("ID")));
								for(String dynamiccolumn : dynamiccolumns)
								{
									bodyhtml.append("	<td class=\""+classname+"\">"+values.optString(dynamiccolumn)+"</td>");
								}
							}
							else
							{
								bodyhtml.append("	<td></td>");
							}
						}
						else
						{
							if(dictionary != null)
							{
								bodyhtml.append("	<td dictionary=\""+dictionary+"\">"+datum.getString(column.optString("name")+"-"+substatement.getString("ID"))+"</td>");
							}
							else
							{
								bodyhtml.append("	<td class=\""+classname+"\">"+datum.getString(column.optString("name")+"-"+substatement.getString("ID"))+"</td>");
							}
						}
					}
				}
			}		
		}
		bodyhtml.append("</tr>");
	}
	
	
	
	
	
	
	
	out.println("<thead>");
	out.println(statementhtml);
	out.println(headerhtml);
	out.println("</thead>");
	out.println("<tbody>");
	out.println(bodyhtml);
	out.println("</tbody>");
%>
</table>
</div>
<script type="text/javascript" src="../../lib/jquery.js"></script>
<script type="text/javascript" src="../../lib/app.js"></script>
<script type="text/javascript" src="datastructure.js"></script>
<script type="text/javascript">
	

	var structureutils = new DataStructureUtils();
	
	$(function()
	{
		resize();
		$(window).resize( function(){resize()} ); 

		$("#container tbody td[dictionary]").each(function(i, cell)
		{
			var description = structureutils.getDictionary(app.getContextPath()+"/"+$(cell).attr("dictionary"), $(cell).text(), true);
			$(cell).text(description);
		});
		

		$("#container tbody .money").each(function(i, cell)
		{
			$(cell).text( app.changeMoney($(cell).text()) );
		});
		
		$("#container tbody .percent").each(function(i, cell)
		{
			$(cell).text( app.toFixed( app.toNumber($(cell).text()) * 100 ) + "%" );
		});
				
		
	});
	function resize()
	{
		$("#container").height( $(window).outerHeight() - $("#toolbar-panel").outerHeight(true) - 1 );
	}

</script>
</body>
</html>