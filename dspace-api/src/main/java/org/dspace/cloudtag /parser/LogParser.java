package org.dspace.cloudtag.parser;
import java.io.*;
import java.util.*;
public class LogParser
{
	public void main(String args[]) throws IOException
	{
		String path = args[0];
		File folder = new File(path);
		File[] listOfFiles = folder.listFiles();
		System.setOut(new PrintStream(new File("/home/dspace/dspace-6.2-src-release/dspace-jspui/src/main/webapp/parse/Input/LogDoc")));

		for (File file : listOfFiles) 
		{
	    	if (file.isFile())
			{
				
				try(BufferedReader br  = new BufferedReader(new FileReader(file)))
				{

					String line = br.readLine();
 
					while(line != null)
					{
						String[] splited = line.split(":");
						int len = splited.length;

	
						if(len > 6 && splited[3].startsWith("se") && splited[6].startsWith("scope=null,query"))
						{

							int start = splited[6].indexOf("=\"");
							int end = splited[6].indexOf("\",re");
							String term = splited[6].substring(start+2,end);
							term = term.replaceAll(" ", "");
							System.out.printf("%s ",term);
						}
						
						line = br.readLine();
					}
    			}
			}
		}
	}
}
