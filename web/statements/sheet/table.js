$(function()
{

	$.ajaxSetup 
	(
		{
			async:false
		}
	);

	var statementmode = app.getParameter("statementmode") || 0;

	if(statementmode == 0)
	{
		//去除单体不显示项
		var $cell = $(".statementmode-item");
		$cell.html("　");
		$cell.removeAttr("name");
		$cell.removeClass();
	}

	$(window).keydown(function(event)
	{
		var $self = $(event.target).closest(".editor");
		if($self.length == 1)
		{
			if(event.keyCode == 9)
			{
				var $editors = $(".editor:visible");
				var index = $editors.index($self);
				if($editors[index+1])
				{
					$editors[index+1].click();
					return false;
				}
			}
		}
	});

});

function setEditor(url)
{	
	var tableId = app.getParameter("table") || "";
	var statementId = app.getParameter("statement") || "";
	var substatementId = app.getParameter("substatement") || "";
	var statementmode = app.getParameter("statementmode") || 0;
	var children = app.getParameter("children") || "";

	$(".editor").on("click", function()
	{
		if($(this).find("input").length == 0)
		{
			var $row = $(this).closest("tr");
			var value = $(this).text();
			value = value.replace(/,/ig, "");
			value = value.replace(new RegExp(/( )/g), "");
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
				var iserror = 0;
				$fields.each(function(i)
				{
					var $field = $(this);
					var key = $field.data("key");
					var name = $field.data("name");
					var source = $field.data("source");
					var value = $field.val();
					value = value.replace(/,/ig, "");
					value = value.replace(new RegExp(/( )/g), "");
					if(source != value)
					{
						app.showLoading();
						$.post(url, {name:name, key:key, value:value, statement:statementId, substatement:substatementId, statementmode:statementmode}, function(response)
						{
							app.hideLoading();	
							if(response.status == "1")
							{
							}
							else 
							{
								iserror = true || iserror;
								app.message(response.messages);
							}
						}, "json");
					}
					else
					{
						var $cell = $field.closest("td");
						$cell.html( app.changeMoney($field.val()) );
					}
				});
				if(!iserror)
				{
					getResource(statementId, substatementId, statementmode, children);
				}
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


function expression(statementId, substatementId, statementmode, children)
{
	set(statementId, substatementId, statementmode, children, function()
	{
		$(".expression").each(function(i, cell)
		{
			var $cell = $(cell);
			var expression = $cell.attr("expression");
			$(cell).text( app.changeMoney(app.toFixed(eval(analyze(expression)))) );

		});
	});
}

function analyze(expression, map, prefix)
{

	if(expression.indexOf("[") != -1 && expression.indexOf("]") != -1)
	{
		var content = expression.substring(expression.indexOf("[")+1, expression.indexOf("]"));

		var contents = content.split(".");
		var values = null;
		if(contents.length == 3)
		{
			values = map[contents[0]];
			content = content.replace(contents[0]+".",'');
		}
		else
		{
			if(prefix)
			{
				values = map[prefix];
			}
		}

		var name = content.substring(0, content.indexOf("."));
		var index = content.substring(content.indexOf(".") + 1, content.length);
		
		var value = "";
		if(map == null)
		{
			value = getByPage(name, index) || "0";
		}
		else
		{
			value = getByData(values, name, index) || "0";
		}
		value = value.replace(/,/gi, '');
		value = app.toNumber( value );

		expression = expression.substring(0, expression.indexOf("[")) + value + expression.substring(expression.indexOf("]") + 1, expression.length);
		expression = analyze(expression, map, prefix);
	}
	return expression;
}

function getByPage(name, index)
{
	var $cells = $("#"+name+" td");
	if($cells.length > 0)
	{
		return $($cells[index]).text();
	}
	return null;
}

function getByData(map, key, name)
{
	if(map[key] != null)
	{
		return map[key][name] + "";
	}
	return null;
}

function set(statementId, substatementId, statementmode, children, callback)
{
	//试算表、利润表、现金流量试算表、所有者权益变动表
	var $cells = $("td.T01, td.T03, td.T05, td.T06");
	if($cells.length > 0)
	{
		$.getJSON("quote.jsp?statement="+statementId+"&substatement="+substatementId+"&statementmode="+statementmode+"&children="+children+"", function(response)
		{
			app.hideLoading();
			if(response.status == "1")
			{
				var map = response.resource.resources;
				
				$cells.each(function(i, cell)
				{
					var $cell = $(cell);
					var expression = $cell.attr("expression");
					var classnames = $cell.attr("class").split(" ");
					$(cell).text( app.changeMoney( app.toFixed(eval(analyze(expression, map, classnames[0]))) ) );
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