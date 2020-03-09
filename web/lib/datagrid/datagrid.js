
(
	function($)
	{
		var builder = function($container)
		{
			var options = $container.data("options");
			var frozenheader = options.frozenheader;
			var activeheader = options.activeheader;
			var dynamicheader = options.dynamicheader;
			
			var result = "";
			if(frozenheader != null)
			{
				var frozencontent = '';
				frozencontent = '<div class="datagrid-frozen-header-container">';
				frozencontent += '<table>';
				frozencontent += '<tbody>';


				for(var i = 0 ; i < frozenheader.length ; i++)
				{
					var row = frozenheader[i];

					frozencontent += '<tr>';
					for(var j = 0 ; j < row.length ; j++)
					{
						var column = row[j];
						var title = column.title || "";
						var type = column.type;
						var colspan = column.colspan;
						var rowspan = column.rowspan;
						var width = column.width;
						var height = column.height;

						frozencontent += '<td '+(colspan != null ? 'colspan="'+colspan+'"' : '')+' '+(rowspan != null ? 'rowspan="'+rowspan+'"' : '')+'>';
						frozencontent += '<div style="'+getSize(width, height) + getStyle(column.style)+'">'+title+'</div>';
						frozencontent += '</td>';
					}

					frozencontent += '</tr>';
				}



				frozencontent += '</tbody>';
				frozencontent += '</table>';
				frozencontent += '</div>';

				result += frozencontent;
			}
			if(activeheader != null)
			{
				var activecontent = '';
				activecontent += '<div class="datagrid-header-container">';
				activecontent += '<div class="inner">';
				activecontent += '<table>';
				activecontent += '<tbody>';

				for(var i = 0 ; i < activeheader.length ; i++)
				{
					var row = activeheader[i];
					activecontent += '<tr>';
					for(var j = 0 ; j < row.length ; j++)
					{
						var column = row[j];
						var title = column.title || "";
						var type = column.type;
						var colspan = column.colspan;
						var rowspan = column.rowspan;						
						var width = column.width;
						var height = column.height;
						var meaning = column.meaning || "";

						if(colspan == 'auto')
						{
							var target = column.target;
							var dynamiccolumns = dynamicheader[target];
							if(dynamiccolumns.length == 0)
							{
								colspan = null;
							}
							else
							{
								colspan = dynamiccolumns.length;
								width = dynamiccolumns.length * width;
							}
						}

						if(meaning == "jsonobject")
						{
							var target = column.target;
							var dynamiccolumns = dynamicheader[target];
							if(dynamiccolumns.length != 0)
							{
								for(var l = 0 ; l < dynamiccolumns.length ; l++)
								{
									activecontent += '<td '+(colspan != null ? 'colspan="'+colspan+'"' : '')+' '+(rowspan != null ? 'rowspan="'+rowspan+'"' : '')+'>';
									activecontent += '<div style="'+getSize(width, height) + getStyle(column.style)+'">'+dynamiccolumns[l]+'</div>';
									activecontent += '</td>';
								}
							}
							else
							{
								activecontent += '<td>';
								activecontent += '<div style="'+getSize(width, height) + getStyle(column.style)+'"></div>';
								activecontent += '</td>';
							}
						}
						else
						{
							activecontent += '<td '+(colspan != null ? 'colspan="'+colspan+'"' : '')+' '+(rowspan != null ? 'rowspan="'+rowspan+'"' : '')+'>';
							activecontent += '<div style="'+getSize(width, height) + getStyle(column.style)+'">'+title+'</div>';
							activecontent += '</td>';
						}
					}
					activecontent += '</tr>';
				}


				activecontent += '</tbody>';
				activecontent += '</table>';
				activecontent += '</div>';
				activecontent += '</div>';

				result += activecontent;
			}
			result += '<div style="clear:both"></div>';
			result += '<div class="datagrid-frozen-body-container"><div class="inner"><table><tbody></tbody></table></div></div>';
			result += '<div class="datagrid-body-container"><table><tbody></tbody></table></div>';
			result += '<div class="resizable-line"></div>';
			$container.html(result);
		}


		var flush = function($container)
		{
			var options = $container.data("options");
			var frozencolumns = options.frozencolumns;
			var activecolumns = options.activecolumns;

			app.showLoading();
			$.post(options.datasource.url, options.datasource.args, function(response)
			{
				app.hideLoading();
				if(response.status == "1")
				{
					var dataset = response.resource.dataset;

					var $frozenbody = $container.find(".datagrid-frozen-body-container tbody");
					var $activebody = $container.find(".datagrid-body-container tbody");

					$frozenbody.empty();
					$activebody.empty();	
					if(dataset != null)
					{
						var groupindex = {index:1, value:1};
						for(var i = 0 ; i < dataset.length ; i++)
						{
							var row = dataset[i];
							var $frozenrow = null;
							var $activerow = null;

							if(frozencolumns != null)
							{
								$frozenrow = createTableRow($container, i, groupindex, frozencolumns, row);
								$frozenbody.append($frozenrow);
							}

							if(activecolumns != null)
							{
								$activerow = createTableRow($container, i, groupindex, activecolumns, row);
								$activebody.append($activerow);
							}

							$frozenrow.data("contact", $activerow);
							$activerow.data("contact", $frozenrow);

							$frozenrow.on("mouseout", mouseoutRow);
							$frozenrow.on("mouseover", mouseoverRow);
							$activerow.on("mouseout", mouseoutRow);
							$activerow.on("mouseover", mouseoverRow);
						}
					}

					var groups = options.groups;
					if(groups != null && groups.length > 0)
					{
						$.each(groups, function(i, group)
						{
							var type = group["type"] || "footer";
							var rule = group["rule"];
							var style = group["style"];
							var rulecolumn = rule["column"];
							var rulevalue = rule["value"];
							var ruleexcludes = rule["exclude"];

							
							var $grouprows = $("div."+rulecolumn+":contains('"+rulevalue+"')");
							if(rulevalue == "*")
							{
								$grouprows = $("div."+rulecolumn+"");
							}
							if(ruleexcludes != null)
							{
								$.each(ruleexcludes, function(j, ruleexclude)
								{
									$grouprows = $grouprows.not(":contains('"+ruleexclude+"')");
								});
							}
							$grouprows = $grouprows.closest('tr');


							if($grouprows.length > 0)
							{
								var $pointrow = $grouprows.last();
								if(type == "header")
								{
									$pointrow = $grouprows.first();
								}
								var $frozenrows = $container.find(".datagrid-frozen-body-container tbody tr:not('.group-item')");
								var $rows = $container.find(".datagrid-body-container tbody tr:not('.group-item')");
								var index = Math.max($frozenrows.index($pointrow), $rows.index($pointrow)); 

								if(index >= 0)
								{
									
									var content = "";
									content += '<tr class="group-item" style="'+getStyle(style)+'">';
									if(frozencolumns != null)
									{
										for(var j = 0 ; j < frozencolumns.length ; j++)
										{
											var column = frozencolumns[j];
											content += groupcell($container, column, $grouprows, group);
										}
									}
									content += '</tr>';
									if(type == "footer")
									{
										$($frozenrows.get(index)).after(content);
									}
									else
									{
										$($frozenrows.get(index)).before(content);
									}
									
									
									content = "";
									content += '<tr class="group-item" style="'+getStyle(style)+'">';
									if(activecolumns != null)
									{
										for(var j = 0 ; j < activecolumns.length ; j++)
										{
											var column = activecolumns[j];
											content += groupcell($container, column, $grouprows, group);
										}
									}
									content += '</tr>';
		
									if(type == "footer")
									{
										$($rows.get(index)).after(content);
									}
									else
									{
										$($rows.get(index)).before(content);
									}

									

								}

							}
							
						});

					}

					$container.find(".copy-button").on("click", function(event)
					{
						var id = $(this).closest("tr").data("row").ID;
						copy($container, [id]);
						event.stopPropagation();
					});

					$container.find(".delete-button").on("click", function(event)
					{
						var id = $(this).closest("tr").data("row").ID;
						del($container, [id]);
						event.stopPropagation();
					});

					setHeight($container);
				}
				else 
				{
					app.message(response.messages);
				}
			}, "json")
		}

		var createTableRow = function($container, index, groupindex, columns, row)
		{
			var structureutils = new DataStructureUtils();
			var $row = $("<tr/>");
			for(var i = 0 ; i < columns.length ; i++)
			{
				var column = columns[i];
				var name = column.name || "";
				var value = row[name];
				var type = column.type;
				var width = column.width;
				var height = column.height;
				var meaning = column.meaning || "";


				if(meaning == "jsonobject")
				{
					var options = $container.data("options");	
					var dynamicheader = options.dynamicheader;

					var target = column.name;
					var dynamiccolumns = dynamicheader[target];

					value = $.parseJSON(value);
					for(var l = 0 ; l < dynamiccolumns.length ; l++)
					{
						var description = toValue(column, value[dynamiccolumns[l]]);
						if(column.dictionary != null && column.dictionary != "")
						{
							description = structureutils.getDictionary(app.getContextPath()+"/"+column.dictionary.map, description, true);
						}

						var $cell = $('<td/>');
						$cell.append('<div class="'+name+'_'+l+'" style="'+getSize(width, height) + getStyle(column.style)+'">'+((description == null || description == "") ? "&nbsp;" : description)+'</div>');
						$cell.css("cursor", "not-allowed");
						$row.append($cell);
						//json单元格的修改未完成
					}
				}
				else
				{
					value = toValue(column, value);
					var description = value;
					if(column.dictionary != null && column.dictionary != "")
					{
						description = structureutils.getDictionary(app.getContextPath()+"/"+column.dictionary.map, description, true);
					}

					var $cell = $('<td/>');
					if(type == "index")
					{
						$cell.append('<div class="'+name+'" style="'+getSize(width, height) + getStyle(column.style)+'">'+(index + 1)+'</div>');
						$cell.on("click", clickrow);
					}
					else if(type == "group")
					{
						var keys = column['target'];
						var isafresh = true;
						$.each(keys, function(i, key)
						{
							if((row[key] || '') != '')
							{
								isafresh = false;
							}
						});
						if(isafresh)
						{
							groupindex['value'] = '';
						}
						else
						{
							if(groupindex['value'] == '')
							{
								groupindex['index'] = groupindex['index'] + 1;
								groupindex['value'] = groupindex['index'];
							}
						}

						$cell.append('<div class="'+name+'" style="'+getSize(width, height) + getStyle(column.style)+'">'+groupindex['value']+'</div>');
					}
					else if(type == "button")
					{
						if(column.buttons != null)
						{
							$cell.append('<div class="'+name+'" style="'+getSize(width, height) + getStyle(column.style)+'">'+createButton(column.buttons)+'</div>');
						}
					}
					else
					{
						$cell.append('<div class="'+name+'" style="'+getSize(width, height) + getStyle(column.style)+'">'+((description == null || description == "") ? "&nbsp;" : description)+'</div>');
						if(column.editor != null)
						{
							$cell.on("click", {column:column, key:row.ID, value:value, description:description}, onEditor);
							$cell.css("cursor", "text");
						}
						else
						{
							$cell.css("cursor", "not-allowed");
						}
					}
					$row.append($cell);
				}

			}
			$row.data("row", row);

			return $row;
		}


		var toValue = function(column, value)
		{
			var modes = column.modes;
			if(modes != null)
			{
				if(modes.indexOf("percent") != -1)
				{
					value = app.toFixed((app.toNumber(value) * 100), 2) + "%";
				}
				else if(modes.indexOf("money") != -1)
				{
					value = app.changeMoney(value);
				}
			}
			return value;
		}
		var fromValue = function(column, value)
		{
			var modes = column.modes;
			if(modes != null)
			{
				if(modes.indexOf("percent") != -1)
				{
					value = value.replace("%","");
					value = app.toFixed(app.toNumber(value) / 100, 2);
				}
				else if(modes.indexOf("money") != -1)
				{
					value = value.replace(/,/ig,"");
				}
			}
			return value;
		}

		var copy = function($container, ids)
		{
			var options = $container.data("options");
			var tableId = options.table;
			app.showLoading();
			$.getJSON(options.editor.copy, {ids:ids.join(","), table:tableId}, function(response)
			{
				app.hideLoading();
				if(response.status == "1")
				{
					flush( $container );
				}
				else 
				{
					app.message(response.messages);
				}
			});
		}

		var del = function($container, ids)
		{
			var options = $container.data("options");
			var tableId = options.table;
			app.showLoading();
			$.getJSON(options.editor.del, {ids:ids.join(","), table:tableId}, function(response)
			{
				app.hideLoading();
				if(response.status == "1")
				{
					flush( $container );
				}
				else 
				{
					app.message(response.messages);
				}
			});
		}


		var groupcell = function($container, column, $grouprows, grouprule)
		{
			var cell = "";
			var meaning = column.meaning || "";
			var width = column.width;
			var height = column.height;

			var sumcolumns = grouprule["sum"];
			if(sumcolumns != null)
			{
				if(sumcolumns.indexOf(column.name) != -1)
				{
					if(meaning == "jsonobject")
					{
						var options = $container.data("options");	
						var dynamicheader = options.dynamicheader;

						var target = column.name;
						var dynamiccolumns = dynamicheader[target];

						for(var l = 0 ; l < dynamiccolumns.length ; l++)
						{
							cell += '<td><div style="'+getSize(width, height) + getStyle(column.style)+'">'+sum($grouprows, column, dynamiccolumns[l])+'</div></td>';
						}
					}
					else
					{
						cell += '<td><div style="'+getSize(width, height) + getStyle(column.style)+'">'+sum($grouprows, column)+'</div></td>';
					}
				}
			}

			var avgolumns = grouprule["avg"];
			if(avgolumns != null)
			{
				if(avgolumns.indexOf(column.name) != -1)
				{
					if(meaning == "jsonobject")
					{
						var options = $container.data("options");	
						var dynamicheader = options.dynamicheader;

						var target = column.name;
						var dynamiccolumns = dynamicheader[target];

						for(var l = 0 ; l < dynamiccolumns.length ; l++)
						{
							cell += '<td><div style="'+getSize(width, height) + getStyle(column.style)+'">'+avg($grouprows, column, dynamiccolumns[l])+'</div></td>';
						}
					}
					else
					{
						cell += '<td><div style="'+getSize(width, height) + getStyle(column.style)+'">'+avg($grouprows, column)+'</div></td>';
					}
				}
			}

			var titlecolumns = grouprule["title"];
			if(titlecolumns != null)
			{
				$.each(titlecolumns, function(i, titlecolumn)
				{
					if(titlecolumn["column"] == column.name)
					{
						cell += '<td><div style="'+getSize(width, height) + getStyle(column.style)+'">'+titlecolumn["text"]+'</div></td>';
					}
				});
			}
			
			if(cell == "")
			{
				if(meaning == "jsonobject")
				{
					var options = $container.data("options");	
					var dynamicheader = options.dynamicheader;

					var target = column.name;
					var dynamiccolumns = dynamicheader[target];

					for(var l = 0 ; l < dynamiccolumns.length ; l++)
					{
						cell += '<td></td>';
					}
				}
				else
				{
					cell += '<td></td>';
				}
			}

			return cell;
		}

		var sum = function($grouprows, column, key)
		{
			var number = 0
			var columnname = column.name;
			$.each($grouprows, function(i, grouprow)
			{
				var row = $(grouprow).data("row");
				if(key == null)
				{
					number += app.toNumber(row[columnname]);
				}
				else
				{
					var value = $.parseJSON(row[columnname]);
					number += app.toNumber( value[key] );
				}
			});
			number = app.toNonExponential(number);
			number = toValue(column, number);
			return number;
		}

		var avg = function($grouprows, column, key)
		{
			var number = 0
			var columnname = column.name;
			$.each($grouprows, function(i, grouprow)
			{
				var row = $(grouprow).data("row");
				if(key == null)
				{
					number += app.toNumber(row[columnname]);
				}
				else
				{
					var value = $.parseJSON(row[columnname]);
					number += app.toNumber( value[key] );
				}
			});
			number = number / $grouprows.length;
			number = toValue(column, number);
			return number;
		}


		var clickrow = function(event)
		{
			selected($(this).closest("tr"));
		}

		var selected = function($tr)
		{
			if(!isSelected($tr))
			{
				$tr.attr("isselect", "1");
				$tr.css("background-color", "#fff4e3");

				$tr.data("contact").attr("isselect", "1");
				$tr.data("contact").css("background-color", "#fff4e3");
			}
			else
			{
				$tr.attr("isselect", "0");
				if($tr.data("background-color") != null)
				{
					$tr.css("background-color", $tr.data("background-color"));
				}
				else
				{
					$tr.css("background-color", "#ffffff");
				}

				$tr.data("contact").attr("isselect", "0");
				if($tr.data("contact").data("background-color") != null)
				{
					$tr.data("contact").css("background-color", $tr.data("contact").data("background-color"));
				}
				else
				{
					$tr.data("contact").css("background-color", "#ffffff");
				}
			}
		}

		var isSelected = function($tr)
		{
			if($tr.size() > 0)
			{
				var isselect = $tr.attr("isselect");
				if(isselect == null || isselect == "0")
				{
					return false;
				}
				else
				{
					return true;
				}
			}
			return false;
		}

		var changeDictionary = function(column, value, $container)
		{
			if(value == "")
			{
				value = "nullcharacter";
			}
			var result = "";
			var dictionary = $container.data("dictionaries")[column.dictionary]
			if(dictionary != null)
			{
				result = dictionary[value];
			}
			return result == null ? "" : result
		}

		var createButton = function(buttons)
		{
			var result = "";
			for(var i = 0 ; i < buttons.length ; i++)
			{
				if(buttons[i] == "copy")
				{
					result += '<span class="control-button copy-button" style="background-color:#4ab6ef">复制</span>';
				}
				else if(buttons[i] == "delete")
				{
					result += '<span class="control-button delete-button" style="background-color:#cd5050">删除</span>';
				}
			}
			return result;
		}

		var getStyle = function(items)
		{
			var style = [];
			if(items != null)
			{
				for(var item in items)
				{
					style.push(item+":"+items[item]);
				}
			}
			return style.join("; ")
		}

		var getSize = function(width, height)
		{
			var style = "";
			if(width != null)
			{
				style += 'width:'+width+'px;'
			}
			if(height != null)
			{
				style += 'height:'+height+'px;'
			}
			return style;
		}

		var mouseoutRow = function(event)
		{
			if( !isSelected($(this)) )
			{
				setMouseoutStatus($(this));
			}
		}

		var mouseoverRow = function(event)
		{
			if( !isSelected($(this)) )
			{
				setMouseoverStatus($(this));
			}
		}

		var setMouseoverStatus = function($tr)
		{
			$tr.css("background-color", "#e4efff");
			$tr.data("contact").css("background-color", "#e4efff");
		}

		var setMouseoutStatus = function($tr)
		{
			if($tr.data("background-color") != null)
			{
				$tr.css("background-color", $tr.data("background-color"));
			}
			else
			{
				$tr.css("background-color", "#ffffff");
			}

			if($tr.data("contact").data("background-color") != null)
			{
				$tr.data("contact").css("background-color", $tr.data("contact").data("background-color"));
			}
			else
			{
				$tr.data("contact").css("background-color", "#ffffff");
			}
		}

		var resize = function($container)
		{
			var width = $container.width() - $container.find(".datagrid-frozen-header-container").outerWidth(true);
			$container.find(".datagrid-header-container").width(width);
			$container.find(".datagrid-body-container").width(width);
		

			var height = $container.height() - $container.find(".datagrid-frozen-header-container").outerHeight();
			$container.find(".datagrid-body-container").height(height);
			$container.find(".datagrid-frozen-body-container").height(height);
		}

		var setHeight = function($container)
		{
			$.each($container.find(".datagrid-frozen-body-container tr"), function()
			{
				var $contact = $(this).data("contact");
				if($contact != null)
				{
					var height = Math.max($(this).height(), $contact.height());
					var height = Math.max(height, 30);
					$(this).height(height);
					$contact.height(height);
				}
			});
		}


		var onEditor = function(event)
		{
			var column = event.data.column;
			var key = event.data.key;
			var value = fromValue(column, event.data.value);
			var description = fromValue(column, event.data.description);
			var $editor = $(this).find("div");

			if(value == description)
			{
				column.editor.value = value;
			}
			else
			{
				column.editor.value = {value:value, description:description};
			}



			var structureutils = new DataStructureUtils();
			$editor.html( structureutils.getFields({column:column}) );

			var $field = $editor.find(".field:visible");

			$field.data("key", key);
			$field.data("value", value);
			$field.data("description", description);
			$field.data("column", column);

			$field.height($editor.closest("td").height() - 1);

			$field.on("click", function(event){event.stopPropagation()});
			$field.on("dblclick", function(event){event.stopPropagation()});

			if( $field.is(".select-field") )
			{
				$field.click();
				$field.focus();
			}
			else
			{
				$field.focus();
			}

			event.stopPropagation();
		}
		var initialize = function($container)
		{
			var options = $container.data("options");
			var tableId = options.table;

			//构建表格
			builder($container)
			
			//读取数据并填充表格
			flush( $container );


			$(window).off("mousedown.editor").on("mousedown.editor", {"container":$container}, function(event)
			{
				if($(event.target).closest(".field").size() == 0)
				{
					var $fields = $container.find(".field:visible");
					if($fields.size() > 0)
					{
						$fields.each(function(i)
						{
							var $field = $(this);
							var $cell = $field.closest("div");
							var key = $field.data("key");
							var source = $field.data("value");
							var description = $field.data("description");
							var column = $field.data("column");
							if(column != null)
							{
								var value = $field.val();
								var $joint = $field.data("joint");
								if($joint != null)
								{
									value = $joint.val();
								}
								
								if(source != value)
								{
									app.showLoading();
									$.post(options.editor.update, {column:JSON.stringify(column), key:key, value:value, table:tableId}, function(response)
									{
										app.hideLoading();				
										if(response.status == "1")
										{
											flush( $container );
										}
										else 
										{
											app.message(response.messages);
										}
									}, "json");
								}
								else
								{
									if(column['editor']['type'] == "choice")
									{
										$cell.html(description);
									}
									else
									{
										
										var modes = column.modes;
										if(modes != null)
										{
											if(modes.indexOf("percent") != -1)
											{
												value = app.toFixed((app.toNumber(value) * 100), 2) + "%";
											}
											else if(modes.indexOf("money") != -1)
											{
												value = app.changeMoney(value);
											}
										}
										$cell.html(value);
									}
								}

							}
						});
					}
				}
			});

			$container.find(".datagrid-body-container").scroll
			( 
				function() 
				{
					$container.find(".datagrid-frozen-body-container").scrollTop( $(this).scrollTop() ); 
					$container.find(".datagrid-header-container").scrollLeft( $(this).scrollLeft() ); 
				} 
			);

			$(window).resize( function(){resize($container)} ); 
			resize($container);


		}


		$.fn.datagrid = function(p1, p2)
		{
			if(typeof p1 == "string")
			{
				var fun = methods[p1];
				if(fun != null)
				{
					return fun($(this), p2);
				}
			}
			else
			{
				var defaults = 
				{
					datasource:{url:"", args:{}},
					fixedcolumns:[], 
					frozencolumns:[],
					columns:[],
					isresizable:false,
					onclick:null,
					ispage:true,
					pagesize:20
				}
				var options = $.extend({}, defaults, p1);

				return this.each
				(
					function()
					{
						var $container = $(this);
						$container.data("options", options);
						initialize($container);
					}
				);
			}
		}; 

		var methods =
		{
			options: function($obj)
			{
				var options = $obj.data("options");
				return options;
			},
			rebuild: function($obj)
			{
				initialize($obj);
			},
			url: function($obj, url, args)
			{
				if(url != null)
				{
					$obj.data("options").datasource.url = url;
				}
				if(args != null)
				{
					$obj.data("options").datasource.args = args;
				}
				flush( $obj );
			},
			reload: function($obj)
			{
				flush( $obj );
			},
			getSelected: function($obj)
			{
				var $trs = $obj.find(".datagrid-frozen-body-container table tr[isselect=1]");
				if($trs.size() > 0)
				{
					var $tr = $($trs[0]); 
					return $tr.data("row");
				}
			},
			getSelections: function($obj)
			{
				var rows = [];
				var $trs = $obj.find(".datagrid-frozen-body-container table tr[isselect=1]");
				for(var i = 0 ; i < $trs.size() ; i++)
				{
					var $tr = $($trs[i]); 
					rows.push($tr.data("row"));
				}
				return rows;
			},
			copy: function($obj, ids)
			{
				copy($obj, ids);
			},
			del: function($obj, ids)
			{
				del($obj, ids);
			}
		};

	}
)
(jQuery);

