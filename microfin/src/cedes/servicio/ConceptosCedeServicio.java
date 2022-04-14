package cedes.servicio;

import java.util.List;

import cedes.dao.ConceptosCedeDAO;
import general.servicio.BaseServicio;

public class ConceptosCedeServicio extends BaseServicio{
	
 	public ConceptosCedeServicio () {
		super();
		// TODO Auto-generated constructor stub
	}
	
	//---------- Variables ------------------------------------------------------------------------
	ConceptosCedeDAO conceptosCedeDAO = null;

	//---------- Tipos de Listas---------------------------------------------------------------
	public static interface Enum_Lis_ConceptosCede {
		int conceptosCede   = 1;
	}

	// listas para comboBox
	public  Object[] listaCombo(int tipoLista) {
		List listaConceptosCede = null;
		switch(tipoLista){
			case (Enum_Lis_ConceptosCede.conceptosCede): 
				listaConceptosCede =  conceptosCedeDAO.listaConceptosCedes(tipoLista);
				break;
		}
		return listaConceptosCede.toArray();		
	}

	public ConceptosCedeDAO getConceptosCedeDAO() {
		return conceptosCedeDAO;
	}

	public void setConceptosCedeDAO(ConceptosCedeDAO conceptosCedeDAO) {
		this.conceptosCedeDAO = conceptosCedeDAO;
	}
		

}
