/**
 * The contents of this file are subject to the license and copyright
 * detailed in the LICENSE and NOTICE files at the root of the source
 * tree and available online at
 *
 * http://www.dspace.org/license/
 */
package org.dspace.content;

import org.apache.commons.lang.BooleanUtils;
//import org.apache.commons.lang.UUIDUtils;
import org.dspace.content.DSpaceObject;
import org.dspace.content.DSpaceObjectLegacySupport;
import org.dspace.content.Item;
import org.dspace.core.Constants;
import org.dspace.core.Context;
import org.dspace.eperson.factory.EPersonServiceFactory;
import org.dspace.eperson.service.EPersonService;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.proxy.HibernateProxyHelper;

import javax.persistence.*;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.UUID;

/**
 * Class representing  mycourses.
 * 
 * @author David Stuve
 * @version $Revision$
 */
@Entity
@Cacheable
@org.hibernate.annotations.Cache(usage = CacheConcurrencyStrategy.NONSTRICT_READ_WRITE, include = "non-lazy")
@Table(name = "course")
public class Mycourses extends DSpaceObject implements DSpaceObjectLegacySupport
{
    //@Id
 //   @GeneratedValue(strategy = GenerationType.IDENTITY)
  // @Column(name="uuid")
   // private Integer legacyId;

    @Column(name="cuuid")
    private UUID collection_id;

    @Column(name="euuid")
    private UUID eperson_id;
    

    @Override
    public Integer getLegacyId() {
        return 0;
    }
    
   
    
    public UUID getcollection_id() {
        return collection_id;
    }

    public UUID geteperson_id() {
        return eperson_id;
    }

    
    public void setcollection_id(UUID collection_id)
    {
        this.collection_id=collection_id;
    }

    public void seteperson_id(UUID eperson_id)
    {
        this.eperson_id=eperson_id;
    }

     @Override
    public boolean equals(Object obj)
    {
        if (obj == null)
        {
            return false;
        }
        Class<?> objClass = HibernateProxyHelper.getClassWithoutInitializingProxy(obj);
        if (getClass() != objClass)
        {
            return false;
        }
        final Mycourses other = (Mycourses) obj;
        
        if (!this.getcollection_id().equals(other.getcollection_id()))
        {
            return false;
        }
        if (!this.geteperson_id().equals(other.geteperson_id()))
        {
            return false;
        }
        return true;
    }

     @Override
    public int hashCode()
    {
        int hash = 5;
        
        return hash;
    }

     @Override
    public int getType()
    {
        return 0;
    }

    @Override
    public String getName()
    {
        return null;
    }
    
    

    
}
