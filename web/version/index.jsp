<%@page import="com.system.SystemProperty"%>

<%@page contentType="text/html; charset=utf-8"%>

<%
	String folder = "version" + SystemProperty.FILESEPARATOR + "package";
%>

<!doctype html>

<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" /> 
<link rel="stylesheet" href="../style/css/app.css" />
<link rel="stylesheet" href="../lib/font-awesome/css/font-awesome.min.css" />
<link rel="stylesheet" href="../lib/uploadify/uploadify.css" />
<script type="text/javascript" src="../lib/jquery.js"></script>
<script type="text/javascript" src="../lib/uploadify/jquery.uploadify.js"></script>
<title></title>

<style>
	.uploadify-queue-item
	{
		margin:2px 5px 0px 5px; width:660px; max-width:660px;
	}	
	
	.linebreak{clear:both}

	button
	{
		background-color:#4ab6ef; border:0px solid transparent; color:#ffffff; cursor:pointer
	}

	#package-items{padding:0px 10px; margin:0px; border:1px solid #dddddd; overflow-y:scroll; margin-top:10px}
	#package-items li{list-style-type:none; border-bottom:1px solid #f5f5f5; padding:8px 0px; font-size:13px;}
	#package-items li .package-version{height:24px; line-height:24px; float:left; color:#111111}
	#package-items li .package-version span{color:#2679c5}

	#package-items li .package-date{height:24px; line-height:24px; float:right; color:#111111}
	#package-items li .package-date span{color:#2679c5}
	#package-items li .package-description{line-height:20px; color:#aaaaaa}
	#package-items li .package-description a{color:#0000FF; text-decoration:none;}

	#upgrade-container{display:none; filter:alpha(Opacity=50); -moz-opacity:0.5; opacity:0.5; width:100%; height:100%; top:0px; left:0px; position:absolute; background-color:#000000}
	#upgrade-log{display:none; letter-spacing:1px; color:#ffffff; font-size:20px; height:200px; top:150px; left:0px; position:absolute; width:100%; background-color:#01BCF3; text-align:center; line-height:150px}
	#upgrade-log a{color:#0000FF; text-decoration:none;}

</style>

<script type="text/javascript">
$(function()
{
	version();
	$("#upfile-button").uploadify(
	{
		'auto':true, 
		'buttonCursor': 'pointer', 
		'buttonText': '选择文件', 
		'uploader': '../plug-in/filemanager.jsp?action=up&folder='+$("#folder").val(), 
		'del': '../plug-in/filemanager.jsp?action=del&folder='+$("#folder").val(), 
		'swf': '../lib/uploadify/uploadify.swf',
		'cancelImg': '../lib/uploadify/uploadify-cancel.png', 
		'queueID': 'file-queue', 
		'width': '100',
		'height': '50',
		'checkExisting': '',
		'fileTypeExts':'*.zip',
		'onUploadStart': function(file)
		{
			var size = $("#file-queue").children().size();
			if(size > 1)
			{
				$('#upfile-button').uploadify('cancel')
			}
		},
		'onUploadSuccess': function(file, data, response)
		{
			$("#filename").val(file.name);
		},
		'removeCompleted': false,
		'multi': false
	});
	resize();
});

function version()
{
	$.getJSON("config.json", function(config)
	{
		$("#version-code").html(config.version);
		var histories = config.history;
		var html = "";
		var versions = [];
		for(var i = histories.length - 1 ; i >= 0 ; i--)
		{
			var item = histories[i];
			var version = item.version;
			if(versions.indexOf(version) == -1)
			{
				html += '<li><div class="package-version">版本号：<span>'+item.version+'</span></div><div class="package-date">更新日期：<span>'+item.date+'</span></div>';
				html += '<div class="linebreak"></div>';
				html += '<div class="package-description">';
				html += item.description;
				html += '</div">';
				html += '</li>';
			}

			versions.push(item.version);
		}

		$("#package-items").empty();
		$("#package-items").append(html);
	});
}

function upgrade()
{
	if( confirm('升级前请备份程序文件及数据库文件，现在确认升级吗？') )
	{ 
		var $logs = $("#upgrade-log");	
		$("#upgrade-container").fadeIn("fast");
		$("#upgrade-log").fadeIn("fast");
		$("#close-button").fadeIn("fast");
		$logs.html('正在升级中，请稍后......');
		$.getJSON("upgrade.jsp", {filename:$("#filename").val()}, function(messages)
		{
			if(messages.CODE == "0")
			{
				$logs.html('安装成功，请<span style="color:#0000ff" onclick="closePanel()">退出</span>系统并重启服务。');
			}
			else if(messages.CODE == "1")
			{
				$logs.html('安装失败，错误信息：'+messages.MESSAGE);
			}
			else if(messages.CODE == "2")
			{
				//$logs.html('安装成功，<span title="'+messages.MESSAGE+'">但有一些数据库语句<span style="color:#ff6600">冲突</span></span>，请<span style="color:#0000ff" onclick="closePanel()">退出</span>系统并重启服务。');
				$logs.html('安装成功，请<span title="'+messages.MESSAGE+'" style="color:#0000ff" onclick="closePanel()">退出</span>系统并重启服务。');
			}
			version();
		});
	}
}

function resize()
{
	$("#package-items").height( $(window).height() - 125);
}

function closePanel()
{
	$("#upgrade-container").fadeOut("fast");
	$("#upgrade-log").fadeOut("fast");
	$("#close-button").fadeOut("fast");
}

</script>
</head>

<body style="overflow:hidden; margin:10px 15px">
<div id="header">
	<div id="title" style="float:left; color:#2679c5; font-size:16px; height:25px; line-height:25px">升级维护中心</div>
	<div id="title" style="float:right; color:#2679c5; font-size:13px; height:25px; line-height:25px">系统版本：<span id="version-code"></span></div>
	<div class="linebreak"></div>
	<div style="border-bottom:1px dotted #dddddd; margin:4px 0px 10px 0px"></div>
</div>


<input type="hidden" id="folder" value="<%=folder%>">
<input type="hidden" id="filename" value="<%=folder%>">

<div id="package-panel">
	<div style="float:left">
		<button type="button" id="upfile-button" style="width:100px; height:50px;">选择文件</button>
	</div>
	<div id="file-queue" style="float:left; overflow:hidden; width:700px; height:50px; background-color:#F5F5F5"></div>
	<div style="float:left">
		<button type="button" onclick="upgrade()" id="upgrade-button" style="width:100px; height:50px;">升级系统</button>
	</div>
</div>

<div class="linebreak"></div>

<ul id="package-items"></ul>

<div id="upgrade-container"></div>
<div id="upgrade-log"></div>

</body>


</html>


