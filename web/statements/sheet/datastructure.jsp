<%@page import="com.system.variable.VariableService"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="org.apache.commons.lang3.ArrayUtils"%>
<%@page import="java.net.URLDecoder"%>
<%@page import="java.util.LinkedHashSet"%>
<%@page import="java.util.Set"%>
<%@page import="com.system.datasource.Data"%>
<%@page import="com.system.datasource.Datum"%>
<%@page import="com.system.datasource.DataSource"%>
<%@page import="java.sql.Connection"%>
<%@page import="com.system.utils.ThrowableUtils"%>
<%@page import="com.system.SystemProperty"%>
<%@page import="org.json.JSONArray"%>
<%@page import="com.system.datastructure.DataStructure"%>
<%@page import="org.apache.commons.lang3.StringUtils"%>
<%@page import="org.json.JSONObject"%>
<%@page import="com.system.utils.ServiceMessage"%>

<%@page contentType="text/html; charset=utf-8"%>

<%
	ServiceMessage message = new ServiceMessage();

	String tableId = StringUtils.defaultString(request.getParameter("table"), "");
	String statementId = StringUtils.defaultString(request.getParameter("statement"), "");
	String substatementId = StringUtils.defaultString(request.getParameter("substatement"), "");
	String statementmode = StringUtils.defaultString(request.getParameter("statementmode"), "");
	String children = StringUtils.defaultString(request.getParameter("children"), "");
	

	children = URLDecoder.decode(children, "UTF-8");

	try
	{
		DataStructure datastructure = SystemProperty.DATASTRUCTURES.get(tableId);

		if(datastructure != null)
		{
			String[] dynamicheadermarks = new String[]{};
			JSONArray header = datastructure.getProperty().optJSONArray("header");
			JSONArray columns = datastructure.getProperty().optJSONArray("columns");
			
			JSONArray frozenheader = new JSONArray();
			JSONArray activeheader = new JSONArray();
			JSONArray frozencolumns = new JSONArray();
			JSONArray activecolumns = new JSONArray();

			for(int i = 0 ; i < columns.length() ; i++)
			{
				JSONObject column = columns.optJSONObject(i);
				if(column.has("frozen"))
				{
					frozencolumns.put(column);
				}
				else
				{
					activecolumns.put(column);
				}
				if(column.optString("meaning").equals("jsonobject"))
				{
					dynamicheadermarks = ArrayUtils.add(dynamicheadermarks, column.optString("name"));
				}
			}
				
			if(header == null)
			{
				frozenheader.put(frozencolumns);
				activeheader.put(activecolumns);
			}
			else
			{
				for(int i = 0 ; i < header.length() ; i++)
				{
					JSONArray frozenrow = new JSONArray();
					JSONArray activerow = new JSONArray();
					
					JSONArray row = header.optJSONArray(i);
					for(int j = 0 ; j < row.length() ; j++)
					{
						JSONObject column = row.optJSONObject(j);
						if(column.has("frozen"))
						{
							frozenrow.put(column);
						}
						else
						{
							activerow.put(column);
						}
					}
					if(frozenrow.length() > 0)
					{
						frozenheader.put(frozenrow);
					}
					if(activerow.length() > 0)
					{
						activeheader.put(activerow);
					}
				}
			}

			Map<String, Set<String>> dynamiccolumnmap = new HashMap<String, Set<String>>();
			if(dynamicheadermarks.length > 0)
			{
				
				

				//得到动态表头
				Connection connection = null;
				try
				{
					connection = DataSource.connection(SystemProperty.DATASOURCE);	
					DataSource datasource = new DataSource(connection);	
					
					for(String mark : dynamicheadermarks)
					{
						Set<String> dynamiccolumns = new LinkedHashSet<String>();
						
						Data dynamicheaders = null;					
						if(statementmode.equals("2"))
						{
							dynamicheaders = datasource.find("select * from T_HEADER where TABLE_ID = ? and TAGCODE = ? and SUBSTATEMENT_ID in ("+children+") and MODE = 0", tableId, mark);
						}
						else if(statementmode.equals("1"))
						{
							dynamicheaders = datasource.find("select * from T_HEADER where TABLE_ID = ? and SUBSTATEMENT_ID = ? and TAGCODE = ? and MODE = 1", tableId, substatementId, mark);
						}
						else if(statementmode.equals("0"))
						{
							dynamicheaders = datasource.find("select * from T_HEADER where TABLE_ID = ? and SUBSTATEMENT_ID = ? and TAGCODE = ? and MODE = 0", tableId, substatementId, mark);
						}
						if(dynamicheaders != null && dynamicheaders.size() > 0)
						{
							for(int i = 0 ; i < dynamicheaders.size() ; i++)
							{
								Datum dynamicheader = dynamicheaders.get(i);
								JSONArray array = new JSONArray(dynamicheader.getString("TEXT"));	
								for(int j = 0 ; j < array.length() ; j++)
								{
									dynamiccolumns.add(array.optString(j));
								}
							}
						}
						dynamiccolumnmap.put(mark, dynamiccolumns);
					}
				}
				catch(Exception e)
				{
					Throwable throwable = ThrowableUtils.getThrowable(e);
					message.message(ServiceMessage.FAILURE, throwable.getMessage());
				}
				finally
				{
					if(connection != null)
					{
						connection.close();
					}
				}
			}
			
			message.resource("dynamicheader", dynamiccolumnmap);
			message.resource("frozenheader", frozenheader);
			message.resource("activeheader", activeheader);
			
			
			String content = frozencolumns.toString();
			content = VariableService.parseUrlVariable(content, 0, request);
			content = VariableService.parseSysVariable(content, request);				
			message.resource("frozencolumns", new JSONArray(content));

			content = activecolumns.toString();
			content = VariableService.parseUrlVariable(content, 0, request);
			content = VariableService.parseSysVariable(content, request);	
			message.resource("activecolumns", new JSONArray(content));
			
			message.resource("groups", datastructure.getProperty().optJSONArray("groups"));
		}
	}
	catch(Exception e)
	{
		Throwable throwable = ThrowableUtils.getThrowable(e);
		message.message(ServiceMessage.FAILURE, throwable.getMessage());
	}

	out.println(message);
	

%>