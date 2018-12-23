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
	String merge = StringUtils.defaultString(request.getParameter("merge"), "");
	String children = StringUtils.defaultString(request.getParameter("children"), "");

	children = URLDecoder.decode(children, "UTF-8");
	
	Connection connection = null;
	try
	{
		DataStructure datastructure = SystemProperty.DATASTRUCTURES.get(tableId);
		if(datastructure != null)
		{
			String number = datastructure.getProperty().optString("datasource");
			String sql = null;
			if(number.equals(""))
			{
				sql = "select * from "+datastructure.getProperty().optString("table");
			}
			else
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
			
			if(sql != null)
			{
				connection = DataSource.connection(SystemProperty.DATASOURCE);	
				DataSource datasource = new DataSource(connection);	
				if(merge.equals("1"))
				{
					if(substatementId.equals(""))
					{
						data = datasource.find("select * from ("+sql+") T where T.STATEMENT_ID = ?", statementId);
					}
					else
					{
						data = datasource.find("select * from ("+sql+") T where SUBSTATEMENT_ID in ("+children+")");
					}
				}
				else
				{
					data = datasource.find("select * from ("+sql+") T where SUBSTATEMENT_ID = ?", substatementId);
				};
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
	out.println(message);
%>