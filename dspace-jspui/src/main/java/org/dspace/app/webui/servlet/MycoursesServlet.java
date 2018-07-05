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
import org.dspace.core.LogManager;
import org.dspace.eperson.EPerson;
import org.dspace.eperson.service.EPersonService;
import org.dspace.eperson.factory.EPersonServiceFactory;
import org.dspace.eperson.service.AccountService;

import org.dspace.content.Collection;
import org.dspace.content.Item;
import org.dspace.content.service.ItemService;
import org.dspace.eperson.Mycourse;
import org.dspace.eperson.dao.MycourseDAO;
import org.dspace.eperson.dao.impl.MycourseDAOImpl;
import org.dspace.content.service.CollectionService;
import org.dspace.content.CollectionServiceImpl;
import java.util.List;
import org.dspace.content.factory.ContentServiceFactory;
import org.dspace.content.factory.ContentServiceFactoryImpl;

import com.sun.mail.smtp.SMTPAddressFailedException;

import java.io.*;
import java.util.*;

import org.dspace.handle.dao.impl.HandleDAOImpl;
import org.dspace.handle.Handle;
import org.dspace.content.dao.impl.MetadataValueDAOImpl;
import org.dspace.content.MetadataValue;

public class MycoursesServlet extends DSpaceServlet
{
	protected void doDSGet(Context context, HttpServletRequest request,
            HttpServletResponse response) throws ServletException, IOException,
            SQLException, AuthorizeException
	{
		
		/*HandleDAOImpl h=new HandleDAOImpl();
		
		List<Handle> han=h.findAll(context);
		request.setAttribute("handle",han);
		MetadataValueDAOImpl mtt=new MetadataValueDAOImpl();
		List<MetadataValue> mt=mtt.findAll(context);
		request.setAttribute("mt",mt);
		JSPManager.showJSP(request, response,
                        "/course-added.jsp");*/
	
		//MycoursesDAO m=new MycoursesDAO();
		CollectionService collectionService = ContentServiceFactory.getInstance().getCollectionService();
	   	//List<Collection> e = collectionService.findAll(context);
		//request.setAttribute("collection", e);
		//MycourseDAOImpl mycourseDAO=new MycourseDAOImpl();
		if(context.getCurrentUser()==null)
			JSPManager.showJSP(request, response,
                        "/login/password.jsp");
		List<Collection> m =collectionService.findMycourses(context,context.getCurrentUser());

		ItemService itemService = ContentServiceFactory.getInstance().getItemService();
		String fileName="/home/dspace/Downloads/postgre/out1.txt";
		String line = null;
		//List<String> i=new ArrayList<String>();
		List<Item> items=new ArrayList<Item>();
		Item it;
		UUID u;
		FileReader fileReader = new FileReader(fileName);
		BufferedReader bufferedReader =  new BufferedReader(fileReader);
		while((line = bufferedReader.readLine()) != null) {
		       u=UUID.fromString(line.toString());
		       it=itemService.find(context,u);	
		       items.add(it);
			//i.add(line);
		    } 
		bufferedReader.close(); 

		request.setAttribute("items",items);
		//List<Double> rating=collectionService.average(context,(Collection) IteratorUtils.get(m, 0));
		request.setAttribute("mycourse",m);
		/*request.setAttribute("rating",rating);
		JSPManager.showJSP(request, response,
                        "/course-added.jsp");*/
		JSPManager.showJSP(request, response,
                        "/mycourses.jsp");
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

