
(
	function($)
	{
		var builder = function($container)
		{
			var options = $container.data("options");
			var fixedcolumns = options.fixedcolumns;
			var frozencolumns = options.frozencolumns;
			var columns = options.columns;
			
			var result = "";
			if(frozencolumns != null || fixedcolumns != null)
			{
				var frozenheader = '';
				frozenheader = '<div class="datagrid-frozen-header-container">';
				frozenheader += '<table>';
				frozenheader += '<tbody>';
				frozenheader += '<tr>';
				
				for(var i = 0 ; i < fixedcolumns.length ; i++)
				{
					var column = fixedcolumns[i];
					frozenheader += '<td>';
					if(column.checkbox)
					{
						frozenheader += '<div class="selection selection-item"><i class="fa fa-square-o"></i></div>';
					}
					else if(column.index)
					{
						frozenheader += '<div class="datagrid-index">序号</div>';
					}
					else if(column.button != null)
					{
						frozenheader += '<div style="'+getHeaderStyle(column)+'"></div>';
					}
					frozenheader += '</td>';
				}

				for(var i = 0 ; i < frozencolumns.length ; i++)
				{
					var column = frozencolumns[i];
					var title = column.title;
					var resizable = column.datagrid.resizable || true;
					var sortable = column.datagrid.sortable || true;

					frozenheader += '<td>';
					if(column.button != null)
					{
						frozenheader += '<div style="'+getHeaderStyle(column)+'"></div>';
					}
					else
					{
						var classname = [];
						if(resizable)
						{
							classname.push("resizable");
						}
						if(sortable)
						{
							classname.push("sortable");
						}
						frozenheader += '<div id="'+column.id+'" class="'+classname.join(" ")+'" style="'+getHeaderStyle(column)+'">'+column.title+'</div>';
					}
					frozenheader += '</td>';
				}

				frozenheader += '</tr>';
				frozenheader += '</tbody>';
				frozenheader += '</table>';
				frozenheader += '</div>';

				result += frozenheader;
			}

			if(columns != null)
			{
				var header = '';
				header += '<div class="datagrid-header-container">';
				header += '<div class="inner">';
				header += '<table>';
				header += '<tbody>';
				header += '<tr>';
				for(var i = 0 ; i < columns.length ; i++)
				{
					var column = columns[i];
					var title = column.title;
					var resizable = column.datagrid.resizable || true;
					var sortable = column.datagrid.sortable || true;

					header += '<td>';
					if(column.button != null)
					{
						header += '<div style="'+getHeaderStyle(column)+'"></div>';
					}
					else
					{
						var classname = [];
						if(resizable)
						{
							classname.push("resizable");
						}
						if(sortable)
						{
							classname.push("sortable");
						}

						header += '<div id="'+column.id+'" class="'+classname.join(" ")+'" style="'+getHeaderStyle(column)+'">'+column.title+'</div>';
					}
					header += '</td>';
				}

				header += '</tr>';
				header += '</tbody>';
				header += '</table>';
				header += '</div>';
				header += '</div>';

				result += header;
			}
			result += '<div style="clear:both"></div>';
			result += '<div class="datagrid-frozen-body-container"><div class="inner"><table><tbody></tbody></table></div></div>';
			result += '<div class="datagrid-body-container"><table><tbody></tbody></table></div>';
			result += '<div class="resizable-line"></div>';
			$container.html(result);

			
			if(frozencolumns != null)
			{
				for(var i = 0 ; i < frozencolumns.length ; i++)
				{
					var column = frozencolumns[i];
					$("#"+column.id).data("column", column);
				}
			}
			if(columns != null)
			{
				for(var i = 0 ; i < columns.length ; i++)
				{
					var column = columns[i];
					$("#"+column.id).data("column", column);
				}
			}

			$container.find(".selection-item").on("click", function(event)
			{
				var classname = $(this).find("i").attr("class");
				if(classname == "fa fa-square-o")
				{
					$(this).find("i").attr("class", "fa fa-check-square-o");
				}
				else
				{
					$(this).find("i").attr("class", "fa fa-square-o");
				}

				var $rows = $container.find(".datagrid-frozen-body-container tbody tr");
				$.each($rows, function(i, row)
				{
					selected($(row));
				});
				event.stopPropagation();
			});


			$container.find(".sortable").on("click", {container:$container}, sort);

			$container.find(".resizable").on("mousemove", function(event)
			{
				if(!options.isresizable)
				{
					var position = $(this).position();
					var width = $(this).outerWidth(true);
					
					if(position.left + width - event.pageX < 5)
					{
						$("body").css("cursor", "e-resize");
					}
					else
					{
						$("body").css("cursor", "");
					}
				}
			});

			$container.find(".resizable").on("mouseout", function(event)
			{
				if(!options.isresizable)
				{
					$("body").css("cursor", "");
				}
			});

			$container.find(".resizable").on("mousedown", function(event)
			{
				if(!options.isresizable)
				{
					var position = $(this).position();
					var width = $(this).outerWidth(true);
					if(position.left + width - event.pageX < 5)
					{
						var resizableline = $container.find(".resizable-line");
						resizableline.css("height", $container.height()+"px");
						resizableline.css("left", position.left + width+"px");
						resizableline.css("top", position.top+"px");
						resizableline.data("target", $(this));
						resizableline.data("start", position.left + width);
						resizableline.show();
						options.isresizable = true;
						$container.addClass("unselect");
					}
				}
			});

			$(window).on("mousemove", function(event)
			{
				if(options.isresizable)
				{
					var resizableline = $container.find(".resizable-line");
					resizableline.css("left", event.clientX+"px");
					event.stopPropagation();
				}
			});

			$(window).on("mouseup", function(event)
			{
				if(options.isresizable)
				{
					options.isresizable = false;
					$("body").css("cursor", "");
					var resizableline = $container.find(".resizable-line");
					resizableline.hide();

					var target = resizableline.data("target");
					var start = resizableline.data("start");
					var width = target.width() + event.pageX - start;
					target.width(width);

					var columnid = target.attr("id");
					var $targets = $container.find("."+columnid+"");
					$targets.css("width", width+"px");
					
					var isFrozen = false;
					for(var i = 0 ; i < frozencolumns.length ; i++)
					{
						var column = frozencolumns[i];
						if(column.id == columnid)
						{
							setBodyStyle(column, "width", width+"px");
							isFrozen = true;
						}
					}
					for(var i = 0 ; i < columns.length ; i++)
					{
						var column = columns[i];
						if(column.id == columnid)
						{
							setBodyStyle(column, "width", width+"px");
						}
					}
					if(isFrozen)
					{
						var width = $container.width() - $container.find(".datagrid-frozen-header-container").outerWidth(true);
						$container.find(".datagrid-header-container").width(width);
						$container.find(".datagrid-body-container").width(width);
					}

					event.stopPropagation();
				}
			});
		}
		
		var sort = function(event)
		{
			var $container = event.data.container;

			var $sortcontainer = $(this).find("span");
			if($sortcontainer.size() == 0)
			{
				$sortcontainer = $('<span class=""><i class=""></i></span>');
				$(this).append($sortcontainer);
			}
			

			var sort = $sortcontainer.attr("class");
			if(sort == "")
			{
				$sortcontainer.find('i').attr("class", "fa fa-angle-down");
				$sortcontainer.removeClass("none").addClass("desc");
			}
			else if(sort == "desc")
			{
				$sortcontainer.find('i').attr("class", "fa fa-angle-up");
				$sortcontainer.removeClass("desc").addClass("asc");
			}
			else if(sort == "asc")
			{
				$sortcontainer.remove();
				$sortcontainer.removeClass("asc").addClass("none");
			}

			var items = [];
			$(".sortable span").each
			(
				function(i)
				{
					var classname = $(this).attr("class");
					if(classname != "")
					{
						var column = $(this).parent().data("column");
						var item = {table:column.table.name, column:column.name, type:classname};
						items.push(item);
					}
				}
			);

			$container.data("options").datasource.args.sort = JSON.stringify(items);
			flush( $container );
		}

		var flush = function($container)
		{
			var options = $container.data("options");
			var fixedcolumns = options.fixedcolumns;
			var frozencolumns = options.frozencolumns;
			var columns = options.columns;
			
			var structureutils = new DataStructureUtils();

			app.showLoading();
			$.post(options.datasource.url, options.datasource.args, function(response)
			{
				app.hideLoading();
				if(response.status == "1")
				{
					var rows = response.resource.rows;
					var $frozenbody = $container.find(".datagrid-frozen-body-container tbody");
					var $body = $container.find(".datagrid-body-container tbody");

					$frozenbody.empty();
					$body.empty();	
					
					for(var i = 0 ; i < rows.length ; i++)
					{
						var row = rows[i];
						var $frozentr = $("<tr/>");
						var $tr = $("<tr/>");

						if(frozencolumns != null || fixedcolumns != null)
						{
							for(var j = 0 ; j < fixedcolumns.length ; j++)
							{
								var $cell = $("<td/>");
								var column = fixedcolumns[j];
								var id = column.id;if(column.checkbox)
								{
									$cell.append('<div class="'+id+' selection"><i class="fa fa-square-o"></i></div>');
								}
								else if(column.index)
								{
									$cell.append('<div class="'+id+' datagrid-index">'+(i+1)+'</div>');
								}
								else if(column.button != null)
								{
									$cell.append('<div class="'+id+'" style="'+getBodyStyle(column)+'">'+createButton(column.button)+'</div>');
								}
								$frozentr.append($cell);
							}
							for(var j = 0 ; j < frozencolumns.length ; j++)
							{
								var column = frozencolumns[j];
								var id = column.id;
								var cache = column.cache;
								var value = row[id];
								if(column.dictionary != null && column.dictionary != "")
								{
									if(cache == null)
									{
										cache = true;
									}
									value = structureutils.getDictionary(app.getContextPath()+"/"+column.dictionary.map, value, cache);
								}

								var $cell = $("<td/>");
								if(column.button != null)
								{
									$cell.append('<div class="'+id+'" style="'+getBodyStyle(column)+'">'+createButton(column.button)+'</div>');
								}
								else
								{
									if(column.editor != null)
									{
										var $editor = $('<span class="editor">'+((value == null || value == "") ? "&nbsp;" : value)+'</span>');
										$editor.data("key", row[id]);
										$editor.data("value", value);
										var $cellcontent = $('<div class="'+id+'" style="'+getBodyStyle(column)+'"/>');
										$cellcontent.append($editor);
										$cell.append($cellcontent);
									}
									else
									{
										$cell.append('<div class="'+id+'" style="cursor:not-allowed; '+getBodyStyle(column)+'">'+((value == null || value == "") ? "&nbsp;" : value)+'</div>');
									}
								}
								$frozentr.append($cell);
							}
							$frozenbody.append($frozentr);
							$frozentr.data("row", row);

						}
						if(columns != null)
						{
							for(var j = 0 ; j < columns.length ; j++)
							{
								var column = columns[j];
								var id = column.id;
								var cache = column.cache;
								var value = row[id];

								if(options.backgrounds)
								{
									$.each(options.backgrounds, function(i)
									{
										if(this.name == id && this.value == value)
										{
											$frozentr.css("background-color", this.color);
											$tr.css("background-color", this.color);

											$frozentr.data("background-color", this.color)
											$tr.data("background-color", this.color)
										}
									});
								}
								if(column.dictionary != null && column.dictionary != "")
								{
									if(cache == null)
									{
										cache = true;
									}
									value = structureutils.getDictionary(app.getContextPath()+"/"+column.dictionary.map, value, cache);
								}

								var $cell = $("<td/>");
								if(column.button)
								{
									$cell.append('<div class="'+id+'" style="'+getBodyStyle(column)+'">'+createButton(column.button)+'</div>');
								}
								else
								{
									if(column.editor != null)
									{
										var $editor = $('<span class="editor">'+((value == null || value == "") ? "&nbsp;" : value)+'</span>');
										$editor.data("key", row[id]);
										$editor.data("value", value);
										var $cellcontent = $('<div class="'+id+'" style="'+getBodyStyle(column)+'"/>');
										$cellcontent.append($editor);
										$cell.append($cellcontent);
									}
									else
									{
										$cell.append('<div class="'+id+'" style="cursor:not-allowed; '+getBodyStyle(column)+'">'+((value == null || value == "") ? "&nbsp;" : value)+'</div>');
									}
								}
								$tr.append($cell);
							}
							$body.append($tr);
							$tr.data("row", row);
						}
						$frozentr.data("contact", $tr);
						$tr.data("contact", $frozentr);


						$frozentr.on("click", clickrow);
						$frozentr.on("mouseout", mouseoutRow);
						$frozentr.on("mouseover", mouseoverRow);

						$tr.on("click", clickrow);
						$tr.on("mouseout", mouseoutRow);
						$tr.on("mouseover", mouseoverRow);
					}

					if(fixedcolumns != null)
					{
						onButtonEvent(fixedcolumns, $frozenbody);
					}
					if(frozencolumns != null)
					{
						onButtonEvent(frozencolumns, $frozenbody);
					}
					if(columns != null)
					{
						onButtonEvent(columns, $body);
					}


					$frozenbody.find("tr td div span.editor").on("click", {"container":$container}, onEditor);
					$body.find("tr td div span.editor").on("click", {"container":$container}, onEditor);
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
									var $cell = $field.parent();
									var row = $field.data("row");
									var column = $field.data("column");
									var key = $field.data("key");
									if(row != null && column != null)
									{
										var value = $field.val();

										var $joint = $field.data("joint");
										if($joint != null)
										{
											value = $joint.val();
										}
										
										if(key != value)
										{
											app.showLoading();
											$.post(options.editor.action, {column:JSON.stringify(column), id:row.ID, value:value}, function(response)
											{
												app.hideLoading();				
												if(response.status == "1")
												{
													//$cell.html($field.val() == "" ? "&nbsp;" : $field.val());
													//$cell.append('<i class="cell-success" title="保存成功">');
													flush( $container );
												}
												else 
												{
													$cell.append('<i class="cell-error" title="'+response.messages+'">');
												}
											}, "json");
										}
										else
										{
											$cell.html($field.data("value"));
										}

									}
								});
							}
						}
					});
				}
				else 
				{
					app.message(response.messages);
				}
			}, "json");
		}

		var clickrow = function(event)
		{
			selected($(this));
		}

		var selected = function($tr)
		{
			if(!isSelected($tr))
			{
				$tr.attr("isselect", "1");
				$tr.find(".selection i").removeClass("fa-square-o");
				$tr.find(".selection i").addClass("fa-check-square-o");
				$tr.css("background-color", "#fff4e3");

				$tr.data("contact").attr("isselect", "1");
				$tr.data("contact").find(".selection i").removeClass("fa-square-o");
				$tr.data("contact").find(".selection i").addClass("fa-check-square-o");
				$tr.data("contact").css("background-color", "#fff4e3");
			}
			else
			{
				$tr.attr("isselect", "0");
				$tr.find(".selection i").removeClass("fa-check-square-o");
				$tr.find(".selection i").addClass("fa-square-o");
				if($tr.data("background-color") != null)
				{
					$tr.css("background-color", $tr.data("background-color"));
				}
				else
				{
					$tr.css("background-color", "#ffffff");
				}

				$tr.data("contact").attr("isselect", "0");
				$tr.data("contact").find(".selection i").removeClass("fa-check-square-o");
				$tr.data("contact").find(".selection i").addClass("fa-square-o");
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

		var onEditor = function(event)
		{
			var $editor = $(this);

			var $row = $editor.parents("tr");
			var row = $row.data("row");

			var $container = event.data.container;
			var $cell = $editor.parents("div");
			var id = $cell.attr("class");
			var header = $container.find("#"+id)
			var column = header.data("column");
			

			var key = $editor.data("key");
			var value = $editor.data("value");
			if(key == value)
			{
				column.editor.value = value;
			}
			else
			{
				column.editor.value = {key:key, value:value};
			}

			var structureutils = new DataStructureUtils();
			$editor.html(structureutils.getField({column:column}).find(".field"));

			var $field = $editor.find(".field:visible");

			$field.data("key", key);
			$field.data("value", value);
			$field.data("row", row);
			$field.data("column", column);


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
				var button = buttons[i];
				result += '<span class="control-button '+button.id+'-button" style="'+button.style+'">'+button.title+'</span>';
			}
			return result;
		}		
		
		var onButtonEvent = function(columns, $parent)
		{
			for(var j = 0 ; j < columns.length ; j++)
			{
				var column = columns[j];
				if(column.button != null)
				{
					var buttons = column.button;
					for(var i = 0 ; i < buttons.length ; i++)
					{
						var button = buttons[i];
						$parent.find("."+button.id+"-button").on("click", button.onclick);
					}
				}
			}
		}

		var getBodyStyle = function(column)
		{
			if(column.datagrid.style != null)
			{
				if(column.datagrid.style.body != null)
				{
					return getStyle(column.datagrid.style.body);
				}
				else
				{
					return getStyle(column.datagrid.style);
				}
			}
			return "";
		}

		var getHeaderStyle = function(column)
		{
			if(column.datagrid.style != null)
			{
				if(column.datagrid.style.header != null)
				{
					return getStyle(column.datagrid.style.header);
				}
				else
				{
					return getStyle(column.datagrid.style);
				}
			}
			return "";
		}

		var setBodyStyle = function(column, key, value)
		{
			if(column.datagrid.style == null)
			{
				column.datagrid.style = {};
				column.datagrid.style[key] = value;
			}
			else
			{
				if(column.datagrid.style.body != null)
				{
					column.datagrid.style.body[key] = value;
				}
				else
				{
					column.datagrid.style[key] = value;
				}
			}
		}

		var getStyle = function(items)
		{
			var style = [];
			for(var item in items)
			{
				style.push(item+":"+items[item]);
			}
			return style.join("; ")
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

		var initialize = function($container)
		{
			var options = $container.data("options");

			//构建表格
			builder($container)
			
			//读取数据并填充表格
			flush( $container );

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
			}
		};

	}
)
(jQuery);

