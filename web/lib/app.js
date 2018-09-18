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