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
import org.dspace.content.Rating;
import org.dspace.content.dao.RatingDAO;
import org.dspace.content.dao.impl.RatingDAOImpl;
import org.dspace.content.service.CollectionService;
import org.dspace.content.CollectionServiceImpl;
import java.util.List;
import java.lang.Integer;
import org.dspace.content.factory.ContentServiceFactory;
import org.dspace.content.factory.ContentServiceFactoryImpl;

import com.sun.mail.smtp.SMTPAddressFailedException;


import org.dspace.handle.dao.impl.HandleDAOImpl;
import org.dspace.handle.Handle;
import org.dspace.content.dao.impl.MetadataValueDAOImpl;
import org.dspace.content.MetadataValue;
import org.dspace.content.DSpaceObject;
import org.dspace.handle.factory.HandleServiceFactory;
import org.dspace.handle.service.HandleService;
import org.dspace.content.Item;
import java.lang.Class;

import org.dspace.app.webui.servlet.HandleServlet;

public class RatingServlet extends DSpaceServlet
{

	HandleService handleService = HandleServiceFactory.getInstance().getHandleService();

	protected void doDSGet(Context context, HttpServletRequest request,
            HttpServletResponse response) throws ServletException, IOException,
            SQLException, AuthorizeException
	{
		
		Integer r=Integer.parseInt(request.getParameter("radio-value2"));
		//String r=request.getParameter("radio-value2");
		EPerson e=context.getCurrentUser();
		String handle=request.getParameter("handle");
		
		if (e == null)
			JSPManager.showJSP(request, response,
                        "/login/password.jsp");
		DSpaceObject dso = null;
		if (handle != null)
		{
		    dso = handleService.resolveToObject(context, handle);
		   
		}		
		
		Item i=(Item)dso;
		//request.setAttribute("r",r);
		
		RatingDAOImpl ratingDAO=new RatingDAOImpl();
		if(!(ratingDAO.findByItemAndEPerson(context, e, i) != null))
		{	Rating rating = ratingDAO.create(context, new Rating());
			rating.setItem(i);
			rating.setePerson(e);
			rating.setratingValue(r);
				
		}
		JSPManager.showJSP(request, response,
                        "/rating.jsp");
		
		
			
		
	}
	protected void doDSPost(Context context, HttpServletRequest request,
            HttpServletResponse response) throws ServletException, IOException,
            SQLException, AuthorizeException
	{

	}
}

