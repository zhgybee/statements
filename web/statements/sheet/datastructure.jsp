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

	try
	{
		DataStructure datastructure = SystemProperty.DATASTRUCTURES.get(tableId);

		if(datastructure != null)
		{
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
			
			
			message.resource("frozenheader", frozenheader);
			message.resource("activeheader", activeheader);
			message.resource("frozencolumns", frozencolumns);
			message.resource("activecolumns", activecolumns);
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