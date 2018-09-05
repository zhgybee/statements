$(function()
{
	$("h2").remove();

	var $table = $("table");

	if($table.width() < $(window).width())
	{
		$("body").width("auto");
	}
	else
	{
		$("body").width($table.width() + 20);
	}

	$table.css("margin", "0px auto");

	var $rows = $table.find("tbody tr");
	var reportcode = app.getParameter("id");

	$.getJSON("report.json.jsp?id="+reportcode+"&bit=2", function(messages)
	{
		var code = messages.CODE;
		if(code == 0)
		{
			var items = messages.MESSAGE;
			$rows.each(function(rowcode, row)
			{
				var $cols = $(row).find("td")
				var offset  = 0;
				$cols.each(function(colcode, col)
				{
					var $col = $(col);
					
					var colcode = colcode + offset;

					$col.attr("title", "行:"+rowcode+",列:"+colcode)

					$(col).on("click", {row:rowcode, col:colcode}, function(event)
					{
						window.parent.setItem(event.data.row, event.data.col);
					});

					var colspan = $col.attr("colspan");
					if(colspan != null)
					{
						offset += parseInt(colspan) - 1;
					}
				});
			});
		}
		else
		{
		}
	});

	initialise();
});

function initialise()
{
	var $table = $("table");
	var $rows = $table.find("tbody tr");
	var reportcode = app.getParameter("id");
	$.getJSON("report.json.jsp?id="+reportcode+"&bit=2", function(messages)
	{
		var code = messages.CODE;
		if(code == 0)
		{
			var items = messages.MESSAGE;
			$rows.each(function(rowcode, row)
			{
				var $cols = $(row).find("td")
				var offset  = 0;
				$cols.each(function(colcode, col)
				{
					var $col = $(col);
					
					var colcode = colcode + offset;
					
					if(items[rowcode+"-"+colcode] == "1")
					{
						$col.css("background-color", "#f0f0f0");
					}
					else
					{
						$col.css("background-color", "transparent");
					}

					var colspan = $col.attr("colspan");
					if(colspan != null)
					{
						offset += parseInt(colspan) - 1;
					}
				});
			});
		}
		else
		{
		}
	});
}
