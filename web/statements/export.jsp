<%@page import="org.json.JSONException"%>
<%@page import="com.system.utils.StatementUtils"%>
<%@page import="java.util.Objects"%>
<%@page import="org.apache.commons.lang3.ArrayUtils"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="org.apache.commons.lang3.math.NumberUtils"%>
<%@page import="com.system.datastructure.DataStructure"%>
<%@page import="com.system.utils.SystemUtils"%>
<%@page import="java.util.LinkedHashSet"%>
<%@page import="java.net.URLDecoder"%>
<%@page import="org.apache.commons.lang3.StringUtils"%>
<%@page import="com.system.datasource.Datum"%>
<%@page import="java.util.Set"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="com.system.variable.VariableService"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="org.json.JSONObject"%>
<%@page import="java.io.File"%>
<%@page import="org.apache.commons.io.FileUtils"%>
<%@page import="org.json.JSONArray"%>
<%@page import="com.system.utils.ThrowableUtils"%>
<%@page import="com.system.SystemProperty"%>
<%@page import="com.system.datasource.Data"%>
<%@page import="com.system.datasource.DataSource"%>
<%@page import="java.sql.Connection"%>
<%@page import="com.system.SessionUser"%>
<%@page import="com.system.utils.ServiceMessage"%>

<%@page contentType="text/html; charset=utf-8"%>

<%
	ServiceMessage message = new ServiceMessage();
	SessionUser sessionuser = SessionUser.getSessionUser(session);
	
	if(sessionuser != null)
	{
		List<String> warnings = new ArrayList<String>();
		
		String version = request.getParameter("version");
		String substatementId = StringUtils.defaultString(request.getParameter("substatement"), "");
		String statementmode = StringUtils.defaultString(request.getParameter("statementmode"), "");
		String children = StringUtils.defaultString(request.getParameter("children"), "");
		String statementname = StringUtils.defaultString(request.getParameter("statementname"), "");
		String substatementname = StringUtils.defaultString(request.getParameter("substatementname"), "");
		

		children = URLDecoder.decode(children, "UTF-8");
		
		JSONArray items = new JSONArray( FileUtils.readFileToString(new File(SystemProperty.PATH + SystemProperty.FILESEPARATOR + "config" + SystemProperty.FILESEPARATOR + "report" + SystemProperty.FILESEPARATOR + version+".json"), "UTF-8" ));

		StringBuffer xml = new StringBuffer();
		Connection connection = null;
		try
		{
			connection = DataSource.connection(SystemProperty.DATASOURCE);	
			DataSource datasource = new DataSource(connection);	
			xml.append("<?xml version=\"1.0\"?>");
	
			xml.append("<w:wordDocument xmlns:aml=\"http://schemas.microsoft.com/aml/2001/core\" xmlns:wpc=\"http://schemas.microsoft.com/office/word/2010/wordprocessingCanvas\" xmlns:dt=\"uuid:C2F41010-65B3-11d1-A29F-00AA00C14882\" xmlns:mc=\"http://schemas.openxmlformats.org/markup-compatibility/2006\" xmlns:o=\"urn:schemas-microsoft-com:office:office\" xmlns:v=\"urn:schemas-microsoft-com:vml\" xmlns:w10=\"urn:schemas-microsoft-com:office:word\" xmlns:w=\"http://schemas.microsoft.com/office/word/2003/wordml\" xmlns:wx=\"http://schemas.microsoft.com/office/word/2003/auxHint\" xmlns:wne=\"http://schemas.microsoft.com/office/word/2006/wordml\" xmlns:wsp=\"http://schemas.microsoft.com/office/word/2003/wordml/sp2\" xmlns:sl=\"http://schemas.microsoft.com/schemaLibrary/2003/core\" w:macrosPresent=\"no\" w:embeddedObjPresent=\"no\" w:ocxPresent=\"no\" xml:space=\"preserve\"><w:ignoreSubtree w:val=\"http://schemas.microsoft.com/office/word/2003/wordml/sp2\"/>");
			xml.append("<w:body>");


			for(int i = 0 ; i < items.length() ; i++)
			{
				JSONObject item = items.optJSONObject(i);
				String type = item.optString("type");
				String tableId = item.optString("id");
				
				Data data = null;
				
				if(!tableId.equals(""))
				{
					DataStructure datastructure = SystemProperty.DATASTRUCTURES.get(tableId);
					String sql = datastructure.getProperty().optString("table");
					
					if(item.has("dateset"))
					{
						String datesetcode = item.optString("dateset");
						JSONObject dataset = SystemProperty.SQLBUILDER.get(datesetcode);
						if(dataset != null)
						{
							sql = dataset.optString("sql");
							sql = VariableService.parseUrlVariable(sql, 0, request);
							sql = VariableService.parseSysVariable(sql, request);
							sql = "("+sql+")";
						}
						else
						{
							warnings.add("SQL构建器中不存在["+datesetcode+"]。");
						}
					}
					
					if(statementmode.equals("2"))
					{
						data = datasource.find("select * from "+sql+" T where T.SUBSTATEMENT_ID in ("+children+") and MODE = 0");
						data = SystemUtils.merge(data, item.optJSONArray("columns"));
					}
					else if(statementmode.equals("1"))
					{
						data = datasource.find("select * from "+sql+" T where T.SUBSTATEMENT_ID = ? and MODE = 1", substatementId);
					}
					else if(statementmode.equals("0"))
					{
						data = datasource.find("select * from "+sql+" T where T.SUBSTATEMENT_ID = ? and MODE = 0", substatementId);
					}
				}
				
				
				if(type.equals("newline"))
				{
					xml.append("<w:p/>");
				}
				if(type.equals("text"))
				{
					String content = item.optString("content");
					if(data != null && data.size() > 0)
					{
						content = VariableService.parseDataVariable(content, data.get(0));
					}
					xml.append("<w:p>");
					xml.append("	<w:r>");
					xml.append("		<w:t>"+content+"</w:t>");
					xml.append("	</w:r>");
					xml.append("</w:p>");
				}
				else if(type.equals("table"))
				{				
					JSONArray columns = item.optJSONArray("columns");
					JSONArray header = item.optJSONArray("header");
					if(header == null)
					{
						header = new JSONArray();
						header.put(columns);
					}
					
					xml.append("<w:tbl>");
					xml.append("<w:tblPr>");
					xml.append("	<w:tblW w:w=\"0\" w:type=\"auto\"/>");
					xml.append("	<w:jc w:val=\"center\"/>");
					xml.append("	<w:tblBorders>");
					xml.append("		<w:top w:val=\"single\" w:sz=\"4\" wx:bdrwidth=\"10\" w:space=\"0\" w:color=\"auto\"/>");
					xml.append("		<w:bottom w:val=\"single\" w:sz=\"4\" wx:bdrwidth=\"10\" w:space=\"0\" w:color=\"auto\"/>");
					xml.append("		<w:left w:val=\"single\" w:sz=\"4\" wx:bdrwidth=\"10\" w:space=\"0\" w:color=\"auto\"/>");
					xml.append("		<w:right w:val=\"single\" w:sz=\"4\" wx:bdrwidth=\"10\" w:space=\"0\" w:color=\"auto\"/>");
					xml.append("		<w:insideH w:val=\"single\" w:sz=\"4\" wx:bdrwidth=\"10\" w:space=\"0\" w:color=\"auto\"/>");
					xml.append("		<w:insideV w:val=\"single\" w:sz=\"4\" wx:bdrwidth=\"10\" w:space=\"0\" w:color=\"auto\"/>");
					xml.append("	</w:tblBorders>");
					xml.append("</w:tblPr>");
					
					
					
	
					Map<String, Set<String>> dynamiccolumnmap = new HashMap<String, Set<String>>();
					for(int j = 0 ; j < columns.length() ; j++)
					{
						JSONObject column = columns.optJSONObject(j);
						String meaning = column.optString("meaning");
						String columnname = column.optString("name");
						if(meaning.equals("jsonobject"))
						{
							String sql = "";
							if(statementmode.equals("2"))
							{
								sql = "select * from T_HEADER where TABLE_ID = '"+tableId+"' and SUBSTATEMENT_ID in ("+children+") and TAGCODE = '"+columnname+"' and MODE = 0";
							}
							else if(statementmode.equals("1"))
							{
								sql = "select * from T_HEADER where TABLE_ID = '"+tableId+"' and SUBSTATEMENT_ID = '"+substatementId+"' and TAGCODE = '"+columnname+"' and MODE = 1";
							}
							else if(statementmode.equals("0"))
							{
								sql = "select * from T_HEADER where TABLE_ID = '"+tableId+"' and SUBSTATEMENT_ID = '"+substatementId+"' and TAGCODE = '"+columnname+"' and MODE = 0";
							}
							Set<String> dynamiccolumns = new LinkedHashSet<String>();
							Data dynamicheaders = datasource.find(sql); 
							for(Datum dynamicheader : dynamicheaders)
							{
								String code = dynamicheader.getString("TABCODE");
								JSONArray array = new JSONArray(dynamicheader.getString("TEXT"));
								for(int k = 0 ; k < array.length() ; k++)
								{
									dynamiccolumns.add(array.optString(k));
								}
							}
							dynamiccolumnmap.put(columnname, dynamiccolumns);
						}
					}
					

					for(int j = 0 ; j < header.length() ; j++)
					{
						JSONArray headercolumns = header.optJSONArray(j);
						
						xml.append("<w:tr>");
						xml.append("	<w:trPr>");
						xml.append("		<w:trHeight w:val=\"450\" w:h-rule=\"atLeast\"/>");
						xml.append("	</w:trPr>");
						for(int k = 0 ; k < headercolumns.length() ; k++)
						{
							JSONObject column = headercolumns.optJSONObject(k);
							String meaning = column.optString("meaning");
							String colspan = column.optString("colspan");
							String rowspan = column.optString("rowspan");
							String align = column.optString("align");
							if(align.equals(""))
							{
								align = "center";
							}
							
							if(!colspan.equals(""))
							{
								if(colspan.equals("auto"))
								{
									String target = column.optString("target");
									Set<String> dynamiccolumns = dynamiccolumnmap.get(target);
									colspan = String.valueOf(dynamiccolumns.size());
								}
							}

							if(meaning.equals("jsonobject"))
							{
								String target = column.optString("target");
								if(target.equals(""))
								{
									target = column.optString("name");
								}
								Set<String> dynamiccolumns = dynamiccolumnmap.get(target);
								if(dynamiccolumns.size() != 0)
								{
									for(String dynamiccolumn : dynamiccolumns)
									{
										xml.append("	<w:tc>");
										xml.append("		<w:tcPr>");
										xml.append("			<w:tcW w:w=\""+column.optInt("width")+"\" w:type=\"dxa\"/>");
										xml.append("			<w:shd w:val=\"clear\" w:color=\"auto\" w:fill=\"C7DAF1\"/>");
										xml.append("			<w:vAlign w:val=\"center\"/>");
										xml.append("		</w:tcPr>");
										xml.append("		<w:p>");
										xml.append("			<w:pPr>");
										xml.append("				<w:jc w:val=\""+align+"\"/>");
										xml.append("			</w:pPr>");
										xml.append("			<w:r>");
										xml.append("				<w:t>"+dynamiccolumn+"</w:t>");
										xml.append("			</w:r>");
										xml.append("		</w:p>");
										xml.append("	</w:tc>");
									}
								}
								else
								{
									xml.append("	<w:tc>");
									xml.append("		<w:tcPr>");
									xml.append("			<w:tcW w:w=\""+column.optInt("width")+"\" w:type=\"dxa\"/>");
									xml.append("			<w:shd w:val=\"clear\" w:color=\"auto\" w:fill=\"C7DAF1\"/>");
									xml.append("			<w:vAlign w:val=\"center\"/>");
									xml.append("		</w:tcPr>");
									xml.append("		<w:p>");
									xml.append("		</w:p>");
									xml.append("	</w:tc>");
								}
							}
							else
							{
								xml.append("	<w:tc>");
								xml.append("		<w:tcPr>");
								if(!colspan.equals(""))
								{
									if(colspan.equals("0"))
									{
										xml.append("		<w:tcW w:w=\""+(column.optInt("width"))+"\" w:type=\"dxa\"/>");
									}
									else
									{
										xml.append("		<w:tcW w:w=\""+(column.optInt("width") * NumberUtils.toInt(colspan, 0))+"\" w:type=\"dxa\"/>");
										xml.append("		<w:gridSpan w:val=\""+colspan+"\"/>");
									}
								}
								else
								{
									xml.append("		<w:tcW w:w=\""+column.optInt("width")+"\" w:type=\"dxa\"/>");
								}
								if(!rowspan.equals(""))
								{
									xml.append("		<w:vmerge w:val=\""+rowspan+"\"/>");
								}
								xml.append("			<w:shd w:val=\"clear\" w:color=\"auto\" w:fill=\"C7DAF1\"/>");
								xml.append("			<w:vAlign w:val=\"center\"/>");
								xml.append("		</w:tcPr>");
								xml.append("		<w:p>");
								xml.append("			<w:pPr>");
								xml.append("				<w:jc w:val=\""+align+"\"/>");
								xml.append("			</w:pPr>");
								xml.append("			<w:r>");
								xml.append("				<w:t>"+column.optString("title")+"</w:t>");
								xml.append("			</w:r>");
								xml.append("		</w:p>");
								xml.append("	</w:tc>");
							}
						}		
						xml.append("</w:tr>");
					}
					

					

	
					if(data != null)
					{
						JSONObject mergecolumn = null;
						for(int j = 0 ; j < columns.length() ; j++)
						{
							JSONObject column = columns.optJSONObject(j);
							if(column.has("merge"))
							{
								JSONObject mergeconfig = column.optJSONObject("merge");
								if(mergeconfig.has("group"))
								{
									mergecolumn = column;
								}
							}
						}
						
						Map<String, Double> summap = new HashMap<String, Double>();
						for(Datum datum : data)
						{
							xml.append("<w:tr>");
							xml.append("	<w:trPr>");
							xml.append("		<w:trHeight w:val=\"450\" w:h-rule=\"atLeast\"/>");
							xml.append("	</w:trPr>");
							for(int j = 0 ; j < columns.length() ; j++)
							{
								JSONObject column = columns.optJSONObject(j);
	
								String columnname = column.optString("name");
								String align = column.optString("align");
								if(align.equals(""))
								{
									align = "center";
								}
								String value = datum.getString(columnname);	
	
								Set<String> dynamiccolumns = dynamiccolumnmap.get(columnname);
								
								boolean issum = false;
								JSONArray sumexcludes = null;
								if(column.has("sum"))
								{
									issum = true;
									JSONObject sumconfig = column.optJSONObject("sum");
									if(sumconfig != null)
									{
										sumexcludes =  sumconfig.optJSONArray("exclude");
									}
								}
								
								if(dynamiccolumns != null)
								{
									if(!value.equals(""))
									{
										JSONObject valuemap = new JSONObject(value);
										for(String dynamiccolumn : dynamiccolumns)
										{
											xml.append("	<w:tc>");
											xml.append("		<w:tcPr>");
											xml.append("			<w:tcW w:w=\""+column.optInt("width")+"\" w:type=\"dxa\"/>");
											xml.append("			<w:vAlign w:val=\"center\"/>");
											xml.append("		</w:tcPr>");
											xml.append("		<w:p>");
											xml.append("			<w:pPr>");
											xml.append("				<w:jc w:val=\""+align+"\"/>");
											xml.append("			</w:pPr>");
											xml.append("			<w:r>");
											xml.append("				<w:t>"+toValue(column, valuemap.optString(dynamiccolumn))+"</w:t>");
											xml.append("			</w:r>");
											xml.append("		</w:p>");
											xml.append("	</w:tc>");
											if(issum)
											{
												boolean isexclude = false;
												if(sumexcludes != null)
												{
													if(mergecolumn != null)
													{
														String groupvalue = datum.getString(mergecolumn.optString("name"));
														for(int k = 0 ; k < sumexcludes.length() ; k++)
														{
															if(groupvalue.indexOf(sumexcludes.optString(k)) != -1)
															{
																isexclude = true;
															}
														}
													}
												}
												if(!isexclude)
												{
													Double sum = summap.get(dynamiccolumn);
													if(sum == null)
													{
														summap.put(dynamiccolumn, NumberUtils.toDouble(valuemap.optString(dynamiccolumn), 0));
													}
													else
													{
														summap.put(dynamiccolumn, sum + NumberUtils.toDouble(valuemap.optString(dynamiccolumn), 0));
													}
												}
											}
										}
									}
								}
								else
								{
									xml.append("	<w:tc>");
									xml.append("		<w:tcPr>");
									xml.append("			<w:tcW w:w=\""+column.optInt("width")+"\" w:type=\"dxa\"/>");
									xml.append("			<w:vAlign w:val=\"center\"/>");
									xml.append("		</w:tcPr>");
									xml.append("		<w:p>");
									xml.append("			<w:pPr>");
									xml.append("				<w:jc w:val=\""+align+"\"/>");
									xml.append("			</w:pPr>");
									xml.append("			<w:r>");
									xml.append("				<w:t>"+toValue(column, value)+"</w:t>");
									xml.append("			</w:r>");
									xml.append("		</w:p>");
									xml.append("	</w:tc>");
									if(issum)
									{
										boolean isexclude = false;
					
										if(sumexcludes != null)
										{
											if(mergecolumn != null)
											{
												String groupvalue = datum.getString(mergecolumn.optString("name"));
												for(int k = 0 ; k < sumexcludes.length() ; k++)
												{
													if(groupvalue.indexOf(sumexcludes.optString(k)) != -1)
													{
														isexclude = true;
													}
												}
											}
										}
										
										if(!isexclude)
										{
											Double sum = summap.get(columnname);
											if(sum == null)
											{
												summap.put(columnname, NumberUtils.toDouble(value, 0));
											}
											else
											{
												summap.put(columnname, sum + NumberUtils.toDouble(value, 0));
											}
										}
									}
									
								}
							}
							xml.append("</w:tr>");
						}
						
						if(summap.size() > 0)
						{
							xml.append("<w:tr>");
							xml.append("	<w:trPr>");
							xml.append("		<w:trHeight w:val=\"450\" w:h-rule=\"atLeast\"/>");
							xml.append("	</w:trPr>");
							for(int j = 0 ; j < columns.length() ; j++)
							{
								JSONObject column = columns.optJSONObject(j);
								String columnname = column.optString("name");
								Set<String> dynamiccolumns = dynamiccolumnmap.get(columnname);
								if(columnname.equals(mergecolumn.optString("name")))
								{
									xml.append("	<w:tc>");
									xml.append("		<w:tcPr>");
									xml.append("			<w:tcW w:w=\""+column.optInt("width")+"\" w:type=\"dxa\"/>");
									xml.append("			<w:vAlign w:val=\"center\"/>");
									xml.append("		</w:tcPr>");
									xml.append("		<w:p>");
									xml.append("			<w:pPr>");
									xml.append("				<w:jc w:val=\"center\"/>");
									xml.append("			</w:pPr>");
									xml.append("			<w:r>");
									xml.append("				<w:t>合计</w:t>");
									xml.append("			</w:r>");
									xml.append("		</w:p>");
									xml.append("	</w:tc>");												
								}
								else
								{
									if(dynamiccolumns != null)
									{
										for(String dynamiccolumn : dynamiccolumns)
										{
											String value = "";
											if(summap.get(dynamiccolumn) != null && summap.get(dynamiccolumn) != 0)
											{
												value = Objects.toString(summap.get(dynamiccolumn), "");
											}
											xml.append("	<w:tc>");
											xml.append("		<w:tcPr>");
											xml.append("			<w:tcW w:w=\""+column.optInt("width")+"\" w:type=\"dxa\"/>");
											xml.append("			<w:vAlign w:val=\"center\"/>");
											xml.append("		</w:tcPr>");
											xml.append("		<w:p>");
											xml.append("			<w:pPr>");
											xml.append("				<w:jc w:val=\"center\"/>");
											xml.append("			</w:pPr>");
											xml.append("			<w:r>");
											xml.append("				<w:t>"+toValue(column, value)+"</w:t>");
											xml.append("			</w:r>");
											xml.append("		</w:p>");
											xml.append("	</w:tc>");								
										}
									}
									else
									{
										String value = "";
										if(summap.get(columnname) != null && summap.get(columnname) != 0)
										{
											value = Objects.toString(summap.get(columnname), "");
										}
										xml.append("	<w:tc>");
										xml.append("		<w:tcPr>");
										xml.append("			<w:tcW w:w=\""+column.optInt("width")+"\" w:type=\"dxa\"/>");
										xml.append("			<w:vAlign w:val=\"center\"/>");
										xml.append("		</w:tcPr>");
										xml.append("		<w:p>");
										xml.append("			<w:pPr>");
										xml.append("				<w:jc w:val=\"center\"/>");
										xml.append("			</w:pPr>");
										xml.append("			<w:r>");
										xml.append("				<w:t>"+toValue(column, value)+"</w:t>");
										xml.append("			</w:r>");
										xml.append("		</w:p>");
										xml.append("	</w:tc>");
										
									}
									
								}
					
							}
							xml.append("</w:tr>");
						}
					}
					
					
					xml.append("</w:tbl>");
				}
				
			}
			
			
			xml.append("</w:body>");
			xml.append("</w:wordDocument>");
			
			Data logs = datasource.find("select ID from T_STATEMENT_LOG where SUBSTATEMENT_ID = ? and MODE = ?", substatementId, statementmode);
			if(logs.size() == 0)
			{
				datasource.execute("insert into T_STATEMENT_LOG(ID, SUBSTATEMENT_ID, CREATE_USER_ID, CREATE_DATE, MODE) values(?, ?, ?, datetime('now','localtime'), ?)", SystemUtils.uuid(), substatementId, sessionuser.getId(), statementmode);
			}
			else
			{
				datasource.execute("update T_STATEMENT_LOG set CREATE_USER_ID = ?, CREATE_DATE = datetime('now','localtime') where SUBSTATEMENT_ID = ? and MODE = ?", sessionuser.getId(), substatementId, statementmode);
			}

			connection.commit();
			
		}
		/*
		catch(Exception e)
		{
			Throwable throwable = ThrowableUtils.getThrowable(e);
			warnings.add(throwable.getMessage());
		}
		*/
		finally
		{
			if(connection != null)
			{
				connection.close();
			}
		}
		String name = statementname + (substatementname.equals("") ? "" : "-"+substatementname) + "-" + (statementmode.equals("2") ? "合并" : "单体" ) + ".doc";
		FileUtils.writeStringToFile(new File(SystemProperty.PATH + SystemProperty.FILESEPARATOR + "resource" + SystemProperty.FILESEPARATOR + "report" + SystemProperty.FILESEPARATOR + name), xml.toString(), "UTF-8");
		message.resource("filename", name);
		if(warnings.size() > 0)
		{
			for(String warning : warnings)
			{
				message.message(ServiceMessage.FAILURE, warning);
			}
		}
	}
	else
	{
		message.message(ServiceMessage.FAILURE, "登录用户失效，请重新登录。");
	}
	
	out.println(message);
%>
<%!
public String toValue(JSONObject column, String value) throws JSONException
{
	if(!value.equals(""))
	{
		JSONArray modes = column.optJSONArray("modes");
		if(modes != null)
		{
			if(NumberUtils.toDouble(value, 0) != 0)
			{
				String mode = modes.join(",");
				
				if(mode.indexOf("percent") != -1)
				{
					DecimalFormat decimalFormat = new DecimalFormat("#.00");
					value = decimalFormat.format(NumberUtils.toDouble(value, 0) * 100) + "%";
				}
				
				if(mode.indexOf("money") != -1)
				{
					DecimalFormat format = new DecimalFormat("###,###.00");
					value = format.format(NumberUtils.toDouble(value, 0));
				}
			}
			else
			{
				value = "";
			}
		}
		value = StringUtils.replaceEach(value, new String[]{"<", ">", "&", "'", "\""}, new String[]{"<w:t>&lt;</w:t>", "<w:t>&gt;</w:t>", "<w:t>&amp;</w:t>", "<w:t>&apos;</w:t>", "<w:t>&quot;</w:t>"});
	}
	return value;
}
%>