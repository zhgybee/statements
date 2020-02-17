<%@page import="com.system.datasource.Datum"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="org.json.JSONArray"%>
<%@page import="com.system.utils.StatementUtils"%>
<%@page import="com.system.utils.SystemUtils"%>
<%@page import="java.net.URLDecoder"%>
<%@page import="com.system.utils.ThrowableUtils"%>
<%@page import="com.system.datasource.DataSource"%>
<%@page import="com.system.variable.VariableService"%>
<%@page import="com.system.datasource.Data"%>
<%@page import="com.system.SystemProperty"%>
<%@page import="com.system.datastructure.DataStructure"%>
<%@page import="java.sql.Connection"%>
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
	
	Connection connection = null;
	try
	{
		DataStructure datastructure = SystemProperty.DATASTRUCTURES.get(tableId);
		if(datastructure != null)
		{
			connection = DataSource.connection(SystemProperty.DATASOURCE);	
			DataSource datasource = new DataSource(connection);	
			
			
			String number = datastructure.getProperty().optString("datasource");
			String sql = null;
			if(!number.equals(""))
			{
				JSONObject sqls = SystemProperty.SQLBUILDER.get(number);
				if(sqls != null)
				{
					sql = sqls.optString("sql");
					sql = VariableService.parseUrlVariable(sql, 0, request);
					sql = VariableService.parseSysVariable(sql, request);
				}
			}
			Data data = new Data();
			if(sql == null)
			{
				sql = datastructure.getProperty().optString("table");

				if(statementmode.equals("2"))
				{
					JSONArray columns = datastructure.getProperty().optJSONArray("columns");
					//合并数据包括单体数据（MODE = 0）及合并抵消表中的数据（MODE = 1）
					data = datasource.find("select * from "+sql+" T where SUBSTATEMENT_ID in ("+children+") and (MODE = 0 or MODE = 1)");
					//合并数据
					data = SystemUtils.merge(data, columns);
					
					//处理需要额外计算的合并字段，字段通过配置sql实现额外计算，sql中需要返回分组数据（key）及计算结果数据（value）。
					JSONObject storage = new JSONObject();
					storage.put("children", children);
					String mergecolumn = "";
					for( int i = 0 ; i < columns.length() ; i++ )
					{
						JSONObject column = columns.optJSONObject(i);
						if(column.has("merge"))
						{
							JSONObject mergeconfig = column.optJSONObject("merge");
							if(mergeconfig.has("group"))
							{
								//得到该表中合并分组字段（注意，分组字段在配置文件（datastructure.json）中必须设置在合并字段前）
								//可能会带来问题，但配置文件中分组字段全部在合并字段前，可暂时不改
								mergecolumn = column.optString("name");
							}
							if(mergeconfig.has("datasource"))
							{
								number = mergeconfig.optString("datasource");
								if(!number.equals(""))
								{
									JSONObject sqls = SystemProperty.SQLBUILDER.get(number);
									if(sqls != null)
									{
										String source = sqls.optString("sql");
										source = VariableService.parseUrlVariable(source, 0, request);
										source = VariableService.parseSysVariable(source, request);
										source = VariableService.parseJSONVariable(source, storage);
										
										Data replacements = datasource.find(source);
										
										Map<String, String> map = new HashMap<String, String>();										
										for(Datum replacement : replacements)
										{
											map.put(replacement.getString("key"), replacement.getString("value"));
										}
										for(Datum datum : data)
										{
											datum.put(column.optString("name"), map.get( datum.getString(mergecolumn) ));
										}
									}
								}
							}
						}
					}
				}
				else if(statementmode.equals("1"))
				{
					data = datasource.find("select * from "+sql+" T where SUBSTATEMENT_ID = ? and MODE = 1", substatementId);
				}
				else if(statementmode.equals("0"))
				{
					data = datasource.find("select * from "+sql+" T where SUBSTATEMENT_ID = ? and MODE = 0", substatementId);
				}
			}
			else
			{
				data = datasource.find(sql);
			}
			
			message.resource("dataset", data);
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
	out.println(message.toString());
%>