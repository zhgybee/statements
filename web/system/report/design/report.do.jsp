<%@page import="org.json.JSONArray"%>
<%@page import="org.apache.commons.lang3.StringUtils"%>
<%@page import="org.json.JSONObject"%>
<%@page import="com.system.utils.SystemUtils"%>
<%@page import="org.apache.commons.io.FileUtils"%>
<%@page import="com.system.SystemProperty"%>
<%@page import="java.io.File"%>
<%@page contentType="text/html; charset=utf-8"%>

<%
	String action = request.getParameter("action");
	JSONObject result = new JSONObject();
	String code = "0";
	String message = "";
	if(action.equals("add"))
	{
		File tempalte = new File(SystemProperty.PATH + SystemProperty.FILESEPARATOR +"system"+SystemProperty.FILESEPARATOR+"report"+SystemProperty.FILESEPARATOR+"design"+SystemProperty.FILESEPARATOR+"template.json");
		
		File report = new File(SystemProperty.PATH + SystemProperty.FILESEPARATOR +"system"+SystemProperty.FILESEPARATOR+"report"+SystemProperty.FILESEPARATOR+"config"+SystemProperty.FILESEPARATOR + SystemUtils.uuid()+".json");
		 
		FileUtils.copyFile(tempalte, report, false);
	}
	else if(action.equals("copy"))
	{
		String id = request.getParameter("id");
		
		File tempalte = new File(SystemProperty.PATH + SystemProperty.FILESEPARATOR +"system"+SystemProperty.FILESEPARATOR+"report"+SystemProperty.FILESEPARATOR+"config"+SystemProperty.FILESEPARATOR + id +".json");
		
		File report = new File(SystemProperty.PATH + SystemProperty.FILESEPARATOR +"system"+SystemProperty.FILESEPARATOR+"report"+SystemProperty.FILESEPARATOR+"config"+SystemProperty.FILESEPARATOR + SystemUtils.uuid()+".json");

		FileUtils.copyFile(tempalte, report, false);
	}
	else if(action.equals("delete"))
	{
		String id = request.getParameter("id");
		
		File report = new File(SystemProperty.PATH + SystemProperty.FILESEPARATOR +"system"+SystemProperty.FILESEPARATOR+"report"+SystemProperty.FILESEPARATOR+"config"+SystemProperty.FILESEPARATOR + id +".json");
		
		File template = new File(SystemProperty.PATH + SystemProperty.FILESEPARATOR +"system"+SystemProperty.FILESEPARATOR+"report"+SystemProperty.FILESEPARATOR+"template"+SystemProperty.FILESEPARATOR + id+".xls");
		
		template.delete();
		report.delete();
	}
	else if(action.equals("delete-report-source"))
	{
		String id = request.getParameter("id");
		String key = request.getParameter("key");
		
		File file = new File(SystemProperty.PATH + SystemProperty.FILESEPARATOR +"system"+SystemProperty.FILESEPARATOR+"report"+SystemProperty.FILESEPARATOR+"config"+SystemProperty.FILESEPARATOR + id +".json");

		JSONObject report = new JSONObject(FileUtils.readFileToString(file, "UTF-8"));
		
		JSONObject source = report.optJSONObject("SOURCE");
		JSONObject sqls = source.optJSONObject("SQLS");
		sqls.remove(key);
		FileUtils.writeStringToFile(file, report.toString(4), "UTF-8");
	}
	else if(action.equals("delete-report-item"))
	{
		String id = request.getParameter("id");
		String row = request.getParameter("row");
		String col = request.getParameter("col");
		
		File file = new File(SystemProperty.PATH + SystemProperty.FILESEPARATOR +"system"+SystemProperty.FILESEPARATOR+"report"+SystemProperty.FILESEPARATOR+"config"+SystemProperty.FILESEPARATOR + id +".json");
		JSONObject report = new JSONObject(FileUtils.readFileToString(file, "UTF-8"));
		
		JSONArray items = report.optJSONArray("ITEMS");
		for(int i = 0 ; i < items.length() ; i++)
		{
			JSONObject item = items.optJSONObject(i);
			if(row.equals(item.optString("ROW")) && col.equals(item.optString("COL")))
			{
				items.remove(i);
				break;
			}
		}
		FileUtils.writeStringToFile(file, report.toString(4), "UTF-8");
	}
	else if(action.equals("save-report-general"))
	{
		String id = request.getParameter("id");
		File file = new File(SystemProperty.PATH + SystemProperty.FILESEPARATOR +"system"+SystemProperty.FILESEPARATOR+"report"+SystemProperty.FILESEPARATOR+"config"+SystemProperty.FILESEPARATOR + id +".json");
		JSONObject report = new JSONObject(FileUtils.readFileToString(file, "UTF-8"));
		
		String title = request.getParameter("report-title");
		String handle = request.getParameter("report-handle");
		String log = StringUtils.defaultString(request.getParameter("report-log"), "0");
		String perview = StringUtils.defaultString(request.getParameter("report-perview"), "0");
		String[] changervalues = request.getParameterValues("report-changer-value");
		String[] changerreplacements = request.getParameterValues("report-changer-replacement");

		report.put("TITLE", title);
		report.put("HANDLE", handle);
		report.put("LOG", log.equals("1")?true:false);
		report.put("PERVIEW", perview.equals("1")?true:false);
		
		JSONObject changers = new JSONObject();
		for(int i = 0 ; i < changervalues.length ; i++)
		{
			String changervalue = changervalues[i];
			String changerreplacement = changerreplacements[i];
			
			if(!changervalue.equals("") && !changerreplacement.equals(""))
			{
				changers.put(changervalue, changerreplacement);
			}
			
		}
		report.remove("CHANGER");
		if(changers.length() > 0)
		{
			report.put("CHANGER", changers);
		}
		FileUtils.writeStringToFile(file, report.toString(4), "UTF-8");
		
	}
	else if(action.equals("save-report-sheet"))
	{
		String id = request.getParameter("id");
		File file = new File(SystemProperty.PATH + SystemProperty.FILESEPARATOR +"system"+SystemProperty.FILESEPARATOR+"report"+SystemProperty.FILESEPARATOR+"config"+SystemProperty.FILESEPARATOR + id +".json");
		JSONObject report = new JSONObject(FileUtils.readFileToString(file, "UTF-8"));
		JSONObject sheet = report.optJSONObject("SHEET");
		String mode = request.getParameter("report-sheet-mode");
		String name = request.getParameter("report-sheet-name");
		String source = request.getParameter("report-sheet-source");
		sheet.put("MODE", mode);
		sheet.put("NAME", name);
		sheet.put("SOURCE", source);
		FileUtils.writeStringToFile(file, report.toString(4), "UTF-8");
	}
	else if(action.equals("save-report-source"))
	{
		String id = request.getParameter("id");
		String oldkey = request.getParameter("report-sql-key-old");
		
		File file = new File(SystemProperty.PATH + SystemProperty.FILESEPARATOR +"system"+SystemProperty.FILESEPARATOR+"report"+SystemProperty.FILESEPARATOR+"config"+SystemProperty.FILESEPARATOR + id +".json");
		JSONObject report = new JSONObject(FileUtils.readFileToString(file, "UTF-8"));
		
		JSONObject source = report.optJSONObject("SOURCE");
		JSONObject sqls = source.optJSONObject("SQLS");
		
		sqls.remove(oldkey);
		JSONObject sql = new JSONObject();

		String key = request.getParameter("report-sql-key");
		String text = request.getParameter("report-sql-text");
		String mapkey = request.getParameter("report-sql-mapkey");
		
		sql.put("SQL", text);
		sql.put("MAPKEY", mapkey);
		
		JSONObject joiner = new JSONObject();
		String alias = request.getParameter("report-sql-alias");
		if(!alias.equals(""))
		{
			joiner.put("ALIAS", alias);
		}
		String prefix = request.getParameter("report-sql-prefix");
		if(!prefix.equals(""))
		{
			joiner.put("PREFIX", prefix);
		}
		String index = request.getParameter("report-sql-index");
		if(!index.equals(""))
		{
			joiner.put("INDEX", index);
		}
		sql.remove("JOIN");
		if(joiner.length() > 0)
		{
			sql.put("JOIN", joiner);
		}

		JSONObject moder = new JSONObject();
		String modename = request.getParameter("report-sql-mode-name");
		if(!modename.equals(""))
		{
			moder.put("NAME", modename);

			String[] parameternames = request.getParameterValues("report-sql-mode-parameter");
			String[] parametervalues = request.getParameterValues("report-sql-mode-value");
			

			JSONObject parameters = new JSONObject();
			for(int i = 0 ; i < parameternames.length ; i++)
			{
				String parametername = parameternames[i];
				String parametervalue = parametervalues[i];
				
				if(!parametername.equals("") && !parametervalue.equals(""))
				{
					parameters.put(parametername, parametervalue);
				}
				
			}
			moder.remove("PARAMETER");
			if(parameters.length() > 0)
			{
				moder.put("PARAMETER", parameters);
			}
			sql.put("MODE", moder);
		}
		sqls.put(key, sql);
		FileUtils.writeStringToFile(file, report.toString(4), "UTF-8");
	}
	else if(action.equals("save-report-searcher"))
	{
		String id = request.getParameter("id");
		
		File file = new File(SystemProperty.PATH + SystemProperty.FILESEPARATOR +"system"+SystemProperty.FILESEPARATOR+"report"+SystemProperty.FILESEPARATOR+"config"+SystemProperty.FILESEPARATOR + id +".json");
		JSONObject report = new JSONObject(FileUtils.readFileToString(file, "UTF-8"));
		
		JSONArray searchers = new JSONArray();
		
		String[] titles = request.getParameterValues("report-searcher-title");
		String[] types = request.getParameterValues("report-searcher-type");
		String[] names = request.getParameterValues("report-searcher-name");
		String[] values = request.getParameterValues("report-searcher-value");
		String[] dictionarylists = request.getParameterValues("report-searcher-dictionary-list");
		String[] dictionarymaps = request.getParameterValues("report-searcher-dictionary-map");

		for(int i = 0 ; i < titles.length ; i++)
		{
			JSONObject searcher = new JSONObject();
			
			String title = titles[i];
			String type = types[i];
			String name = names[i];
			String value = values[i];
			String dictionarylist = dictionarylists[i];
			String dictionarymap = dictionarymaps[i];
			
			if(!title.equals(""))
			{
				searcher.put("title", title);
			}
			
			JSONObject editor = new JSONObject();
			if(!type.equals(""))
			{
				editor.put("type", type);
			}
			if(!name.equals(""))
			{
				editor.put("fieldname", name);
			}
			if(!value.equals(""))
			{
				editor.put("value", value);
			}
			if(editor.length() > 0)
			{
				searcher.put("editor", editor);
			}
			
			JSONObject dictionary = new JSONObject();
			if(!dictionarylist.equals(""))
			{
				dictionary.put("list", dictionarylist);
			}
			if(!dictionarymap.equals(""))
			{
				dictionary.put("map", dictionarymap);
			}
			if(dictionary.length() > 0)
			{
				searcher.put("dictionary", dictionary);
			}
			
			searchers.put(searcher);
		}
		report.put("SEARCHER", searchers);

		FileUtils.writeStringToFile(file, report.toString(4), "UTF-8");
	}
	else if(action.equals("save-report-item"))
	{
		String id = request.getParameter("id");
		String row = request.getParameter("report-item-row");
		String col = request.getParameter("report-item-col");
		
		File file = new File(SystemProperty.PATH + SystemProperty.FILESEPARATOR +"system"+SystemProperty.FILESEPARATOR+"report"+SystemProperty.FILESEPARATOR+"config"+SystemProperty.FILESEPARATOR + id +".json");
		JSONObject report = new JSONObject(FileUtils.readFileToString(file, "UTF-8"));
		
		JSONArray items = report.optJSONArray("ITEMS");
		for(int i = 0 ; i < items.length() ; i++)
		{
			JSONObject item = items.optJSONObject(i);
			if(row.equals(item.optString("ROW")) && col.equals(item.optString("COL")))
			{
				items.remove(i);
				break;
			}
		}
		
		JSONObject item = new JSONObject();
		String output = request.getParameter("report-item-output");
		String expression = request.getParameter("report-item-expression");
		String type = request.getParameter("report-item-type");
		String formatter = request.getParameter("report-item-formatter");
		String debar = request.getParameter("report-item-debar");

		item.put("ROW", row);
		item.put("COL", col);
		if(!output.equals(""))
		{
			item.put("OUTPUT", output);
			if(expression.equals("1"))
			{
				item.put("EXPRESSION", true);
			}
		}
		if(!type.equals(""))
		{
			item.put("TYPE", type);
		}
		if(!formatter.equals(""))
		{
			item.put("FORMATTER", formatter);
		}
		if(debar.equals("1"))
		{
			item.put("DEBAR", debar);
		}
		
		JSONArray columns = new JSONArray();  
		String[] columnaliases = request.getParameterValues("report-item-column-alias");
		String[] columnsources = request.getParameterValues("report-item-column-source");
		String[] columnnames = request.getParameterValues("report-item-column-name");
		String[] columnsymbols = request.getParameterValues("report-item-column-symbol");
		String[] columndefaults = request.getParameterValues("report-item-column-default");
		String[] columntypes = request.getParameterValues("report-item-column-type");
		String[] columnformatters = request.getParameterValues("report-item-column-formatter");
		String[] columndictionaries = request.getParameterValues("report-item-column-dictionary");
		String[] columnconditions = request.getParameterValues("report-item-column-conditions");

		for(int i = 0 ; i < columnaliases.length ; i++)
		{
			JSONObject column = new JSONObject();
			
			String columnalias = columnaliases[i];
			String columnsource = columnsources[i];
			String columnname = columnnames[i];
			String columnsymbol = columnsymbols[i];
			String columndefault = columndefaults[i];
			String columntype = columntypes[i];
			String columnformatter = columnformatters[i];
			String columndictionary = columndictionaries[i];
			String columncondition = columnconditions[i];
			
			if(!columnalias.equals(""))
			{
				column.put("ALIAS", columnalias);
			}
			if(!columnsource.equals(""))
			{
				column.put("SOURCE", columnsource);
			}
			if(!columnname.equals(""))
			{
				column.put("NAME", columnname);
			}
			if(!columnsymbol.equals(""))
			{
				column.put("SYMBOL", columnsymbol);
			}
			if(!columndefault.equals(""))
			{
				column.put("DEFAULT", columndefault);
			}
			if(!columntype.equals(""))
			{
				column.put("TYPE", columntype);
			}
			if(!columnformatter.equals(""))
			{
				column.put("FORMATTER", columnformatter);
			}
			if(!columndictionary.equals(""))
			{
				column.put("DICTIONARY", columndictionary);
			}
			if(!columncondition.equals(""))
			{
				column.put("CONDITIONS", columncondition);
			}
			if(column.length() > 0)
			{
				columns.put(column);
			}
		}
		item.put("COLUMNS", columns);
		items.put(item);
		FileUtils.writeStringToFile(file, report.toString(4), "UTF-8");
	}
	
	result.put("CODE", code);
	result.put("MESSAGE", message);
	
	
	out.println(result);
%>