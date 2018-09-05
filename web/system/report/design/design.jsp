<%@page import="com.system.SystemProperty"%>
<%@page import="org.apache.commons.lang3.StringUtils"%>
<%@page contentType="text/html; charset=utf-8"%>

<%
	String type = StringUtils.defaultString(request.getParameter("type"), "1");
	String id = request.getParameter("id");
%>

<!doctype html>
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" /> 
<title></title>

<link rel="stylesheet" href="../../../style/css/app.css" />
<link rel="stylesheet" href="../../../lib/font-awesome/css/font-awesome.min.css" />
<link rel="stylesheet" href="../../../lib/uploadify/uploadify.css" />

<script type="text/javascript" src="../../../lib/jquery.js"></script>
<script type="text/javascript" src="../../../lib/app.js"></script>
<script type="text/javascript" src="../../../lib/jquery.form.js"></script> 
<script type="text/javascript" src="../../../lib/uploadify/jquery.uploadify.js"></script>

<script type="text/javascript">
	$(document).ready
	(
		function()
		{
			resize();
			$(window).resize( function(){resize()} ); 
			$(".add-row-button").on("click", function()
			{
				copyrow($(this));
			});
			$('#design-form').ajaxForm();
		}
	);

	function copyrow($row)
	{
		var $fields = $row.parents("li");
		var $clone = $fields.clone();
		$clone.addClass("additional-row");
		var $button = $clone.find(".add-row-button");
		$button.html("删除");
		$button.css("background-color", "#E66B6D");
		$button.on("click", function()
		{
			$(this).parents("li").remove();
		});
		$fields.after($clone);
	}

	function resize()
	{
		var height = 0;
		if( $("#subheader-panel").is(":visible") ) 
		{
			height += $("#subheader-panel").outerHeight(true);
		}
		if( $("#mask").is(":visible") ) 
		{
			height += $("#mask").outerHeight(true);
		}
		$("#desgin-panel").height( $(window).outerHeight() - $("#header").outerHeight(true) - height );
	}

	function reset()
	{
		$("#design-form")[0].reset();
		$(".additional-row").remove();
	}

	function showMask(text)
	{
		$("#mask .mask-text").html(text);
		$("#mask").show();
		resize();
	}

	function hideMask()
	{
		$("#mask").hide();
		resize();
	}
</script>

<style>
	
	body{overflow:hidden}
	.save-button{font-weight:bold; margin:4px; height:40px; width:99%; cursor:pointer; background-color:#6fb3e0; border:1px solid transparent; color:#ffffff; line-height:40px}
	.uploadify-queue-item{margin:0px 5px 0px 5px;}
	
	ul li{padding:6px 0px; border-bottom:1px dotted #cccccc;}
	ul li a{color:#333333}
	ul li a:hover{color:#ff6600}

	ul .category{background-color:#f0f0f0; height:35px; line-height:35px; padding-left:15px; font-weight:bold}
	ul .grid{min-height:45px; height:auto}
	ul .grid div{float:left; text-align:center; margin:5px 0px 0px 15px; cursor:pointer}
	ul .grid div:hover{color:#ff6600}
	ul .grid div i{font-size:25px}
	
	
	ul li .label{float:left; width:150px; height:30px; line-height:30px; padding-left:15px}
	ul li .field{float:left; width:800px; height:30px; line-height:30px; padding-left:15px}
	ul li .mark{font-size:9px; margin:0px 12px 0px 4px}
	
	ul li .multi-label{padding-top:4px; line-height:14px; width:60px}
	ul li .multi-field{width:60px}
	ul li .multi-mark{font-size:9px; margin:0px}
	
	ul li button{cursor:pointer; height:26px; padding:0px 4px; margin:0px 4px 0px 0px; background-color:#4AB6EF; border: 1px solid transparent; color:#ffffff; line-height:normal}
	ul li .label i{}
	ul li .field input{width:100%; border:1px solid #d5d5d5; height:100%; padding:0px 4px; margin:0px; box-sizing:border-box;}
	ul li .field select{width:100%; border:1px solid #d5d5d5; height:100%; padding:0px; margin:0px; box-sizing:border-box;}
	ul li .field textarea{width:100%; border:1px solid #d5d5d5; height:100%; padding:4px; margin:0px; box-sizing:border-box;}

	#mask{position:relative; display:none; margin:5px 0px; padding:0px; line-height:30px; background-color:#fcf8e3; border-top:1px solid #faebcc; border-bottom:1px solid #faebcc; width:100%;}
	#mask .mask-text{margin:3px 0px 3px 20px; color:#8a6d3b}
	#mask .mask-close-button{position:absolute; right:10px; top:2px; font-size:20px; cursor:pointer}
	#mask .mask-text i{font-size:13px; margin-right:5px}
</style>

</head>
<body>
<form id="design-form" method="post">
<ul id="header">
	<li class="category">
		<a href="?type=1&id=<%=id%>" style="<%=type.equals("1")?"color:#ff6600":""%>">基本<span class="mark">GENERAL</span></a>
		<a href="?type=5&id=<%=id%>" style="<%=type.equals("5")?"color:#ff6600":""%>">查询项目<span class="mark">SEARCHER</span></a>
		<a href="?type=2&id=<%=id%>" style="<%=type.equals("2")?"color:#ff6600":""%>">数据源<span class="mark">SOURCE</span></a>
		<a href="?type=3&id=<%=id%>" style="<%=type.equals("3")?"color:#ff6600":""%>">页签<span class="mark">SHEET</span></a>
		<a href="?type=4&id=<%=id%>" style="<%=type.equals("4")?"color:#ff6600":""%>">单元格<span class="mark">ITEMS</span></a>
		<div style="float:right; padding-right:10px">
			<button type="button" id="save-button" onclick="save()">保存</button>
<%
	if(type.equals("2"))
	{
%>
			<button type="button" id="add-source-button">增加</button>
			<button type="button" id="debug-source-button">测试</button>
			<button type="button" id="delete-source-button" style="background-color:#F04747">删除</button>
<%
	}
	else if(type.equals("4"))
	{
%>
			<button type="button" id="delete-item-button" style="background-color:#F04747">删除</button>
			<button type="button" id="table-panel-button">表格</button>
<%
	}
%>
		</div>
	</li>
</ul>
<div id="mask"><p class="mask-text"></p><div class="mask-close-button" onclick="hideMask()"><i class="fa fa-times"></i></div></div>
<%
	if(type.equals("1"))
	{
		String folder = "system" + SystemProperty.FILESEPARATOR + "report" + SystemProperty.FILESEPARATOR + "template";
%>
<script type="text/javascript">
	$(document).ready
	(
		function()
		{
			$("#upfile-button").uploadify(
			{
				'auto':true, 
				'buttonCursor': 'pointer', 
				'buttonText': '选择文件', 
				'uploader': '../../../plug-in/filemanager.jsp?action=up&name=<%=id%>.xls&folder='+$("#folder").val(), 
				'del': '../../../plug-in/filemanager.jsp?action=del&name=<%=id%>.xls&folder='+$("#folder").val(), 
				'swf': '../../../lib/uploadify/uploadify.swf',
				'cancelImg': '../../../lib/uploadify/uploadify-cancel.png',
				'queueID': 'file-queue', 
				'width': '90',
				'height': '48',
				'checkExisting': '',
				'fileTypeExts':'*.xls',
				'onUploadStart': function(file)
				{
					var size = $("#file-queue").children().size();
					if(size > 1)
					{
						$('#upfile-button').uploadify('cancel')
					}
				},
				'removeCompleted': false,
				'multi': false
			});

			$.getJSON("report.json.jsp?id=<%=id%>", function(messages)
			{
				var code = messages.CODE;
				if(code == 0)
				{
					var report = messages.MESSAGE;
					$("[name='report-title']").val(report.TITLE);
					$("[name='report-handle']").val(report.HANDLE);
					$("[name='report-log']").val(report.LOG?"1":"0");
					$("[name='report-perview']").val(report.PERVIEW?"1":"0");

					var changers = report.CHANGER;
					if(changers != null)
					{
						var i = 0;
						for(var key in changers)
						{
							if(i > 0)
							{
								copyrow($("#add-changer-button"));
							}
							i++;
						}
						i = 0;
						for(var key in changers)
						{
							$($("[name='report-changer-value']").get(i)).val(key);
							$($("[name='report-changer-replacement']").get(i)).val(changers[key]);
							i++;
						}
					}
				}
				else
				{
					showMask('<i class="fa fa-times-circle"></i>'+messages.MESSAGE);
				}
			});

			
		}
	);

	function save()
	{
		$('#design-form').attr("action", "report.do.jsp?action=save-report-general&id=<%=id%>");
		showMask('<i class="fa fa-spinner fa-pulse fa-3x fa-fw"></i>正在保存中，请稍后...');
		$('#design-form').ajaxSubmit
		(
			function(messages)
			{
				messages = $.parseJSON(messages);
				var code = messages.CODE;
				if(code == 0)
				{
					showMask('<i class="fa fa-check"></i>保存成功');
				}
				else
				{
					showMask('<i class="fa fa-times-circle"></i>'+messages.MESSAGE);
				}
			}
		);
	}

</script>
<input type="hidden" id="folder" value="<%=folder%>">
<div id="desgin-panel" style="overflow:auto;">
	<ul>
		<li>
			<div class="label">表格名称<span class="mark">TITLE</span></div>
			<div class="field"><input type="text" name="report-title" /></div>
			<div style="clear:both"></div>
		</li>
		<li>
			<div class="label" style="height:48px; line-height:48px">表格文件<span class="mark">EXCEL</span></div>
			<div class="field" style="height:48px; line-height:48px">
				<div id="file-queue" style="float:left; overflow:hidden; width:710px; height:48px; background-color:#F5F5F5"></div>
				<div style="float:left"><button type="button" id="upfile-button" style="width:80px; height:48px;">选择文件</button></div>
			</div>
			<div style="clear:both"></div>
		</li>
		<li>
			<div class="label">解析页面<span class="mark">HANDLE</span></div>
			<div class="field"><input type="text" name="report-handle" /></div>
			<div style="clear:both"></div>
		</li>
		<li>
			<div class="label">日志<span class="mark">LOG</span></div>
			<div class="field"><select name="report-log"><option value="1">是</option><option value="0">否</option></select></div>
			<div style="clear:both"></div>
		</li>
		<li>
			<div class="label">预览<span class="mark">PREVIEW</span></div>
			<div class="field"><select name="report-perview"><option value="1">是</option><option value="0">否</option></select></div>
			<div style="clear:both"></div>
		</li>
		<li>
			<div class="label">转换<span class="mark">CHANGER</span></div>
			<div class="label multi-label" style="width:100px">值<br/><span class="mark multi-mark">VALUE</span></div>
			<div class="label multi-label" style="width:100px">转换<br/><span class="mark multi-mark">REPLACEMENT</span></div>
			<div style="clear:both"></div>
		</li>
		<li>
			<div class="label"><button type="button" id="add-changer-button" class="add-row-button">增加</button></div>
			<div class="field multi-field" style="width:100px"><input type="text" name="report-changer-value" /></div>
			<div class="field multi-field" style="width:100px"><input type="text" name="report-changer-replacement" /></div>
			<div style="clear:both"></div>
		</li>
	</ul>
</div>
<%
	}
	else if(type.equals("2"))
	{
%>
<script type="text/javascript">
	$(document).ready
	(
		function()
		{
			bulider();
		}
	);
	
	function bulider()
	{

		$.getJSON("report.json.jsp?id=<%=id%>", function(messages)
		{
			var code = messages.CODE;
			if(code == 0)
			{
				var $sqls = $("#sqls-panel");
				$sqls.empty();
				var report = messages.MESSAGE;
				var source = report.SOURCE;
				var sqls = source.SQLS;
				for(var key in sqls)
				{
					var $sql = $('<div><i class="fa fa-database"></i><br/><span class="mark multi-mark">'+key+'</span></div>');
					$sql.data("key", key);
					$sql.data("sql", sqls[key]);
					$sql.on("click", function()
					{
						reset();
						var sql = $(this).data("sql");
						var key = $(this).data("key");

				
						$("[name='report-sql-key-old']").val(key);
						$("[name='report-sql-key']").val(key);
						$("[name='report-sql-text']").val(sql.SQL);
						$("[name='report-sql-mapkey']").val(sql.MAPKEY);

						var joiner = sql.JOIN;
						if(joiner != null)
						{
							$("[name='report-sql-alias']").val(joiner.ALIAS);
							$("[name='report-sql-prefix']").val(joiner.PREFIX);
							$("[name='report-sql-index']").val(joiner.INDEX);
						}

						var moder = sql.MODE;
						if(moder != null)
						{
							$("[name='report-sql-mode-name']").val(moder.NAME);


							var parameters = moder.PARAMETER;
							var i = 0;
							for(var key in parameters)
							{
								if(i > 0)
								{
									copyrow($("#add-parameter-button"));
								}
								i++;
							}
							i = 0;
							for(var key in parameters)
							{
								$($("[name='report-sql-mode-parameter']").get(i)).val(key);
								$($("[name='report-sql-mode-value']").get(i)).val(parameters[key]);
								i++;
							}
						}

					});
					$sqls.prepend($sql);

				}
				$sqls.append('<div style="clear:both; margin:0px"></div>');
			}
			else
			{
				showMask('<i class="fa fa-times-circle"></i>'+messages.MESSAGE);
			}
		});
	}

	$("#add-source-button").on("click", function()
	{
		reset();
	});
	$("#debug-source-button").on("click", function()
	{
		alert("开发中...");
	});
	$("#delete-source-button").on("click", function()
	{
		if(confirm("确定删除所选择的数据源配置吗？"))
		{
			showMask('<i class="fa fa-spinner fa-pulse fa-3x fa-fw"></i>正在删除中，请稍后...');
			$.getJSON("report.do.jsp?action=delete-report-source&id=<%=id%>&key="+$("[name='report-sql-key-old']").val(), function(messages)
			{
				var code = messages.CODE;
				if(code == 0)
				{
					bulider();
					reset();
					showMask('<i class="fa fa-check"></i>删除成功');
				}
				else
				{
					showMask('<i class="fa fa-times-circle"></i>'+messages.MESSAGE);
				}
			});
		}
	});

	function save()
	{
		if($("[name='report-sql-key']").val() == "")
		{
			showMask('<i class="fa fa-times-circle"></i>请填写数据源名称')
			return;
		}
		$('#design-form').attr("action", "report.do.jsp?action=save-report-source&id=<%=id%>");
		showMask('<i class="fa fa-spinner fa-pulse fa-3x fa-fw"></i>正在保存中，请稍后...');
		$('#design-form').ajaxSubmit
		(
			function(messages)
			{
				messages = $.parseJSON(messages);
				var code = messages.CODE;
				if(code == 0)
				{
					bulider();
					showMask('<i class="fa fa-check"></i>保存成功');
				}
				else
				{
					showMask('<i class="fa fa-times-circle"></i>'+messages.MESSAGE);
				}
			}
		);
	}
</script>
<ul id="subheader-panel">
	<li id="sqls-panel" class="grid"></li>
</ul>
<div id="desgin-panel" style="overflow:auto;">
	<ul>
		<li>
			<div class="label">名称<span class="mark">KEY</span></div>
			<div class="field"><input type="hidden" name="report-sql-key-old"/><input type="text" name="report-sql-key"/></div>
			<div style="clear:both"></div>
		</li>
		<li style="height:100px">
			<div class="label" style="height:100%; line-height:30px">查询语句<span class="mark">SQL</span></div>
			<div class="field" style="height:100%;"><textarea name="report-sql-text"></textarea></div>
			<div style="clear:both"></div>
		</li>
		<li>
			<div class="label">转换键<span class="mark">MAPKEY</span></div>
			<div class="field"><input type="text" name="report-sql-mapkey"/></div>
			<div style="clear:both"></div>
		</li>
		<li>
			<div class="label">合并项<span class="mark">ALIAS</span></div>
			<div class="field"><input type="text" name="report-sql-alias"/></div>
			<div style="clear:both"></div>
		</li>
		<li>
			<div class="label">前缀<span class="mark">PREFIX</span></div>
			<div class="field"><input type="text" name="report-sql-prefix"/></div>
			<div style="clear:both"></div>
		</li>
		<li>
			<div class="label">条目<span class="mark">INDEX</span></div>
			<div class="field"><input type="text" name="report-sql-index"/></div>
			<div style="clear:both"></div>
		</li>
		<li>
			<div class="label">策略<span class="mark">NAME</span></div>
			<div class="field"><input type="text" name="report-sql-mode-name"/></div>
			<div style="clear:both"></div>
		</li>
		<li>
			<div class="label">参数<span class="mark">PARAMETER</span></div>
			<div class="label multi-label" style="width:100px">名称<br/><span class="mark multi-mark">NAME</span></div>
			<div class="label multi-label" style="width:100px">值<br/><span class="mark multi-mark">VALUE</span></div>
			<div style="clear:both"></div>
		</li>
		<li>
			<div class="label"><button type="button" id="add-parameter-button" class="add-row-button">增加</button></div>
			<div class="field multi-field" style="width:100px"><input type="text" name="report-sql-mode-parameter"/></div>
			<div class="field multi-field" style="width:100px"><input type="text" name="report-sql-mode-value"/></div>
			<div style="clear:both"></div>
		</li>
	</ul>
</div>
<%
	}
	else if(type.equals("3"))
	{
%>
<script type="text/javascript">
	$(document).ready
	(
		function()
		{
			$.getJSON("report.json.jsp?id=<%=id%>", function(messages)
			{
				var code = messages.CODE;
				if(code == 0)
				{
					var report = messages.MESSAGE;
					var sheet = report.SHEET;
					$("[name='report-sheet-mode']").val(sheet.MODE);
					$("[name='report-sheet-name']").val(sheet.NAME);
					$("[name='report-sheet-source']").val(sheet.SOURCE);
				}
				else
				{
					showMask('<i class="fa fa-times-circle"></i>'+messages.MESSAGE);
				}
			});
		}
	);
	function save()
	{
		$('#design-form').attr("action", "report.do.jsp?action=save-report-sheet&id=<%=id%>");
		showMask('<i class="fa fa-spinner fa-pulse fa-3x fa-fw"></i>正在保存中，请稍后...');
		$('#design-form').ajaxSubmit
		(
			function(messages)
			{
				messages = $.parseJSON(messages);
				var code = messages.CODE;
				if(code == 0)
				{
					showMask('<i class="fa fa-check"></i>保存成功');
				}
				else
				{
					showMask('<i class="fa fa-times-circle"></i>'+messages.MESSAGE);
				}
			}
		);
	}
</script>
<ul>
	<li>
		<div class="label">方式<span class="mark">MODE</span></div>
		<div class="field"><select name="report-sheet-mode"><option value="KEYWORD-SHEET">KEYWORD-SHEET</option><option value="ONE-SHEET">ONE-SHEET</option></select></div>
		<div style="clear:both"></div>
	</li>
	<li>
		<div class="label">名称<span class="mark">NAME</span></div>
		<div class="field"><input type="text" name="report-sheet-name" /></div>
		<div style="clear:both"></div>
	</li>
	<li>
		<div class="label">数据源<span class="mark">SOURCE</span></div>
		<div class="field"><input type="text" name="report-sheet-source" /></div>
		<div style="clear:both"></div>
	</li>
</ul>
<%
	}
	else if(type.equals("4"))
	{
%>

<script type="text/javascript">
	$(document).ready
	(
		function()
		{
			$("#table-panel-button").on("click", function()
			{
				$("#subheader-panel").toggle();
				resize();
			});

			$("#delete-item-button").on("click", function()
			{
				if(confirm("确定删除所选择的单元格配置吗？"))
				{
					showMask('<i class="fa fa-spinner fa-pulse fa-3x fa-fw"></i>正在删除中，请稍后...');
					$.getJSON("report.do.jsp?action=delete-report-item&id=<%=id%>&row="+$("[name='report-item-row']").val()+"&col="+$("[name='report-item-col']").val(), function(messages)
					{
						var code = messages.CODE;
						if(code == 0)
						{
							var frame = document.getElementById("tempalte-frame").window || document.getElementById("tempalte-frame").contentWindow;
							frame.initialise();
							showMask('<i class="fa fa-check"></i>删除成功');
						}
						else
						{
							showMask('<i class="fa fa-times-circle"></i>'+messages.MESSAGE);
						}
					});
				}
			});
		}
	);

	function setItem(row, col)
	{
		reset();
		$("[name='report-item-row']").val(row);
		$("[name='report-item-col']").val(col);
		$.getJSON("report.json.jsp?id=<%=id%>&bit=1&row="+row+"&col="+col, function(messages)
		{
			var code = messages.CODE;
			if(code == 0)
			{
				var item = messages.MESSAGE;
				if(item != null)
				{
					$("[name='report-item-output']").val(item.OUTPUT);
					$("[name='report-item-expression']").val(item.EXPRESSION?"1":"0");
					$("[name='report-item-type']").val(item.TYPE?item.TYPE:"");
					$("[name='report-item-formatter']").val(item.FORMATTER);
					$("[name='report-item-debar']").val(item.DEBAR?"1":"0");


					var columns = item.COLUMNS;
					if(columns != null)
					{
						for(var i = 0 ; i < columns.length - 1 ; i++)
						{
							copyrow($("#add-column-button"));
						}

						$.each(columns, function(i, column)
						{
							$($("[name='report-item-column-alias']").get(i)).val(column.ALIAS);
							$($("[name='report-item-column-source']").get(i)).val(column.SOURCE);
							$($("[name='report-item-column-name']").get(i)).val(column.NAME);
							$($("[name='report-item-column-symbol']").get(i)).val(column.SYMBOL);
							$($("[name='report-item-column-default']").get(i)).val(column.DEFAULT);
							$($("[name='report-item-column-type']").get(i)).val(column.TYPE);
							$($("[name='report-item-column-formatter']").get(i)).val(column.FORMATTER);
							$($("[name='report-item-column-dictionary']").get(i)).val(column.DICTIONARY);
							$($("[name='report-item-column-conditions']").get(i)).val(column.CONDITIONS);

						});
					}

				}
			}
			else
			{
				showMask('<i class="fa fa-times-circle"></i>'+messages.MESSAGE);
			}
		});
	}

	function save()
	{
		$('#design-form').attr("action", "report.do.jsp?action=save-report-item&id=<%=id%>&row="+$("[name='report-item-row']").val()+"&col="+$("[name='report-item-col']").val());
		showMask('<i class="fa fa-spinner fa-pulse fa-3x fa-fw"></i>正在保存中，请稍后...');
		$('#design-form').ajaxSubmit
		(
			function(messages)
			{
				messages = $.parseJSON(messages);
				var code = messages.CODE;
				if(code == 0)
				{
					var frame = document.getElementById("tempalte-frame").window || document.getElementById("tempalte-frame").contentWindow;
					frame.initialise();
					showMask('<i class="fa fa-check"></i>保存成功');
				}
				else
				{
					showMask('<i class="fa fa-times-circle"></i>'+messages.MESSAGE);
				}
			}
		);
	}
</script>
<div id="subheader-panel" style="border-bottom:1px dotted #cccccc; height:240px">
	<iframe src="template.jsp?id=<%=id%>" style="background-color:#ffffff; border:none; width:100%; height:100%" frameborder="0" id="tempalte-frame"></iframe>
</div>
<div id="desgin-panel" style="overflow:auto;">
<ul>
	<li>
		<div class="label">行列<span class="mark">ROW-COL</span></div>
		<div class="field"><input type="text" style="width:395px; margin-right:10px; background-color:#f6f6f6" name="report-item-row" readonly="true" /><input type="text" style="width:395px; background-color:#f6f6f6" name="report-item-col" readonly="true" /></div>
		<div style="clear:both"></div>
	</li>
	<li>
		<div class="label">输出<span class="mark">OUTPUT</span></div>
		<div class="field"><input type="text" name="report-item-output" /></div>
		<div style="clear:both"></div>
	</li>
	<li>
		<div class="label">表达式<span class="mark">EXPRESSION</span></div>
		<div class="field"><select name="report-item-expression"><option value="0">否</option><option value="1">是</option></select></div>
		<div style="clear:both"></div>
	</li>
	<li>
		<div class="label">数据类型<span class="mark">TYPE</span></div>
		<div class="field" style="width:300px; margin-right:50px">
			<select name="report-item-type">
				<option value=""></option>
				<option value="number">数字 Number</option>
				<option value="date">字符 Date</option>
			</select>
		</div>
		<div class="label" style="width:120px;">格式化<span class="mark">FORMATTER</span></div>
		<div class="field" style="width:300px"><input type="text" name="report-item-formatter" /></div>
		<div style="clear:both"></div>
	</li>
	<li>
		<div class="label">全局转换<span class="mark">DEBAR</span></div>
		<div class="field"><select name="report-item-debar"><option value="0">否</option><option value="1">是</option></select></div>
		<div style="clear:both"></div>
	</li>
	
	<li>
		<div class="label">数据项<span class="mark">COLUMNS</span></div>
		<div class="label multi-label">别名<br/><span class="mark multi-mark">ALIAS</span></div>
		<div class="label multi-label">数据源<br/><span class="mark multi-mark">SOURCE</span></div>
		<div class="label multi-label">字段名<br/><span class="mark multi-mark">NAME</span></div>
		<div class="label multi-label" style="width:95px">逻辑<br/><span class="mark multi-mark">SYMBOL</span></div>
		<div class="label multi-label">默认值<br/><span class="mark multi-mark">DEFAULT</span></div>
		<div class="label multi-label" style="width:110px">数据类型<br/><span class="mark multi-mark">TYPE</span></div>
		<div class="label multi-label" style="width:100px">格式化<br/><span class="mark multi-mark">FORMATTER</span></div>
		<div class="label multi-label" style="width:140px">字典<br/><span class="mark multi-mark">DICTIONARY</span></div>
		<div class="label multi-label" style="width:140px">条件<br/><span class="mark multi-mark">CONDITIONS</span></div>
		<div style="clear:both"></div>
	</li>
	<li>
		<div class="label"><button type="button" id="add-column-button" class="add-row-button">增加</button></div>
		<div class="field multi-field"><input type="text" name="report-item-column-alias" /></div>
		<div class="field multi-field"><input type="text" name="report-item-column-source" /></div>
		<div class="field multi-field"><input type="text" name="report-item-column-name" /></div>
		<div class="field multi-field" style="width:95px">
			<select name="report-item-column-symbol">
				<option value=""></option>
				<option value="max">最大 Max</option>
				<option value="min">最小 Min</option>
				<option value="sum">合计 Sum</option>
				<option value="count">数量 Count</option>
				<option value="1">第一条</option>
				<option value="2">第二条</option>
				<option value="3">第三条</option>
				<option value="-3">倒数第三条</option>
				<option value="-2">倒数第二条</option>
				<option value="-1">倒数第一条</option>
			</select>
		</div>
		<div class="field multi-field"><input type="text" name="report-item-column-default" /></div>
		<div class="field multi-field" style="width:110px">
			<select name="report-item-column-type">
				<option value=""></option>
				<option value="number">数字 Number</option>
				<option value="date">字符 Date</option>
		</select>
		</div>
		<div class="field multi-field" style="width:100px"><input type="text" name="report-item-column-formatter" /></div>
		<div class="field multi-field" style="width:140px"><input type="text" name="report-item-column-dictionary" /></div>
		<div class="field multi-field" style="width:140px"><input type="text" name="report-item-column-conditions" /></div>
		<div style="clear:both"></div>
	</li>
</ul>
</div>
<%
	}
	else if(type.equals("5"))
	{
%>
<script type="text/javascript">
	$(document).ready
	(
		function()
		{
			$.getJSON("report.json.jsp?id=<%=id%>", function(messages)
			{
				var code = messages.CODE;
				if(code == 0)
				{
					var $sqls = $("#sqls-panel");
					$sqls.empty();
					var report = messages.MESSAGE;
					var searchers = report.SEARCHER;

					for(var i = 0 ; i < searchers.length - 1 ; i++)
					{
						copyrow($("#add-searcher-button"));
					}

					$.each(searchers, function(i, searcher)
					{
						$($("[name='report-searcher-title']").get(i)).val(searcher.title);

						var editor = searcher.editor;
						if(editor != null)
						{
							$($("[name='report-searcher-type']").get(i)).val(editor.type);
							$($("[name='report-searcher-name']").get(i)).val(editor.fieldname);
							$($("[name='report-searcher-value']").get(i)).val(editor.value);
						}

						var dictionary = searcher.dictionary;
						if(dictionary != null)
						{
							$($("[name='report-searcher-dictionary-list']").get(i)).val(dictionary.list);
							$($("[name='report-searcher-dictionary-map']").get(i)).val(dictionary.map);
						}

					});
				}
				else
				{
					showMask('<i class="fa fa-times-circle"></i>'+messages.MESSAGE);
				}
			});
		}
	);

	function save()
	{
		$('#design-form').attr("action", "report.do.jsp?action=save-report-searcher&id=<%=id%>");
		showMask('<i class="fa fa-spinner fa-pulse fa-3x fa-fw"></i>正在保存中，请稍后...');
		$('#design-form').ajaxSubmit
		(
			function(messages)
			{
				messages = $.parseJSON(messages);
				var code = messages.CODE;
				if(code == 0)
				{
					showMask('<i class="fa fa-check"></i>保存成功');
				}
				else
				{
					showMask('<i class="fa fa-times-circle"></i>'+messages.MESSAGE);
				}
			}
		);
	}
</script>
<div id="desgin-panel" style="overflow:auto;">
<ul>
	<li>
		<div class="label">查询项<span class="mark">SEARCHER</span></div>
		<div class="label multi-label" style="width:100px">标题<br/><span class="mark multi-mark">TITLE</span></div>
		<div class="label multi-label" style="width:100px">输入类型<br/><span class="mark multi-mark">TYPE</span></div>
		<div class="label multi-label" style="width:110px">名称<br/><span class="mark multi-mark">FIELDNAME</span></div>
		<div class="label multi-label" style="width:100px">默认值<br/><span class="mark multi-mark">VALUE</span></div>
		<div class="label multi-label" style="width:140px">字典<br/><span class="mark multi-mark">DICTIONARY</span></div>
		<div style="clear:both"></div>
	</li>
	<li>
		<div class="label"><button type="button" id="add-searcher-button" class="add-row-button">增加</button></div>
		<div class="field multi-field" style="width:100px"><input type="text" name="report-searcher-title" /></div>
		<div class="field multi-field" style="width:100px">
			<select name="report-searcher-type">
				<option value="text">文本 Text</option>
				<option value="date">日期 Date</option>
				<option value="choice">选择 Choice</option>
				<option value="tree">树形 Tree</option>
			</select>
		</div>
		<div class="field multi-field" style="width:110px"><input type="text" name="report-searcher-name" /></div>
		<div class="field multi-field" style="width:100px"><input type="text" name="report-searcher-value" /></div>
		<div class="field multi-field" style="width:280px"><input type="text" style="width:130px; margin-right:10px" name="report-searcher-dictionary-list" /><input type="text" style="width:130px" name="report-searcher-dictionary-map" /></div>
		<div style="clear:both"></div>
	</li>
</ul>
</div>
<%
	}
%>
</form>
</body>
</html>
