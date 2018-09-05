function DataStructureUtils()
{
	this.getField = function(options)
	{
		var $container = $('<span/>');
		var column = options.column;
		var name = column.name;
		var dictionary = column.dictionary;
		var type = column.editor.type || "text";
		var value = column.editor.value || "";
		var cache = column.cache || true;
		var multiple = column.editor.multiple || false;
								
		var fieldname = column.table.name+"_"+name;
		var $field= null;

		if(type == "text")
		{
			$field = $('<input name="'+fieldname+'" class="field text-field"/>');
			$field.val(value);
			$container.append($field);
		}
		else if(type == "date")
		{
			$field = $('<input name="'+fieldname+'" class="field date-field"/>');
			$field.val(value);
			$container.append($field);
		}
		else if(type == "tree")
		{
			if(dictionary != null)
			{

			}
		}
		else if(type == "choice")
		{
			if(dictionary != null)
			{
				$field = $('<input name="'+fieldname+'" class="field select-field"/>');
				$field.val(value.key);
				$field.attr("title", value.value);
				$container.append($field);
				$field.selection
				(
					{
						url: app.getContextPath()+"/"+dictionary.list,
						cache: cache,
						ismultiple: multiple
					}
				);
			}
		}

		return $container;
	}

	this.columns = function(datagridcolumns)
	{
		var frozencolumns = [];
		var columns = [];

		for(var i = 0 ; i < datagridcolumns.length ; i++)
		{
			var column = datagridcolumns[i];
			if( column.datagrid != null && column.datagrid.frozen )
			{
				frozencolumns.push(column);
			}
			else
			{
				columns.push(column);
			}
		}
		var datagridcolumns = {};
		datagridcolumns.frozencolumns = frozencolumns;
		datagridcolumns.columns = columns;

		return datagridcolumns;
	}

	this.getDictionary = function(url, value, cache)
	{
		var dictionaries = $("body").data("dictionary");
		if(dictionaries == null)
		{
			$("body").data("dictionary", {});
			dictionaries = $("body").data("dictionary");
		}

		if(cache == null)
		{
			cache = true;
		}
		var dictionary = url;
		if(dictionaries[dictionary] == null)
		{
			$.ajax
			({
				async: false,
				dataType: "json",
				url:url,
				cache:cache,
				success:function(item) 
				{
					dictionaries[dictionary] = item;
				}
			});
		}
		
		var result = [];
		if(value != null)
		{
			value = value.toString()
			var values = value.split(",");
			for(var i = 0 ; i < values.length ; i++)
			{
				if(dictionaries[dictionary] != null)
				{
					result.push(dictionaries[dictionary][values[i]]);
				}
			}
			return result.join(",");
		}
		return "";
	}
}



















