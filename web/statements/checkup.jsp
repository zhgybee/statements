<%@page import="com.system.utils.StatementUtils"%>
<%@page import="java.util.HashSet"%>
<%@page import="java.util.Set"%>
<%@page import="org.apache.commons.lang3.ArrayUtils"%>
<%@page import="com.system.datasource.Datum"%>
<%@page import="com.system.utils.ServiceMessage"%>
<%@page import="com.system.utils.ThrowableUtils"%>
<%@page import="org.apache.commons.lang3.StringUtils"%>
<%@page import="com.system.datasource.Data"%>
<%@page import="com.system.SystemProperty"%>
<%@page import="com.system.datasource.DataSource"%>
<%@page import="java.sql.Connection"%>
<%@page contentType="text/html; charset=utf-8"%>

<%

	ServiceMessage message = new ServiceMessage();
	String ismerge = StringUtils.defaultString(request.getParameter("merge"), "0");
	String statementId = StringUtils.defaultString(request.getParameter("statement"), "");
	String substatementId = StringUtils.defaultString(request.getParameter("substatement"), "");
	
	Connection connection = null;
	try
	{
		String[] warnings = new String[]{};
		connection = DataSource.connection(SystemProperty.DATASOURCE);	
		DataSource datasource = new DataSource(connection);	
		
		
		

		Data substatements = datasource.find("select * from T_SUBSTATEMENT where STATEMENT_ID = ?", statementId);
		Datum substatement = null;
		//得到所选择的子项目
		for(Datum item : substatements)
		{
			if(item.getString("ID").equals(substatementId))
			{
				substatement = item;
			}
		}

		String[] substatementIds = new String[]{};

		//找到当前子项目下的下级项目（包括当前子项目）
		Set<Datum> children = new HashSet<Datum>();
		children.addAll(StatementUtils.getChildSubStatements(new HashSet<Datum>(), substatement, substatements));
		children.add(substatement);
		for(Datum child : children)
		{
			substatementIds = ArrayUtils.add(substatementIds, "'"+child.getString("ID")+"'");
		}
		Datum datum1 = datasource.get(toSql("select QMSDQ as 'N', STATEMENT_ID, SUBSTATEMENT_ID from T01 where XMBH = 'K1001'", ismerge, statementId, substatementId, substatementIds));
		Datum datum2 = datasource.get(toSql("select sum(json_extract(B, '$.B1-1列')) as 'N', STATEMENT_ID, SUBSTATEMENT_ID FROM A", ismerge, statementId, substatementId, substatementIds));
		
		if(isWarning(datum1, datum2))
		{
			warnings = ArrayUtils.add(warnings, "发生错误");
		}
		
		message.resource("warnings", warnings);
	}
	catch(Exception e)
	{
		Throwable throwable = ThrowableUtils.getThrowable(e);
		message.message(ServiceMessage.FAILURE, throwable.getMessage());
		
		e.printStackTrace();
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

<%!
	public String toSql(String sql, String ismerge, String statementId, String substatementId, String[] substatementIds)
	{
		if(ismerge.equals("1"))
		{
			if(substatementId.equals(""))
			{
				return "select * from ("+sql+") where STATEMENT_ID = '"+statementId+"'";
			}
			else
			{
				return "select * from ("+sql+") where SUBSTATEMENT_ID in ("+StringUtils.join(substatementIds, ",")+")";
			}
		}
		else
		{
			return "select * from ("+sql+") where SUBSTATEMENT_ID = '"+substatementId+"'";
		}
	}

	public boolean isWarning(Datum datum1, Datum datum2)
	{
		return datum1 == null || datum2 == null || datum1.getDouble("N") != datum2.getDouble("N");
	}
%>

