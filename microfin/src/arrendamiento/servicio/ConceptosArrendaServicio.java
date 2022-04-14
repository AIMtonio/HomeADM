package arrendamiento.servicio;

import java.util.List;

import arrendamiento.dao.ConceptosArrendaDAO;

import general.servicio.BaseServicio;

public class ConceptosArrendaServicio extends BaseServicio {

	//---------- Variables ------------------------------------------------------------------------
	ConceptosArrendaDAO conceptosArrendaDAO = null;			   

	//---------- Tipo de Consulta ----------------------------------------------------------------
	public static interface Enum_Con_Arrenda {
		int principal = 1;
	}

	//---------- Tipo de Lista ----------------------------------------------------------------
	public static interface Enum_Lis_Arrenda {
		int principal = 1;
	}
	
	public ConceptosArrendaServicio() {
		super();
		// TODO Auto-generated constructor stub
	}	
	
	
	// listas para comboBox
	public  Object[] listaCombo(int tipoLista) {
		List listaConceptosFondeo = null;
		switch(tipoLista){
			case (Enum_Lis_Arrenda.principal): 
				listaConceptosFondeo =  conceptosArrendaDAO.listaConceptosArrenda(tipoLista);
				break;
		}
		return listaConceptosFondeo.toArray();		
	}
	
	



	
	//------------------ Geters y Seters ------------------------------------------------------	
	public ConceptosArrendaDAO getConceptosArrendaDAO() {
		return conceptosArrendaDAO;
	}


	public void setConceptosArrendaDAO(ConceptosArrendaDAO conceptosArrendaDAO) {
		this.conceptosArrendaDAO = conceptosArrendaDAO;
	}
	

			
}


