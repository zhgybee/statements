(
	function($)
	{
		$.fn.calendars = function(format, type)
		{
			return this.each
			(
				function()
				{
					if(type == "1")
					{
						$(this).off("focusout").on("focusout", function()
						{
							var value = $(this).val();
							if(value != "")
							{
								if(value.length == 8)
								{
									value = value.substring(0, 4) +"-"+ value.substring(4, 6) +"-"+ value.substring(6, 8);
								}

								if(!checkDate(value))
								{
									alert("您所输入的日期【"+value+"】格式不正确！\r\n请输入【年(4位数字)-月(2位数字)-日(2位数字)】格式");
									$(this).css("color", "red");
								}
								else
								{
									$(this).css("color", "#333333");
								}
								$(this).val(value)
							}
						});
					}
					else
					{
						if($("#calendar-panel").size() == 0)
						{
							$("body").append('<div id="calendar-panel" style="position:absolute; display:none;"></div>');
						}
						$(this).off("click").on
						(
							"click", 
							function()
							{ 
								var position = $(this).offset();

								var panel = $("#calendar-panel");

								var fieldName = $(this).attr("name");

								var index = $("[name='"+fieldName+"']").index($(this));

								panel.html( display(format, fieldName, index) );

								panel.css("left", position.left);

								var pageHeight = $(document).height();
								var panelHeight = panel.height();

								if(position.top + panelHeight > pageHeight)
								{				
									if(position.top < panelHeight)
									{
										//bottom
										panel.css("top", position.top + $(this).height() + 3);
									}
									else
									{
										//top
										panel.css("top", position.top - panelHeight - 1);
									}
								}
								else
								{
									//bottom
									panel.css("top", position.top + $(this).height() + 3);
								}

								panel.show();
								
								$(document).mousedown
								(
									function(e)
									{
										if($(e.target).closest("#calendar-panel").size() == 0)
										{
											panel.hide();
										}
									}
								);
							}   
						);
					}
				}
			);
		}
	}
)(jQuery);

function checkDate(date) 
{
	var result = date.match(/^(\d{1,4})(-|\/)(\d{1,2})\2(\d{1,2})$/);
	if (result == null)
		return false;
	var d = new Date(result[1], result[3] - 1, result[4]);
	return (d.getFullYear() == result[1] && (d.getMonth() + 1) == result[3] && d.getDate() == result[4]);
}


function display(dateFormat, control, index)
{
	var date = new Date();

	var year = date.getFullYear();
	var month = date.getMonth();
	var day = date.getDate();
	var hour = date.getHours();
	var minute = date.getMinutes();
	
	var name = "nest";

	var result = '';
    result += '<div style="background:#EEEEEE; border:1px solid #333333; padding:3px;" id="calendar_container">';
    result += '	<table class="table_container">';
	result += '	<tr><td>';
	result += '	<fieldset class="c_fieldset"><legend class="c_legend">日期(D)</legend>';
	result += '		<table class="table_container">';
	result += '		<tr>';
	result += '		<td style="padding-bottom:4px;">';
	result += '			<table class="table_container">';
	result += '			<tr>';
	result += '			<td>';
	result += '			<input class="c_year" maxlength="4" value="'+year+'" id="'+name+'_year" onkeyup="refresh(\''+name+'\')">';
	result += '			<input type="hidden" maxlength="4" value="'+day+'" id="'+name+'_day">';
	result += '			</td>';
	result += '			<td style="vertical-align:top">';

	result += '			<div class="button_container">';
	result += '				<button type="button" class="up-button" onclick="adjustmentYear(\''+name+'\', \'up\')"></button>';
	result += '			</div>';
	result += '			<div class="button_container">';
	result += '				<button type="button" class="down-button" onclick="adjustmentYear(\''+name+'\', \'down\')"></button>';
	result += '			</div>';

	result += '			</td>';
	result += '			</tr>';
	result += '			</table>';
	result += '		</td>';
	result += '		<td style="padding-bottom:4px;">';
	result += '			<table class="table_container">';
	result += '			<tr>';
	result += '			<td>';
	result += '				<input class="c_month" radix="13" maxlength="2" value="'+(format(month+1))+'" id="'+name+'_month" onkeyup="refresh(\''+name+'\')">';
	result += '			</td>';
	result += '			<td style="vertical-align:top">';

	result += '			<div class="button_container">';
	result += '				<button type="button" class="up-button" onclick="adjustmentMonth(\''+name+'\', \'up\')"></button>';
	result += '			</div>';
	result += '			<div class="button_container">';
	result += '				<button type="button" class="down-button" onclick="adjustmentMonth(\''+name+'\', \'down\')"></button>';
	result += '			</div>';

	result += '			</td>';
	result += '			</tr>';
	result += '			</table>';
	result += '		</td>';
	result += '		</tr>';
	result += '		<tr>';
	result += '		<td colspan="2">';
	result += '			<div class="c_frameborder">';
	result += '				<div>';
	result += '				<table class="c_dateHead" cellspacing="0" cellpadding="0">';
	result += '				<tr>';
	result += '				<td>日</td><td>一</td><td>二</td><td>三</td><td>四</td><td>五</td><td>六</td>';
	result += '				</tr>';
	result += '				</table>';
	result += '				</div>';
	result += '				<div>';
	result += createDate(name, year, month, day);
	result += '				</div>';
	result += '			</div>';
	result += '		</td>';
	result += '		</tr>';
	result += '		</table>';
	result += '	</fieldset>';
	result += '	</td></tr>';
	result += '	<tr><td>';
	result += '	<fieldset class="m_fieldset"><legend class="m_legend">时间(T)</legend>';

	result += '			<table class="table_container">';
	result += '			<tr>';
	result += '			<td>';
	result += '				<input class="m_input" maxlength="2" id="'+name+'_hour" style="width:45px" value="'+format(hour)+'">';
	result += '			</td>';
	result += '			<td style="width:26px; vertical-align:top">';
	result += '			<div class="button_container">';
	result += '				<button type="button" class="up-button" onclick="adjustmentTime(\''+name+'_hour\', \'up\', 23, 0)"></button>';
	result += '			</div>';
	result += '			<div class="button_container">';
	result += '				<button type="button" class="down-button" onclick="adjustmentTime(\''+name+'_hour\', \'down\', 23, 0)"></button>';
	result += '			</div>';

	result += '			</td>';
	result += '			<td style="width:7px"></td>';
	result += '			<td>';
	result += '				<input class="m_input" maxlength="2" id="'+name+'_minute" style="width:30px" value="'+format(minute)+'">';
	result += '			</td>';
	result += '			<td  style="vertical-align:top">';
	result += '			<div class="button_container">';
	result += '				<button type="button" class="up-button" onclick="adjustmentTime(\''+name+'_minute\', \'up\', 59, 0)"></button>';
	result += '			</div>';
	result += '			<div class="button_container">';
	result += '				<button type="button" class="down-button" onclick="adjustmentTime(\''+name+'_minute\', \'down\', 59, 0)"></button>';
	result += '			</div>';
	result += '			</td>';
	result += '			</tr>';
	result += '			</table>';

	result += '	</fieldset>';
	result += '	</td></tr>';
	result += '	<tr>';
	result += '	<td colspan="2">';
	result += '	<input type="button" onclick="today(\''+dateFormat+'\', \''+control+'\', '+index+')" class="button-style" value="今天"/>';
	result += '	<input type="button" onclick="enter(\''+name+'\', \''+dateFormat+'\', \''+control+'\', '+index+')" class="button-style" value="确定"/>';
	result += '	<input type="button" onclick="empty(\''+control+'\', '+index+')" class="button-style" value="清空"/>';
	result += '	</td>';
	result += '	</tr>';
	result += '	</table>';
    result += '</div>';

   return result;
}


function format(str)
{
	str = "0" + str;
	return str.substr(str.length - 2);
}

function adjustmentTime(name, flag, max, min)
{
	var obj = $('#'+name);
	var value = obj.attr("value");

	if(flag == "up")
	{
		value++;
	}
	else
	{
		value--;
	}
	if(value <= max && value >= min)
	{
		obj.attr("value", format(value));
		refresh(name);
	}
}

function adjustmentYear(name, flag)
{
	var obj = $('#'+name+'_year');
	var value = obj.attr("value");
	if(flag == "up")
	{
		value++;
	}
	else
	{
		value--;
	}
	obj.attr("value", value);
	refresh(name);
}

function adjustmentMonth(name, flag)
{
	var obj = $('#'+name+'_month');
	var value = obj.attr("value");

	if(flag == "up")
	{
		value++;
	}
	else
	{
		value--;
	}
	if(value < 13 && value > 0)
	{
		obj.attr("value", format(value));
		refresh(name);
	}
}

function selectDate(name, obj)
{
	var dayObj = $('#'+name+'_day');
	dayObj.attr("value", $(obj).text());

	
	$('#'+name+'Container span').removeClass("selected");
	$(obj).addClass("selected");
}

function createDate(name, year, month, day)
{

	var result = "";
	var fDay = new Date(year, month, 1).getDay();
	var fDate = 1 - fDay;
	var lDate = new Date(year, month + 1, 0).getDate();
	result += '<table id="'+name+'Container" class="table_container date_table_container">';
	for (var i = 1, j = fDate; i < 7; i++)
	{
		result += '<tr>';
		for (var k = 0 ; k < 7 ; k++)
		{
			result += '<td><span '+(j == day ? 'class="selected"' : '')+' onclick="selectDate(\''+name+'\', this)">'+isDate(j++, lDate)+'</span></td>';
		}
		result += '</tr>';
	}
	result += '</table>';
	return result;
}

function isDate(n, max)
{
	return (n >= 1 && n <= max) ? n : "";
}

function refresh(name)
{
	var yearObj = $('#'+name+'_year');
	var monthObj = $('#'+name+'_month');
	var dayObj = $('#'+name+'_day');

	var container = $('#'+name+'Container');
	month = monthObj.attr("value") - 1;

	var content = createDate(name, yearObj.attr("value"), month, dayObj.attr("value"));

	container.parent().html(content);
}

Date.prototype.format = function(format) 
{    
	var o = 
	{    
		"M+": this.getMonth()+1, 
		"d+": this.getDate(),  
		"h+": this.getHours(),  
		"m+": this.getMinutes(),  
		"s+": this.getSeconds(),  
		"q+": Math.floor((this.getMonth()+3)/3),    
		"S": this.getMilliseconds()    
	}    
	if(/(y+)/.test(format)) 
	{
		format=format.replace(RegExp.$1, (this.getFullYear()+"").substr(4 - RegExp.$1.length));    
	}
	for(var k in o)
	{
		if(new RegExp("("+ k +")").test(format)) 
		{
			format = format.replace(RegExp.$1, RegExp.$1.length==1 ? o[k] : ("00"+ o[k]).substr((""+ o[k]).length));
		}
	}
  return format;    
}

function enter(name, format, control, index)
{
	var yearObj = $('#'+name+'_year');
	var monthObj = $('#'+name+'_month');
	var dayObj = $('#'+name+'_day');
	var hourObj = $('#'+name+'_hour');
	var minuteObj = $('#'+name+'_minute');

	var result = new Date(yearObj.val(), monthObj.val()-1, dayObj.val(), hourObj.val(), minuteObj.val());

	var controlObj = $( $("[name='"+control+"']").get(index) );
	controlObj.val(result.format(format));
	closethis(control);
}

function today(format, control, index)
{
	var result = new Date();
	var controlObj = $( $("[name='"+control+"']").get(index) );
	controlObj.val(result.format(format));
	closethis(control);

}

function empty(control, index)
{
	var controlObj = $( $("[name='"+control+"']").get(index) );
	controlObj.val("");
	closethis(control);

}
function closethis(control)
{
	$("#calendar-panel").hide();

	try
	{
		//当选择日期后出发回调函数
		calendarPanelHide(control);
	}
	catch (e)
	{
	}
}

