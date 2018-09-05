<%@page import="org.apache.commons.io.FileUtils"%>
<%@page import="java.io.File"%>
<%@page import="com.system.SystemProperty"%>

<%@page contentType="text/html; charset=utf-8"%>
<%

	String[] directories = new String[]
	{
		"temp"
	};

	for(String directory : directories)
	{
		File file = new File(SystemProperty.PATH + SystemProperty.FILESEPARATOR + directory);
		FileUtils.cleanDirectory(file);
	}
%>
<!doctype html>
<html>
<head>
	<meta charset="UTF-8">
	<title></title>
	<link rel="stylesheet" href="../style/css/app.css" />
	<script type="text/javascript" src="../lib/jquery.js"></script>
	<script type="text/javascript">

		$(function()
		{
			$.get("user/export.jsp", function(){});
		});

	</script>
</head>
<body>

<p style="text-align:center; font-size:20px; margin:80px 30px; padding:10px; border-bottom:1px solid #eeeeee">清理完毕，请<a onclick="window.close()" style="color:#0000ff; cursor:pointer">点击</a>关闭！</p>

</body>
</html>
