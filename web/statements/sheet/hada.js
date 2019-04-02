$(function()
{
	var statementmode = app.getParameter("statementmode") || 0;

	if(statementmode == 0)
	{
		//去除单体不显示项
		var $cell = $(".statementmode-item");
		$cell.html("　");
		$cell.removeAttr("name");
		$cell.removeClass();
	}

});

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


function expression($substatement, statementId, substatementId, statementmode, children)
{
	$substatement.find(".expression").each(function(i, cell)
	{
		var $cell = $(cell);
		var expression = $cell.attr("expression");
		var value = app.changeMoney(eval(analyze($substatement, expression)));
		$(cell).html( (value != "" ? value : "&nbsp;") );

	});
}

function analyze($substatement, expression)
{

	if(expression.indexOf("[") != -1 && expression.indexOf("]") != -1)
	{

		var content = expression.substring(expression.indexOf("[")+1, expression.indexOf("]"));
		var name = content.substring(0, content.indexOf("."));
		var index = content.substring(content.indexOf(".") + 1, content.length);
		
		var value = getByPage($substatement, name, index) || 0;

		expression = expression.substring(0, expression.indexOf("[")) + value + expression.substring(expression.indexOf("]") + 1, expression.length);
		expression = analyze($substatement, expression);
	}
	return expression;
}

function getByPage($substatement, name, index)
{
	var $cells = $substatement.find("#"+name+" td");
	if($cells.length > 0)
	{

		var text = $($cells[index]).text();
		text = text.replace(/,/ig,"");

		return app.toNumber( text );
	}
	return null;
}
