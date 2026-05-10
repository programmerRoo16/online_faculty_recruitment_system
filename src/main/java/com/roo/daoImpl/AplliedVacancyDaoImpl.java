package com.roo.daoImpl;

import java.util.List;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.query.Query;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.orm.hibernate5.HibernateTemplate;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import com.roo.dao.AplliedVacancyDao;
import com.roo.pojo.AppliedVacancy;
import com.roo.pojo.Candidate;
import com.roo.pojo.Recruiter;
import com.roo.pojo.Vacancy;

@Component
public class AplliedVacancyDaoImpl implements AplliedVacancyDao{
    @Autowired
	private SessionFactory factory;
	@Autowired
    private HibernateTemplate hibernateTemplate;
	
	@Override
	@Transactional
	public Candidate getCandidate(String email) {
		try {
   		 Session session=factory.getCurrentSession();
       	 String hql="from Candidate c where c.email=: email";
       	 
       	 Query<Candidate> query=session.createQuery(hql, Candidate.class);
       	 query.setParameter("email", email);
       	 Candidate candidate=query.list().get(0);
       	 if(candidate != null)
       	 return candidate;
       	 else
       		 return null;
       				

		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}

	@Override
	@Transactional
	public Recruiter getRecruiter(String email) {
		try {
	   		 Session session=factory.getCurrentSession();
	       	 String hql="from Recruiter r where r.email=: email";
	       	 
	       	 Query<Recruiter> query=session.createQuery(hql, Recruiter.class);
	       	 query.setParameter("email", email);
	       	 Recruiter recruiter=query.list().get(0);
	       	 if(recruiter != null)
	       	 return recruiter;
	       	 else
	       		 return null;
	       				

			} catch (Exception e) {
				e.printStackTrace();
				return null;
			}
	}

	@Override
	@Transactional
	public Vacancy getVacancy(int vacancyId) {
		Session session=factory.getCurrentSession();
		String hql="from Vacancy v where v.vacancyId=:vacancyId";
		Query<Vacancy> query = session.createQuery(hql,Vacancy.class);
		query.setParameter("vacancyId",vacancyId);
		return query.uniqueResult();
	}

	@Override
	@Transactional
	public boolean saveAplliedVacancy(AppliedVacancy appliedVacancy) {
		hibernateTemplate.save(appliedVacancy);
	    return true;
	}
	
	@Transactional
	public List<AppliedVacancy> findByVacancyId(int vacancyId) {
		Session session = factory.getCurrentSession();
		Query<AppliedVacancy> query = session.createQuery(
				"from AppliedVacancy a where a.vacancy.vacancyId=:vacancyId",
				AppliedVacancy.class);
		query.setParameter("vacancyId", vacancyId);
		return query.list();
	}

	

	@Override
	@Transactional
	public List<AppliedVacancy> viewCandidate(Recruiter recruiter) {
		Session session = factory.getCurrentSession();
		Query<AppliedVacancy> query=session.createQuery("from AppliedVacancy a where a.recruiter=:recruiter",AppliedVacancy.class);
		query.setParameter("recruiter", recruiter);
		List<AppliedVacancy> list=query.list();
		return list;
	}

	
    @Transactional
	public AppliedVacancy findById(int id) {
		Session session=factory.getCurrentSession();
		return session.get(AppliedVacancy.class, id);
	}
	@Override
	@Transactional
	public boolean updateStatus(AppliedVacancy appliedVacancy) {
		if(appliedVacancy!=null) {
			hibernateTemplate.update(appliedVacancy);
			return true;
		}else {
		return false;
		}
	}

	
}
