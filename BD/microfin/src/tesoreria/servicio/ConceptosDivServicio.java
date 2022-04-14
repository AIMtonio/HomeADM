package tesoreria.servicio;



import java.util.List;

import tesoreria.dao.ConceptosDivDAO;

import general.servicio.BaseServicio;

public class ConceptosDivServicio extends BaseServicio{
	//---------- Variables ------------------------------------------------------------------------
	ConceptosDivDAO conceptosDivDAO = null;
	
	public ConceptosDivServicio () {
		super();
		
	}

	//---------- Tipos de Listas---------------------------------------------------------------
	public static interface Enum_Lis_ConceptosDiv {
		int conceptosDiv   = 1;
	}

	

	
	// listas para comboBox
	public  Object[] listaCombo(int tipoLista) {
		List listaConceptosDiv = null;
		switch(tipoLista){
			case (Enum_Lis_ConceptosDiv.conceptosDiv): 
				listaConceptosDiv =  conceptosDivDAO.listaConceptosDiv(tipoLista);
				break;
		}
		return listaConceptosDiv.toArray();		
	}


	//------------------ Geters y Seters ------------------------------------------------------	
	

	public ConceptosDivDAO getConceptosDivDAO() {
		return conceptosDivDAO;
	}


	public void setConceptosDivDAO(ConceptosDivDAO conceptosDivDAO) {
		this.conceptosDivDAO = conceptosDivDAO;
	}
	
}
