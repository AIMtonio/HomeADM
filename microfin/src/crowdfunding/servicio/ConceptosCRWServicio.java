package crowdfunding.servicio;

import general.servicio.BaseServicio;

import java.util.List;

import crowdfunding.dao.ConceptosCRWDAO;

public class ConceptosCRWServicio extends BaseServicio{

	ConceptosCRWDAO conceptosCRWDAO = null;

	public ConceptosCRWServicio() {
		super();
	}

	public static interface Enum_Lis_ConceptosCRW {
		int conceptosCRW   = 1;
	}

	public  Object[] listaCombo(int tipoLista) {
		List listaConceptosCRW = null;
		switch(tipoLista){
		case Enum_Lis_ConceptosCRW.conceptosCRW:
			listaConceptosCRW =  conceptosCRWDAO.listaConceptosCRW(tipoLista);
			break;
		}
		return listaConceptosCRW.toArray();
	}

	public ConceptosCRWDAO getConceptosCRWDAO() {
		return conceptosCRWDAO;
	}

	public void setConceptosCRWDAO(ConceptosCRWDAO conceptosCRWDAO) {
		this.conceptosCRWDAO = conceptosCRWDAO;
	}
}