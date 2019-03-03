$(function()
{
	var merge = app.getParameter("merge") || 0;

	if(merge == 0)
	{
		var $cell = $(".merge-item");
		$cell.html("　");
		$cell.removeAttr("name");
		$cell.removeClass();
	}

});

function setEditor(url)
{	
	
	var tableId = app.getParameter("table") || "";
	var statementId = app.getParameter("statement") || "";
	var substatementId = app.getParameter("substatement") || "";
	var merge = app.getParameter("merge") || 0;
	var children = app.getParameter("children") || "";

	$(".editor").on("click", function()
	{
		if($(this).find("input").length == 0)
		{
			var $row = $(this).closest("tr");
			var value = $(this).text();
			var $field = $('<input />');
			$field.val(value);
			$field.data("name", $(this).attr("name"));
			$field.data("key", $row.attr("id"));
			$field.data("source", value)
			$(this).html($field);
			$field.focus();
		}
	});

	$(window).on("mousedown.editor", function(event)
	{
		if($(event.target).closest(".editor input").size() == 0)
		{
			var $fields = $(".editor input:visible");
			if($fields.size() > 0)
			{
				$fields.each(function(i)
				{
					var $field = $(this);
					var key = $field.data("key");
					var name = $field.data("name");
					var source = $field.data("source");
					var value = $field.val();
					if(source != value)
					{
						app.showLoading();
						$.post(url, {name:name, key:key, value:value, statement:statementId, substatement:substatementId, merge:merge}, function(response)
						{
							app.hideLoading();	
							if(response.status == "1")
							{
								getResource(statementId, substatementId, merge, children)
							}
							else 
							{
								app.message(response.messages);
							}
						}, "json");
					}
					else
					{
						var $cell = $field.closest("td");
						$cell.html($field.val());
					}
				});
			}
		}	
	});

}


function setExport(name)
{
	$("#export-button").on("click", function()
	{
		var $table = $("table");
		$table.find("td, th").css("border", "thin solid #000000");
		$table.table2excel
		({
			exclude: "",
			name:name,
			filename:name + new Date().toISOString().replace(/[\-\:\.]/g, ""),
			fileext: ".xls",
			exclude_img: true,
			exclude_links: true,
			exclude_inputs: true
		});
		$table.find("td, th").css("border", "");
	});
}


function expression(statementId, substatementId, merge, children)
{
	set(statementId, substatementId, merge, children, function()
	{
		$(".expression").each(function(i, cell)
		{
			var $cell = $(cell);
			var expression = $cell.attr("expression");
			$(cell).text(eval(analyze(expression)));

		});
	});
}

function analyze(expression, map)
{

	if(expression.indexOf("[") != -1 && expression.indexOf("]") != -1)
	{

		var content = expression.substring(expression.indexOf("[")+1, expression.indexOf("]"));
		var name = content.substring(0, content.indexOf("."));
		var index = content.substring(content.indexOf(".") + 1, content.length);
		
		var value = "";
		if(map == null)
		{
			value = getByPage(name, index) || 0;
		}
		else
		{
			value = getByData(map, name, index) || 0;
		}

		expression = expression.substring(0, expression.indexOf("[")) + value + expression.substring(expression.indexOf("]") + 1, expression.length);
		expression = analyze(expression, map);
	}
	return expression;
}

function getByPage(name, index)
{
	var $cells = $("#"+name+" td");
	if($cells.length > 0)
	{
		return app.toNumber( $($cells[index]).text() );
	}
	return null;
}

function getByData(map, key, name)
{
	if(map[key] != null)
	{
		return map[key][name];
	}
	return null;
}

function set(statementId, substatementId, merge, children, callback)
{
	//试算表
	var $cell01s = $("td.T01");
	if($cell01s.length > 0)
	{
		$.getJSON("0.jsp?mode=1&statement="+statementId+"&substatement="+substatementId+"&merge="+merge+"&children="+children+"", function(response)
		{
			app.hideLoading();
			if(response.status == "1")
			{
				var map = response.resource.itemmap;

				
				$cell01s.each(function(i, cell)
				{
					var $cell = $(cell);
					var expression = $cell.attr("expression");
					$(cell).text(eval(analyze(expression, map)));
				});

				if(callback != null)
				{
					callback();
				}
			}
			else 
			{
				app.message(response.messages);
			}
		});
	}
	else
	{
		if(callback != null)
		{
			callback();
		}
	}

	//现金流量试算表
	var $cell05s = $("td.T05");
	if($cell05s.length > 0)
	{
		$.getJSON("1.jsp?mode=1&statement="+statementId+"&substatement="+substatementId+"&merge="+merge+"&children="+children+"", function(response)
		{
			app.hideLoading();
			if(response.status == "1")
			{
				var map = response.resource.itemmap;

				$cell05s.each(function(i, cell)
				{
					var $cell = $(cell);
					var expression = $cell.attr("expression");
					$(cell).text(eval(analyze(expression, map)));
				});

				if(callback != null)
				{
					callback();
				}
			}
			else 
			{
				app.message(response.messages);
			}
		});
	}
	else
	{
		if(callback != null)
		{
			callback();
		}
	}

	
	//所有者权益变动表
	var $cell06s = $("td.T06");
	if($cell06s.length > 0)
	{
		$.getJSON("5.jsp?mode=1&statement="+statementId+"&substatement="+substatementId+"&merge="+merge+"&children="+children+"", function(response)
		{
			app.hideLoading();
			if(response.status == "1")
			{
				var map = response.resource.itemmap;

				$cell06s.each(function(i, cell)
				{
					var $cell = $(cell);
					var expression = $cell.attr("expression");
					$(cell).text(eval(analyze(expression, map)));
				});

				if(callback != null)
				{
					callback();
				}
			}
			else 
			{
				app.message(response.messages);
			}
		});
	}
	else
	{
		if(callback != null)
		{
			callback();
		}
	}
}