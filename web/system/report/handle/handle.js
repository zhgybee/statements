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
});