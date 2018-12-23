function DataStructureUtils()
{
	this.getFields = function(options)
	{
		var column = options.column;
		var name = column.name;
		var dictionary = column.dictionary;
		var type = column.editor.type || "text";
		var value = column.editor.value || "";
		var cache = column.cache || true;
		var multiple = column.editor.multiple || false;
								
		var $field= null;

		if(type == "text")
		{
			$field = $('<input name="'+name+'" class="field text-field"/>');
			$field.val(value);
		}
		else if(type == "date")
		{
			$field = $('<input name="'+name+'" class="field date-field"/>');
			$field.val(value);
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
				$field = $('<input name="'+name+'" class="field select-field"/>');
				$field.val(value.value);
				$field.attr("title", value.description);
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

		return $field;
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