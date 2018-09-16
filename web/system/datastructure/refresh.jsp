
<%@page import="org.apache.commons.io.FileUtils"%>
<%@page import="java.io.File"%>
<%@page import="org.json.JSONArray"%>
<%@page import="com.system.SystemProperty"%>
<%@page contentType="text/html; charset=utf-8"%>
<%
File structures = new File(SystemProperty.PATH + SystemProperty.FILESEPARATOR + "system" + SystemProperty.FILESEPARATOR +"datastructure"+ SystemProperty.FILESEPARATOR + "datastructure.json");
if(structures.exists())
{
	JSONArray datastructures = new JSONArray(FileUtils.readFileToString(structures, "UTF-8"));
	SystemProperty.DATASTRUCTURES.initialise(datastructures);
}
%>