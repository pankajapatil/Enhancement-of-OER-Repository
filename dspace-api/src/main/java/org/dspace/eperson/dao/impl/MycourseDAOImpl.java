/**
 * The contents of this file are subject to the license and copyright
 * detailed in the LICENSE and NOTICE files at the root of the source
 * tree and available online at
 *
 * http://www.dspace.org/license/
 */
package org.dspace.eperson.dao.impl;

import org.dspace.content.Collection;
import org.dspace.content.MetadataValue;
import org.dspace.core.Context;
import org.dspace.core.AbstractHibernateDAO;
import org.dspace.eperson.EPerson;
import org.dspace.eperson.Mycourse;
import org.dspace.eperson.dao.MycourseDAO;
import org.hibernate.Criteria;
import org.hibernate.Query;
import org.hibernate.criterion.Order;
import org.hibernate.criterion.Restrictions;
import org.hibernate.SQLQuery;
import org.hibernate.Session;

import java.sql.SQLException;
import java.util.List;


/**
 * Hibernate implementation of the Database Access Object interface class for the Mycourse object.
 * This class is responsible for all database calls for the Mycourse object and is autowired by spring
 * This class should never be accessed directly.
 *
 * @author kevinvandevelde at atmire.com
 */
public class MycourseDAOImpl extends AbstractHibernateDAO<Mycourse> implements MycourseDAO
{
    public MycourseDAOImpl()
    {
        super();
    }

	public  List<Integer> func(Context context,EPerson e) throws SQLException
	{
		Session session=getHibernateSession(context);
		SQLQuery query = session.createSQLQuery("select recommend1('"+e.getEmail()+"')");
	//	SQLQuery query = session.createSQLQuery("select recommend1('prasadbu33@gmail.com')");
		List<Integer> rows = query.list();

		SQLQuery query1 = session.createSQLQuery("select wordcloud()");
		List<Integer> rows1 = query1.list();
		return rows;
	}

	public  List<Integer> func1(Context context) throws SQLException
	{
		Session session=getHibernateSession(context);

		SQLQuery query = session.createSQLQuery("select wordcloud()");
		List<Integer> rows = query.list();
		return rows;
	}

	

    @Override
    public List<Mycourse> findByEPerson(Context context, EPerson eperson) throws SQLException {
        Criteria criteria = createCriteria(context, Mycourse.class);
        criteria.add(
                Restrictions.and(
                        Restrictions.eq("ePerson", eperson)
                )
        );
        return list(criteria);

    }

    @Override
    public Mycourse findByCollectionAndEPerson(Context context, EPerson eperson, Collection collection) throws SQLException {
        Criteria criteria = createCriteria(context, Mycourse.class);
        criteria.add(
                Restrictions.and(
                        Restrictions.eq("ePerson", eperson),
                        Restrictions.eq("collection", collection)
                )
        );
        return singleResult(criteria);
    }


    @Override
    public void deleteByCollection(Context context, Collection collection) throws SQLException {
        String hqlQuery = "delete from Mycourse where collection=:collection";
        Query query = createQuery(context, hqlQuery);
        query.setParameter("collection", collection);
        query.executeUpdate();
    }

    @Override
    public void deleteByEPerson(Context context, EPerson eperson) throws SQLException {
        String hqlQuery = "delete from Mycourse where ePerson=:ePerson";
        Query query = createQuery(context, hqlQuery);
        query.setParameter("ePerson", eperson);
        query.executeUpdate();
    }

    @Override
    public void deleteByCollectionAndEPerson(Context context, Collection collection, EPerson eperson) throws SQLException {
        String hqlQuery = "delete from Mycourse where collection=:collection AND ePerson=:ePerson";
        Query query = createQuery(context, hqlQuery);
        query.setParameter("collection", collection);
        query.setParameter("ePerson", eperson);
        query.executeUpdate();
    }

    @Override
    public List<Mycourse> findAllOrderedByEPerson(Context context) throws SQLException {
        Criteria criteria = createCriteria(context, Mycourse.class);
        criteria.addOrder(Order.asc("eperson.id"));
        return list(criteria);
    }
}
