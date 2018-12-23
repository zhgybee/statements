var app = {};
(function (app) 
{
	app.pagesize = 10;
	app.showLoading = function() 
	{
		var $loading = $("#loading-panel");
		if($loading.length == 0)
		{
			var content = '<div id="loading-panel" style="display:none">';
			content += '<div class="loading-mask"></div>';
			content += '<div class="loading-toast"><img src="'+app.getContextPath()+'/style/images/loading.gif"/></div>';
			content += '</div>';
			$("body").append(content);
			$loading = $("#loading-panel");
		}

		var loadimage = $loading.find(".loading-toast");
		if($(document).scrollTop() > 0)
		{
			loadimage.css("left", $(window).outerWidth(true) / 2 - loadimage.width() / 2);
			loadimage.css("top", $(document).scrollTop() + $(window).outerHeight(true) / 2 - loadimage.height() / 2 - 30);
		}
		else
		{
			loadimage.css("left", $(window).outerWidth(true) / 2 - loadimage.width() / 2);
			loadimage.css("top", $(window).outerHeight(true) / 2 - loadimage.height() / 2 - 30);
		}

		$loading.show();
	}

	app.message = function(text, title) 
	{
		var $loading = $("#messages-panel");
		if($loading.length == 0)
		{
			var content = '<div id="messages-panel" style="display:none">';
			content += text+'<div class="close-button">关闭</div>';
			content += '</div>';
			$("body").append(content);
			$loading = $("#messages-panel");
			
			$("#messages-panel .close-button").on("click", function()
			{
				$loading.hide();
			});

		}
		$loading.show();
	}

	app.alert = function(text) 
	{
		alert(text);
	}

	app.hideLoading = function() 
	{
		var $loading = $("#loading-panel");
		$loading.hide();
	}

	app.showSubStatementTreePanel = function(statementId, callback)
	{
		var $choice = $("#choice-substatement-panel");
		if($choice.length == 0)
		{
			var content = '';
			content += '<div class="choice-panel" id="choice-substatement-panel" style="display:none">';
			content += '	<div class="choice-mask"></div>';
			content += '	<div class="choice-frame">';
			content += '		<div class="choice-toolbar clearfix">';
			content += '			<h5 class="left">父节点选择</h5>';
			content += '			<div class="right"><input type="text" id="substatement-searcher-field" placeholder="请输入搜索内容..."/><i class="fa fa-search"></i></div>';
			content += '		</div>';
			content += '		<div class="substatement-panel"><ul></ul></div>';
			content += '		<div class="choice-button-panel"><button class="save-button">确定</button><button class="close-button">关闭</button></div>';
			content += '	</div>';
			content += '</div>';
			$("body").append(content);
			$choice = $("#choice-substatement-panel");
			$choice.find(".close-button").on("click", function()
			{
				$choice.hide();
			});
		}

		$.getJSON(app.getContextPath()+"/statements/statement.jsp?mode=7&statement="+statementId, function(response)
		{
			if(response.status == "1")
			{
				var substatements = response.resource.substatements;
				substatements = app.toTree(substatements);

				var $substatements = $choice.find(".substatement-panel ul");
				$substatements.empty();
				$.each(substatements, function(i, substatement)
				{
					var icon = substatement.USERICON || "";
					if(icon == "")
					{
						icon = "user.png"
					}
					var $substatement = $('<li class="clearfix" style="padding-left:'+((substatement.LEVEL || 0) * 15 + 10)+'px"/>');

					var content = '';
					content += '<div class="usericon">';
					content += '<img src="'+app.getContextPath()+'/resource/usericon/'+icon+'">';
					content += '</div>';
					content += '<div class="substatement-items">';
					content += '<h4>'+substatement.TITLE+'<span>'+substatement.CREATE_DATE+'</span></h4>';
					if(substatement.DESCRIPTION != "")
					{
						content +='<p>'+substatement.DESCRIPTION+'</p>';
					}
					content += '</div>';
					$substatement.html(content);

					$substatement.data("substatement", substatement);
					$substatements.append($substatement);

					$substatement.on("click", function()
					{
						callback($(this).data("substatement"));
						$choice.hide();
					});
				});
			}
			else 
			{
				app.message(response.messages);
			}
		});

		var $choiceframe = $choice.find(".choice-frame");

		if($(document).scrollTop() > 0)
		{
			$choiceframe.css("left", $(window).width() / 2 - $choiceframe.width() / 2);
			$choiceframe.css("top", $(document).scrollTop() + $(window).height() / 2 - $choiceframe.height() / 2 - 30);
		}
		else
		{
			$choiceframe.css("left", $(window).width() / 2 - $choiceframe.width() / 2);
			$choiceframe.css("top", $(window).height() / 2 - $choiceframe.height() / 2 - 30);
		}

		$choice.find(".save-button").on("click", function()
		{
		});

		$choice.show();
	}

	app.toTree = function(items)
	{
		var data = null;
		if(items != null)
		{
			var map = {};
			$.each(items, function(i, item)
			{
				map[item.ID] = item;
			});

			data = items.concat();

			for(var index = 0 ; index < items.length ; index++)
			{
				for(var i = 0 ; i < items.length ; i++)
				{
					var item = items[i];
					var parentId = item.PARENT_ID;
					if(parentId != item.ID)
					{
						//如果本节点没有被移动过并且本节点存在父节点，本节点才可以移动
						if(item["ISMOVE"] == null && parentId != "")
						{
							var parent = map[parentId];
							if(parent != null)
							{
								//父节点已移动或者父节点是顶级节点 本节点才可以移动
								if(parent["ISMOVE"] != null || parent.PARENT_ID == "")
								{
									parent["ISCHILD"] = true;
									//当前节点层级为父节点层级上+1
									var level = parseInt( parent["LEVEL"] || "0" );
									item["LEVEL"] = level + 1;
									
									//父节点索引，移动至父节点后
									var target = data.indexOf( parent ) + 1;
									//当前节点索引
									var current = data.indexOf(item);

									if(current > target)
									{
										//从下往上
										data.splice(target, 0, data[current]);
										data.splice(current + 1, 1)
									}
									else
									{
										//从上往下
										data.splice(target, 0, data[current]);
										data.splice(current, 1)
									}
									item["ISMOVE"] = true;
								}
							}
							else
							{
								item["ISMOVE"] = true;
							}
						}
					}
				}
			}
		}
		return data;

	}

	app.showUserPanel = function(callback)
	{
		var $choice = $("#choice-user-panel");
		if($choice.length == 0)
		{
			var content = '';
			content += '<div class="choice-panel" id="choice-user-panel" style="display:none">';
			content += '	<div class="choice-mask"></div>';
			content += '	<div class="choice-frame">';
			content += '		<div class="choice-toolbar clearfix">';
			content += '			<h5 class="left">人员选择</h5>';
			content += '			<div class="right"><input type="text" id="user-searcher-field" placeholder="请输入搜索内容..."/><i class="fa fa-search"></i></div>';
			content += '		</div>';
			content += '		<div class="user-panel"><ul></ul></div>';
			content += '		<div class="choice-button-panel"><button class="save-button">确定</button><button class="close-button">关闭</button></div>';
			content += '	</div>';
			content += '</div>';
			$("body").append(content);
			$choice = $("#choice-user-panel");
			$choice.find(".close-button").on("click", function()
			{
				$choice.hide();
			});
		}
		
		$.getJSON(app.getContextPath()+"/system/user/user.jsp?mode=1", function(response)
		{
			if(response.status == "1")
			{
				var rows = response.resource.rows;
				
				var $users = $choice.find(".user-panel ul");
				$users.empty();
				$.each(rows, function(i, row)
				{
					var icon = row.ICON || "";
					if(icon == "")
					{
						icon = "user.png"
					}
					var $user = $('<li><i class="fa fa-check-circle selection"></i><img src="'+app.getContextPath()+'/resource/usericon/'+icon+'"><br/>'+row.NAME+'</li>');
					$user.data("user", row);
					$users.append($user);

					$user.on("click", function()
					{
						$("#choice-user-panel .user-panel ul li").attr("isselect", "0");
						$("#choice-user-panel .user-panel ul li").find(".selection").fadeOut("fast");
						
						$(this).attr("isselect", "1");
						$(this).find(".selection").fadeIn("fast");

						callback([$(this).data("user")]);
						$choice.hide();

					});

				});

			}
			else 
			{
				app.message(response.messages);
			}
		});

		var $choiceframe = $choice.find(".choice-frame");

		if($(document).scrollTop() > 0)
		{
			$choiceframe.css("left", $(window).width() / 2 - $choiceframe.width() / 2);
			$choiceframe.css("top", $(document).scrollTop() + $(window).height() / 2 - $choiceframe.height() / 2 - 30);
		}
		else
		{
			$choiceframe.css("left", $(window).width() / 2 - $choiceframe.width() / 2);
			$choiceframe.css("top", $(window).height() / 2 - $choiceframe.height() / 2 - 30);
		}

		$choice.find(".save-button").on("click", function()
		{
		});

		$choice.show();
	}


	app.showSheetPanel = function(version, sheetcodes, callback)
	{
		var $choice = $("#choice-sheet-panel");
		var height = $(window).height() - 100;
		var sheetheight = height - 100;
		if($choice.length == 0)
		{
			var content = '';
			content += '<div class="choice-panel" id="choice-sheet-panel" style="display:none">';
			content += '	<div class="choice-mask"></div>';
			content += '	<div class="choice-frame" style="height:'+height+'px">';
			content += '		<div class="choice-toolbar clearfix">';
			content += '			<h5 class="left">选择表格</h5>';
			content += '			<div class="right"><input type="text" id="sheet-searcher-field" placeholder="请输入搜索内容..."/><i class="fa fa-search"></i></div>';
			content += '		</div>';
			content += '		<div class="sheet-panel clearfix" style="height:'+sheetheight+'px"><ul class="selected-sheet-panel"></ul><ul class="unselect-sheet-panel"></ul></div>';
			content += '		<div class="choice-button-panel"><button class="save-button">确定</button><button class="close-button">关闭</button></div>';
			content += '	</div>';
			content += '</div>';
			$("body").append(content);
			$choice = $("#choice-sheet-panel");
			$choice.find(".close-button").on("click", function()
			{
				$choice.hide();
			});
		}
		var $unselectsheets = $choice.find(".unselect-sheet-panel");
		var $selectedsheets = $choice.find(".selected-sheet-panel");
		
		var isdefault = sheetcodes == null || sheetcodes.length == 0;

		$.getJSON(app.getContextPath()+"/dictionary/list/sheet.jsp?version="+version, function(response)
		{
			if(response.status == "1")
			{

				var sheets = response.resource.sheets;
				$unselectsheets.empty();
				$selectedsheets.empty();
				if(sheets != null)
				{
					$.each(sheets, function(i, sheet)
					{
						var isSelected = sheetcodes.indexOf(sheet.id) != -1;
						var $sheet = $('<li class="clearfix" />');
						$sheet.data("sheet", sheet);

						var content = '';
						content += '<div class="sheet-icon"><i class="fa fa-file-text"></i></div>';
						content += '<div class="sheet-items">';
						content += '<h4>'+sheet.name+'</h4>';
						if(sheet.description != "")
						{
							content +='<p>'+sheet.DESCRIPTION+'</p>';
						}
						content += '</div>';
						$sheet.html(content);
						if(isdefault)
						{
							if(sheet.fixed)
							{
								$selectedsheets.append($sheet);
							}
							else
							{
								$unselectsheets.append($sheet);
							}
						}
						else
						{
							if(isSelected)
							{
								$selectedsheets.append($sheet);
							}
							else
							{
								$unselectsheets.append($sheet);
							}
						}
					});
				}

				$unselectsheets.height( Math.max(Math.max($unselectsheets.height(), $selectedsheets.height()), sheetheight) );

				$(document).on("click", "#choice-sheet-panel .unselect-sheet-panel li", function()
				{
					$(this).appendTo($selectedsheets);					
					$unselectsheets.height( Math.max(Math.max($unselectsheets.height(), $selectedsheets.height()), sheetheight) );
				});
				$(document).on("click", "#choice-sheet-panel .selected-sheet-panel li", function()
				{
					$(this).appendTo($unselectsheets);
					$unselectsheets.height( Math.max(Math.max($unselectsheets.height(), $selectedsheets.height()), sheetheight) );
				});
			}
			else 
			{
				app.message(response.messages);
			}
		});


		var $choiceframe = $choice.find(".choice-frame");

		if($(document).scrollTop() > 0)
		{
			$choiceframe.css("left", $(window).width() / 2 - $choiceframe.width() / 2);
			$choiceframe.css("top", $(document).scrollTop() + $(window).height() / 2 - $choiceframe.height() / 2);
		}
		else
		{
			$choiceframe.css("left", $(window).width() / 2 - $choiceframe.width() / 2);
			$choiceframe.css("top", $(window).height() / 2 - $choiceframe.height() / 2);
		}

		$choice.find(".save-button").on("click", function()
		{
			var sheetcodes = [];
			$selectedsheets.find("li").each(function(i, $sheet)
			{
				var sheet = $($sheet).data("sheet");
				sheetcodes.push(sheet.id);
			});
			if(callback != null)
			{
				callback(sheetcodes);
			}
			$choice.hide();
		});

		$choice.show();
	}


	app.getParameter = function(m)
	{
		var sValue = location.search.match(new RegExp("[\?\&]" + m + "=([^\&]*)(\&?)", "i"));
		return sValue ? sValue[1] : sValue;
	}

	app.getContextPath = function()
	{
		var pathname = document.location.pathname;
		var index = pathname.substr(1).indexOf("/");
		var result = pathname.substr(0,index+1);
		return result;
	}

	app.tabs = function($tabs, callback)
	{
		$tabs.find("ul li").each
		(
			function(i, tab)
			{
				$(tab).on("click", function()
				{
					var $selected = $(this).parent().find("li.selected");					
					$selected.removeClass();
					var target = $selected.attr("target") || "";
					if(target != "")
					{
						$("#"+target).hide();
					}

					$(this).removeClass();
					$(this).addClass("selected");
					target = $(this).attr("target") || "";
					if(target != "")
					{
						$("#"+target).show();
					}
					
					if(callback != null)
					{
						callback($(this));
					}
					
				});
			}
		);
	}

	app.setParameter = function(url, name, value) 
	{
		var r = url;
		if (r != null && r != 'undefined' && r != "") 
		{
			value = encodeURIComponent(value);
			var reg = new RegExp("(^|)" + name + "=([^&]*)(|$)");
			var tmp = name + "=" + value;
			if (url.match(reg) != null) 
			{
				r = url.replace(eval(reg), tmp);
			}
			else 
			{
				if (url.match("[\?]")) 
				{
					r = url + "&" + tmp;
				} 
				else 
				{
					r = url + "?" + tmp;
				}
			}
		}
		return r;
	}

	app.pagination = function(total, pagesize, pagenumber, callback)
	{
		var pagecount = Math.ceil(total / pagesize) - 1;
		var $pagination = $('<ul>');

		
		var $next = null;
		if(total == 0 || pagenumber == pagecount)
		{
			$next = $('<li><a class="disabled"><i class="fa fa-angle-right"></i></a></li>');
		}
		else
		{
			$next = $('<li><a><i class="fa fa-angle-right"></i></a></li>');
			$next.on("click", function()
			{
				callback(pagenumber + 1);
			});
		}

		var $previous = null;
		if(pagenumber == 0)
		{
			$previous = $('<li><a class="disabled"><i class="fa fa-angle-left"></i></a></li>');
		}
		else
		{
			$previous = $('<li><a><i class="fa fa-angle-left"></i></a></li>');
			$previous.on("click", function()
			{
				callback(pagenumber - 1);
			});
		}

		$pagination.append($previous);
		$pagination.append($next);		
		return $pagination;		
	}

	app.createUUID = function()
	{
		var dg = new Date(1582, 10, 15, 0, 0, 0, 0);
		var dc = new Date();
		var t = dc.getTime() - dg.getTime();
		var tl = app.getIntegerBits(t, 0, 31);
		var tm = app.getIntegerBits(t, 32, 47);
		var thv = app.getIntegerBits(t, 48, 59) + '1';
		var csar = app.getIntegerBits(app.rand(4095), 0, 7);
		var csl = app.getIntegerBits(app.rand(4095), 0, 7);
		var n = app.getIntegerBits(app.rand(8191), 0 ,7) + 
		app.getIntegerBits(app.rand(8191), 8, 15) + 
		app.getIntegerBits(app.rand(8191), 0, 7) + 
		app.getIntegerBits(app.rand(8191), 8, 15) + 
		app.getIntegerBits(app.rand(8191), 0, 15);
		return tl + tm  + thv  + csar + csl + n; 
	}

	app.getIntegerBits = function(val, start, end)
	{
		var base16 = app.returnBase(val, 16);
		var quadArray = new Array();
		var quadString = '';
		var i = 0;
		for(i = 0 ; i < base16.length ; i++)
		{
			quadArray.push(base16.substring(i, i+1));    
		}
		for(i = Math.floor(start/4) ; i <= Math.floor(end/4) ; i++)
		{
			if(!quadArray[i] || quadArray[i] == '') 
				quadString += '0';
			else 
				quadString += quadArray[i];
		}
		return quadString;
	}

	app.returnBase = function(number, base)
	{
		return (number).toString(base).toUpperCase();
	}

	app.rand = function(max)
	{
		return Math.floor(Math.random() * (max + 1));
	}

})(app);