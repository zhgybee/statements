<%@page import="org.apache.commons.lang3.StringUtils"%>
<%@page import="java.util.Set"%>
<%@page import="org.json.JSONException"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="com.system.datasource.DataSource"%>
<%@page import="com.system.datasource.Data"%>
<%@page import="com.system.SystemProperty"%>
<%@page import="java.sql.Connection"%>
<%@page import="org.json.JSONObject"%>
<%@page import="java.net.URLDecoder"%>
<%@page import="org.json.JSONArray"%>
<%@page import="com.system.SessionUser"%>
<%@page import="com.system.utils.ServiceMessage"%>
<%@page contentType="text/html; charset=utf-8"%>

<%
	ServiceMessage message = new ServiceMessage();
	SessionUser sessionuser = SessionUser.getSessionUser(session);
	
	if(sessionuser != null)
	{
		String columns = URLDecoder.decode(StringUtils.defaultString(request.getParameter("columns"), ""), "utf-8");
		String sort = URLDecoder.decode(StringUtils.defaultString(request.getParameter("sort"), ""), "utf-8");
		String searcher = URLDecoder.decode(StringUtils.defaultString(request.getParameter("searcher"), ""), "utf-8");
	
		JSONArray columnitems = null;
		if(!columns.equals(""))
		{
			columnitems = new JSONArray(columns);
		}
		
		JSONArray sortitems = null;
		if(!sort.equals(""))
		{
			sortitems = new JSONArray(sort);
		}
		
		JSONArray searcheritems = null;
		if(!searcher.equals(""))
		{
			searcheritems = new JSONArray(searcher);
		}
		
		if(columnitems != null)
		{
			StringBuffer sql = new StringBuffer();	
		
			Data data = null;
			sql.append("select ");
			String tablename = "";
			for(int i = 0 ; i < columnitems.length() ; i++)
			{
				JSONObject columnitem = columnitems.getJSONObject(i);
				String name = columnitem.getString("name");
				JSONObject table = columnitem.getJSONObject("table");
				if(table != null)
				{
					tablename = table.optString("name");
				}
				String column = tablename+"."+name;
				sql.append(column+" as "+tablename+"_"+name+", ");
			}
			sql.append(tablename+".ID as ID");
			sql.append(" from "+tablename+" "+tablename+"");
		
			
			if(searcheritems != null && searcheritems.length() > 0)
			{
				sql.append(" where ");
		
				String[] items = new String[searcheritems.length()];
				for(int i = 0 ; i < searcheritems.length() ; i++)
				{
					JSONObject searcheritem = searcheritems.getJSONObject(i);
					
					String table = searcheritem.optString("table");
					String column = searcheritem.optString("column");
					String operator = searcheritem.optString("operator");
					String type = searcheritem.optString("type");
					String value = searcheritem.optString("value");
		
					if(operator.equals("=") || operator.equals("<>"))
					{
						value = "'"+value+"'";
					}
					else if(operator.equals("like"))
					{
						if(value.indexOf("%") == -1)
						{
							value = "'%"+value+"%'";
						}
						else
						{
							value = "'"+value+"'";
						}
					}
					items[i] = table+"."+column+" "+operator+" "+value+"";
				}
				sql.append(StringUtils.join(items, " and "));
			}
		
			if(sortitems != null && sortitems.length() > 0)
			{
				sql.append(" order by ");
				String[] items = new String[sortitems.length()];
				for(int i = 0 ; i < sortitems.length() ; i++)
				{
					JSONObject sortitem = sortitems.getJSONObject(i);
					String column = sortitem.optString("column");
					String type = sortitem.optString("type");
					items[i] = column+" "+type+"";
				}
				sql.append(StringUtils.join(items, ", "));
			}
		
			Connection connection = null;
			try
			{
				connection = DataSource.connection(SystemProperty.DATASOURCE);
				DataSource datasource = new DataSource(connection);	
				data = datasource.find(sql.toString());
			}
			catch(Exception e)
			{
				e.printStackTrace();
			}
			finally
			{
				if(connection != null)
				{
					connection.close();
				}
			}
			message.resource("rows", data);
		}
		else
		{
			message.message(ServiceMessage.FAILURE, "column is null");
		}
		
	}
	else
	{
		message.message(ServiceMessage.FAILURE, "登录用户失效，请重新登录。");
	}
	
	out.println(message);
%>