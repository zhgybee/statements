$(function()
{

	var left = ($(window).outerWidth(true) - $("#login-container").outerWidth(true)) / 2
	var top = ($(window).outerHeight(true) - $("#login-container").outerHeight(true)) / 2
	$("#login-container").css("left", left+"px");
	$("#login-container").css("top", (top - 50)+"px");

	$("#login-panel").css("left", $("#login-container").css("left"));
	$("#login-panel").css("top", $("#login-container").css("top"));

	var cookiename = $.cookie('nest-name');
	if(cookiename != null)
	{
		$("#name").val(cookiename);
	}

	var cookiepassword = $.cookie('nest-password');
	if(cookiepassword != null)
	{
		$("#password").val(cookiepassword);
	}

	$('#login-form').ajaxForm();

	$(".textedit").keydown
	(
		function(event)
		{
			if(event.which == 13)
			{
				$("#login-button").click();
			}
		}
	);
	
	$("#name").focus();

	var cookiememorization = $.cookie('nest-memorization');
	if(cookiememorization != null)
	{
		$("#memorization i").attr("isselect", "1");
		$("#memorization i").attr("class", "fa fa-check-square");
	}
});

function login()
{
	app.showLoading();
	$('#login-form').attr("action", app.getContextPath()+"/login.do")
	$('#login-form').ajaxSubmit
	(
		function(response)
		{
			app.hideLoading();
			response = jQuery.parseJSON(response);
			if(response.status == 1)
			{
				var status = $("#memorization i").attr("isselect");
				if(status == "1")
				{
					$.cookie('nest-name', $("#name").val(), { expires: 365 });
					$.cookie('nest-password', $("#password").val(), { expires: 365 });
					$.cookie('nest-memorization', "1", { expires: 365 });
				}
				else
				{
					$.cookie('nest-name', null);
					$.cookie('nest-password', null);
					$.cookie('nest-memorization', null);
				}
				window.location.href = '../app.html'; 
			}
			else
			{
				app.message(response.messages);
			}
		}
	);
}

function memorization()
{
	var icon = $("#memorization i");
	var status = icon.attr("isselect");
	if(status == "0")
	{
		icon.attr("isselect", "1");
		icon.attr("class", "fa fa-check-square");
	}
	else
	{
		icon.attr("isselect", "0");
		icon.attr("class", "fa fa-square");
	}
}