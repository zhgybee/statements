<%@page import="org.json.JSONObject"%>
<%@page import="org.apache.commons.io.FileUtils"%>
<%@page import="java.io.File"%>
<%@page import="com.system.SystemProperty"%>
<%@page import="com.system.SessionUser"%>
<%@page import="org.apache.commons.lang3.StringUtils"%>
<%@page import="java.util.Set"%>
<%@page import="java.util.Map"%>
<%@page contentType="text/html; charset=utf-8"%>

<%

	Map<String, String[]> parameters = request.getParameterMap();
	Set<String> keys = parameters.keySet();
	
	SessionUser sessionUser = SessionUser.getSessionUser(session);
	String id = sessionUser.getId();
	

	String reportcode = request.getParameter("reportcode");
	
	JSONObject report = new JSONObject(FileUtils.readFileToString(new File(SystemProperty.PATH + SystemProperty.FILESEPARATOR + "system" + SystemProperty.FILESEPARATOR + "report" + SystemProperty.FILESEPARATOR + "config" + SystemProperty.FILESEPARATOR + reportcode+".json"), "UTF-8"));

	boolean isLog = report.optBoolean("LOG");
%>

<!doctype html>

<html>
<head>	
	<meta http-equiv="X-UA-Compatible" content="IE=edge" />
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" /> 
	<title></title>
	<link rel="stylesheet" href="../../../style/css/app.css" />
	<link rel="stylesheet" href="../../../lib/font-awesome/css/font-awesome.min.css" />
	<link rel="stylesheet" href="../../../lib/selection/selection.css"/>
	<script type="text/javascript" src="../../../lib/jquery.js"></script>
	<script type="text/javascript" src="../../../lib/app.js"></script>
	<script type="text/javascript" src="../../../lib/selection/selection.js"></script>
	<script type="text/javascript" src="../../datastructure/datastructure.js"></script>

	<style>
	#report-container{position:relative; padding:0px 10px; display:none}
	#report-container iframe{border:none; width:100%; height:100%; position:absolute; top:0px; left:0px;}
	#searcher-container{padding:4px 10px 0px 10px}
	#searcher li{float:left; margin-right:20px;}
	#searcher li label{margin-right:6px; font-size:14px}
	#searcher li input{border:1px solid #d5d5d5; height:26px; ;padding:0px 4px}
	#button-container{text-align:center; padding:10px}
	.button{padding:5px 10px; background-color:#6fb3e0; color:#ffffff; border:none}
	.button i{font-size:14px; margin-right:3px;}
	
	#debug-container{display:none}
	#debug-panel, #debug-opacity{width:100%; position:absolute; top:0px; left:0px; overflow-y:scroll}
	#debug-opacity{opacity:0.5; filter:alpha(opacity=50); background-color:#cccccc;}
	#debug{overflow-y:scroll; height:500px; margin: 30px auto; width:950px; background-color: #ffffff; border: 1px solid #555555; border-collapse: collapse; box-shadow: -2px 0 2px #adadad, 2px 0 2px #adadad, 1px -1px 2px #adadad, 0 2px 2px #adadad; padding:25px 20px;}
	#debug li{padding:4px; border-bottom:1px dotted #aaaaaa}
	
	</style>
	
	<script type="text/javascript">
	var structureutils = new DataStructureUtils();
	var reportcode = app.getParameter("reportcode");
	var uuid = "<%=reportcode%>-<%=id%>";

	$(function()
	{
		$(window).resize( function(){resize()} ); 
		$.getJSON("../config/"+reportcode+".json", {}, function(config)
		{
			var searchers = config.SEARCHER;
			if(searchers != null)
			{
				var $searchers = $("#searcher");
				$.each(searchers, function(i, searcher)
				{
					var title = searcher.title;
					var $searcher = $('<li/>');
					$searcher.append('<label>'+title+'</label>');
					$searcher.append(structureutils.field( {column:searcher}, 'searcher' ));
					$searchers.append($searcher);
				});

				$("#search-button").show();
				$("#search-button").on("click", function()
				{
					create(config);
				});
			}
			resize();

			create(config);
		});
	});

	function resize()
	{
		$("#debug-opacity").height( $(window).outerHeight(true) );
		$("#debug").height( $("#debug-opacity").outerHeight(true) - 120 );
		$("#report-container").height( $(window).outerHeight(true) - $("#searcher-container").outerHeight(true) - $("#button-container").outerHeight(true));
	}

	function create(config)
	{
		var url = config.HANDLE;
		url = app.setParameter(url, "reportcode", reportcode);
		url = app.setParameter(url, "reportname", uuid);

		var args = {};
		var searchers = config.SEARCHER;
		if(searchers != null)
		{
			$.each(searchers, function(i, searcher)
			{
				var fieldname = searcher.editor.fieldname;
				args[fieldname] = $("[name='"+fieldname+"']").val();
			});

			$("#search-button").show();
		}


<%
		for(String key : keys)
		{
%>			
			args["<%=key%>"] = "<%=StringUtils.join(parameters.get(key), ",")%>";
<%			
		}
%>
		args["html"] = 1;
		$.post(url, args, function(content)
		{
			var data = $.parseJSON(content);
			var code = data.CODE;
			if(code == 0)
			{
				$("#export-button").on("click", function()
				{
					window.open(app.getContextPath()+"/"+data.XLS);
				});
				$("#report-container iframe").attr("src", app.getContextPath()+"/"+data.HTML);

				$("#message-text").hide();
				$("#report-container").show();
				
				<%
					if(isLog)
					{
				%>
					var logs = data.LOG;
					$.each(logs, function(i, log)
					{
						$("#debug-panel #debug").append('<li>'+log+'</li>');
					});				
					
					$("#debug-button").on("click", function()
					{
						$("#debug-container").slideDown();	
					});	
					
					$("#debug-panel").on("click", function()
					{
						$("#debug-container").hide();
					});
					
					$("#debug").on("click", function(event)
					{
						event.stopPropagation();
					});
				<%
					}
				%>				
				
			}
			else
			{
				alert("报表生成错误，请查看日志。（"+data.MESSAGE+"）");
			}
		});


	}

	</script>
</head>
<body>
	<div id="searcher-container">
		<ul id="searcher"></ul>
		<div class="line-break"></div>
	</div>
	<div id="button-container">
		<button id="search-button" type="button" class="button" style="display:none"><i class="fa fa-search"></i>搜索</button>
		<button id="export-button" type="button" class="button" style=""><i class="fa fa-file-text"></i>导出表格</button>
		<%
			if(isLog)
			{
		%>
				<button id="debug-button" type="button" class="button" style=""><i class="fa fa-bug"></i>日志</button>
		<%
			}
		%>
	</div>
	<p id="message-text" style="text-align:center; font-size:20px; margin-top:120px">表格生成中请稍后&nbsp;<i class="fa fa-spinner fa-pulse fa-fw"></i></p>
	<div id="report-container"><iframe frameborder="0" id="report-frame" name="report-frame"></iframe></div>

	<div id="debug-container">
		<div id="debug-opacity"></div>
		<div id="debug-panel">
			<ul id="debug"></ul>
		</div>
	</div>		
</body>
</html>
