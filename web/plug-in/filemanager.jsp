<%@page import="java.net.URLEncoder"%>
<%@page import="java.io.OutputStream"%>
<%@page import="java.io.FileInputStream"%>
<%@page import="java.io.InputStream"%>
<%@page import="com.system.SystemProperty"%>
<%@page import="java.io.File"%>
<%@page import="org.apache.commons.fileupload.servlet.ServletFileUpload"%>
<%@page import="org.apache.commons.fileupload.disk.DiskFileItemFactory"%>
<%@page import="java.util.List"%>
<%@page import="org.apache.commons.fileupload.FileItem"%>
<%@page contentType="text/html; charset=utf-8"%>

<%
	String folder = request.getParameter("folder");
	if (folder == null || folder.equals(""))
	{
		out.println("folder is null");
		return;
	}
	String action = request.getParameter("action");
	if(action == null)
	{
		action = "up";
	}

	String path = SystemProperty.PATH + SystemProperty.FILESEPARATOR + folder;
	if(folder.indexOf(":") != -1)
	{
		path = folder;
	}
	
	if(action.equals("up"))
	{
		String name = request.getParameter("name");
		File file = new File(path);
		if (!file.exists())
		{
			file.mkdirs();
		}
        DiskFileItemFactory factory = new DiskFileItemFactory();  
        factory.setSizeThreshold(1 * 1024 * 1024);
		
		ServletFileUpload sfu = new ServletFileUpload(factory);
		try
		{
			List<?> fileList = sfu.parseRequest(request);
			for (int i = 0; i < fileList.size(); i++)
			{
				FileItem fileItem = (FileItem) fileList.get(i);
				if (!fileItem.isFormField())
				{
					String fileName = fileItem.getName();
					if(name != null)
					{
						fileName = name;
					}
					File f = new File(path, fileName);
					fileItem.write(f);
				}
			}
		}
		catch (Exception e)
		{
			e.printStackTrace();
		}
	}
	else if(action.equals("del"))
	{
		String name = request.getParameter("name");
		if (name == null || name.equals(""))
		{
			out.println("file name is null");
			return;
		}
		File file = new File(path, name);
		if(file != null)
		{
			if(file.exists())
			{
				file.delete();
			}
		}
	}
	else if(action.equals("download"))
	{
        String filename = request.getParameter("filename");  
        
    	FileInputStream input = null;
    	OutputStream output = null;
    	try
    	{
    		response.reset();
    		response.setContentType("application/x-download");
    		File file = new File(path + SystemProperty.FILESEPARATOR + filename);
    		int size = 2048;
    		input = new FileInputStream(file);
    		long length = file.length();
    		long k = 0;
    		byte abyte[] = new byte[size];
    		String fileName = file.getName();
    		response.setHeader("Content-Disposition", "attachment; filename="+ new String(fileName.getBytes("gb2312"), "ISO8859-1"));
    		response.setContentLength((int)length);
    		output = response.getOutputStream();
    		while( k < length )
    		{
    			int j = input.read(abyte, 0, size);
    			k += j;
    			output.write(abyte, 0, j);
    		}
    	}
    	catch (Exception e)
    	{
    		e.printStackTrace();
    	}
    	finally
    	{
    		if(output != null)
    			output.close();
    		if(input != null)
    			input.close();
    	}

    	out.clear();
    	out = pageContext.pushBody();
	}
%>