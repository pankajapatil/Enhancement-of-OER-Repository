package org.dspace.app.webui.servlet;

import java.io.IOException;
import java.sql.SQLException;
import java.util.Hashtable;

import javax.mail.MessagingException;
import javax.mail.internet.AddressException;
import javax.naming.NamingException;
import javax.naming.directory.DirContext;
import javax.naming.directory.InitialDirContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.dspace.app.webui.util.JSPManager;
import org.dspace.app.webui.util.UIUtil;
import org.dspace.authenticate.factory.AuthenticateServiceFactory;
import org.dspace.authenticate.service.AuthenticationService;
import org.dspace.authorize.AuthorizeException;
import org.dspace.core.ConfigurationManager;
import org.dspace.core.Context;
import org.dspace.eperson.Mycourse;
import org.dspace.eperson.dao.MycourseDAO;
import org.dspace.eperson.dao.impl.MycourseDAOImpl;
import org.dspace.services.SessionService;
import org.dspace.services.sessions.SessionRequestServiceImpl;
import org.hibernate.*;
import org.hibernate.Criteria;
import org.hibernate.Query;
import org.hibernate.criterion.Restrictions;
import org.hibernate.SessionFactory;

import org.dspace.eperson.MycourseServiceImpl;
import org.dspace.eperson.service.MycourseService;
import org.dspace.content.Collection;
import org.dspace.eperson.EPerson;
import org.dspace.eperson.factory.EPersonServiceFactory;
import org.dspace.handle.factory.HandleServiceFactory;
import org.dspace.handle.service.HandleService;
import org.dspace.content.DSpaceObject;
import org.dspace.core.LogManager;
import org.apache.commons.lang.StringEscapeUtils;
import static java.lang.System.out;
import org.dspace.app.webui.servlet.MycoursesServlet;

import org.dspace.handle.dao.impl.HandleDAOImpl;
import org.dspace.handle.Handle;
import org.dspace.content.dao.impl.MetadataValueDAOImpl;
import org.dspace.content.MetadataValue;
import java.io.PrintWriter;
import java.io.File;
import java.io.IOException;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import com.sun.mail.smtp.SMTPAddressFailedException;

import java.sql.SQLException;
import java.util.*;

public class Temp extends DSpaceServlet 
{
	private static final Logger log = Logger.getLogger(HandleServlet.class);
    	
	protected void doDSGet(Context context, HttpServletRequest request,
            HttpServletResponse response) throws ServletException, IOException,
            SQLException, AuthorizeException
	{
         	HandleDAOImpl h=new HandleDAOImpl();
		
		List<Handle> han=h.findAll(context);
		
		MetadataValueDAOImpl mtt=new MetadataValueDAOImpl();
		List<MetadataValue> mt=mtt.findAll(context);
		


		File file1 = new File("/home/dspace/dspace-6.2-src-release/dspace-jspui/src/main/webapp/handle1.txt");
        try {
            file1.mkdirs();
            file1.createNewFile();
        } catch (IOException e1) {
            e1.printStackTrace();
        }	
	File file2 = new File("/home/dspace/dspace-6.2-src-release/dspace-jspui/src/main/webapp/meta1.txt");
        try {
            file2.mkdirs();
            file2.createNewFile();
        } catch (IOException e1) {
            e1.printStackTrace();
        }	

	PrintWriter writer1 = new PrintWriter(file1, "UTF-8");
	PrintWriter writer2 = new PrintWriter(file2, "UTF-8");
	for(Handle hn: han)
	{
	
	writer1.println(hn.getHandle());
	writer1.println(hn.getDSpaceObject().getID());
	}
	for(MetadataValue mv: mt)
	{
		
		writer2.println(mv.getValue());
		writer2.println(mv.getDSpaceObject().getID());
	}

	writer1.close();
	writer2.close();
		JSPManager.showJSP(request, response,
                        "/course-added.jsp");

	}

	protected void doDSPost(Context context, HttpServletRequest request,
            HttpServletResponse response) throws ServletException, IOException,
            SQLException, AuthorizeException
	{
		//protected transient EPersonService personService = EPersonServiceFactory.getInstance().getEPersonService();
	 	
	 //  	Eperson e = personService.findByEmail(context, "abc@localhost");
		
		JSPManager.showJSP(request, response,
                        "/register/forgot-password.jsp");
	}
}
