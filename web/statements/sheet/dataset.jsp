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
					data = datasource.find("select * from "+sql+" T where SUBSTATEMENT_ID in ("+children+") and MODE = 0");
					//合并数据
					data = SystemUtils.merge(data, datastructure.getProperty().optJSONArray("columns"));
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