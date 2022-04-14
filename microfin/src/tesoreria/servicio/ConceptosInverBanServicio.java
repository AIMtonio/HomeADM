package tesoreria.servicio;
import general.servicio.BaseServicio;

import java.util.List;

import tesoreria.dao.ConceptosInverBanDAO;

public class ConceptosInverBanServicio extends BaseServicio {

	/** Variables **/
	ConceptosInverBanDAO conceptosInverBanDAO = null;

	/** Tipos de lista **/
	public static interface Enum_Lis_ConceptosInver {
		int conceptosInver = 1;
	}

	public ConceptosInverBanServicio() {
		super();
	}

	public Object[] listaCombo(int tipoLista) {
		List listaConceptosInver = null;
		switch (tipoLista) {
		case (Enum_Lis_ConceptosInver.conceptosInver):
			listaConceptosInver = conceptosInverBanDAO.listaConceptosInver(tipoLista);
			break;
		}
		return listaConceptosInver.toArray();
	}

	public ConceptosInverBanDAO getConceptosInverBanDAO() {
		return conceptosInverBanDAO;
	}

	public void setConceptosInverBanDAO(ConceptosInverBanDAO conceptosInverBanDAO) {
		this.conceptosInverBanDAO = conceptosInverBanDAO;
	}

}