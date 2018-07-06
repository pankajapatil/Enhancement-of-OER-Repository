/**
 * The contents of this file are subject to the license and copyright
 * detailed in the LICENSE and NOTICE files at the root of the source
 * tree and available online at
 *
 * http://www.dspace.org/license/
 */
package org.dspace.eperson;

import java.sql.SQLException;
import java.util.List;

import org.apache.log4j.Logger;
import org.dspace.authorize.AuthorizeException;
import org.dspace.authorize.service.AuthorizeService;
import org.dspace.content.Collection;
import org.dspace.content.service.CollectionService;
import org.dspace.core.Constants;
import org.dspace.core.Context;
import org.dspace.core.LogManager;
import org.dspace.eperson.dao.MycourseDAO;
import org.dspace.eperson.service.MycourseService;
import org.springframework.beans.factory.annotation.Autowired;

/**
 * Class defining methods for sending new item e-mail alerts to users
 *
 * @author Robert Tansley
 * @version $Revision$
 */
public class MycourseServiceImpl implements MycourseService
{
    /** log4j logger */
    private Logger log = Logger.getLogger(MycourseServiceImpl.class);

    @Autowired(required = true)
    protected MycourseDAO mycourseDAO;

    @Autowired(required = true)
    protected AuthorizeService authorizeService;
    @Autowired(required = true)
    protected CollectionService collectionService;

  public MycourseServiceImpl()
    {

    }

    @Override
    public List<Mycourse> findAll(Context context) throws SQLException {
        return mycourseDAO.findAllOrderedByEPerson(context);
    }

    @Override
    public void addCourse(Context context, EPerson eperson,
            Collection collection) throws SQLException, AuthorizeException
    {
        // Check authorisation. Must be administrator, or the eperson.
        if (authorizeService.isAdmin(context)
                || ((context.getCurrentUser() != null) && (context
                        .getCurrentUser().getID().equals(eperson.getID()))))
        {
            if (!isSubscribed(context, eperson, collection)) {
                Mycourse mycourse = mycourseDAO.create(context, new Mycourse());
                mycourse.setCollection(collection);
                mycourse.setePerson(eperson);
            }
        }
        else
        {
            throw new AuthorizeException(
                    "Only admin or e-person themselves can subscribe");
        }
    }

    @Override
    public void unsubscribe(Context context, EPerson eperson,
            Collection collection) throws SQLException, AuthorizeException
    {
        // Check authorisation. Must be administrator, or the eperson.
        if (authorizeService.isAdmin(context)
                || ((context.getCurrentUser() != null) && (context
                        .getCurrentUser().getID().equals(eperson.getID()))))
        {
            if (collection == null)
            {
                // Unsubscribe from all
                mycourseDAO.deleteByEPerson(context, eperson);
            }
            else
            {
                mycourseDAO.deleteByCollectionAndEPerson(context, collection, eperson);

                log.info(LogManager.getHeader(context, "unsubscribe",
                        "eperson_id=" + eperson.getID() + ",collection_id="
                                + collection.getID()));
            }
        }
        else
        {
            throw new AuthorizeException(
                    "Only admin or e-person themselves can unsubscribe");
        }
    }

    @Override
    public List<Mycourse> getMycourses(Context context, EPerson eperson)
            throws SQLException
    {
        return mycourseDAO.findByEPerson(context, eperson);
    }

    @Override
    public List<Collection> getAvailableMycourses(Context context)
            throws SQLException
    {
        return getAvailableMycourses(context, null);
    }
    
    @Override
    public List<Collection> getAvailableMycourses(Context context, EPerson eperson)
            throws SQLException
    {
        List<Collection> collections;
        if (eperson != null)
        {
            context.setCurrentUser(eperson);
        }
        collections = collectionService.findAuthorized(context, null, Constants.ADD);

        return collections;
    }

    @Override
    public boolean isSubscribed(Context context, EPerson eperson,
            Collection collection) throws SQLException
    {
        return mycourseDAO.findByCollectionAndEPerson(context, eperson, collection) != null;
    }

    @Override
    public void deleteByCollection(Context context, Collection collection) throws SQLException {
        mycourseDAO.deleteByCollection(context, collection);
    }

    @Override
    public void deleteByEPerson(Context context, EPerson ePerson) throws SQLException {
        mycourseDAO.deleteByEPerson(context, ePerson);
    }
}
