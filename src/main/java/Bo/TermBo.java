package Bo;

import Dao.TermDao;
import Bean.Term;
import java.util.List;

public class TermBo {
    private TermDao termDao = new TermDao();

    public List<Term> getTermsByProfessor(int professorId) {
        return termDao.getTermsByProfessor(professorId);
    }

    public Term getTermById(int termId) {
        return termDao.getTermById(termId);
    }

    public boolean createTerm(String name, int professorId) {
        // Validate
        if (name == null || name.isEmpty()) {
            return false;
        }

        Term term = new Term();
        term.setName(name);
        term.setProfessorId(professorId);

        return termDao.createTerm(term) > 0;
    }

    public boolean updateTerm(int termId, String name, int professorId) {
        // Check if term belongs to professor
        if (!termDao.isTermBelongsToProfessor(termId, professorId)) {
            return false;
        }

        // Validate
        if (name == null || name.isEmpty()) {
            return false;
        }

        Term term = new Term();
        term.setId(termId);
        term.setName(name);
        term.setProfessorId(professorId);

        return termDao.updateTerm(term);
    }

    public boolean deleteTerm(int termId, int professorId) {
        // Check if term belongs to professor
        if (!termDao.isTermBelongsToProfessor(termId, professorId)) {
            return false;
        }

        return termDao.deleteTerm(termId);
    }
}
