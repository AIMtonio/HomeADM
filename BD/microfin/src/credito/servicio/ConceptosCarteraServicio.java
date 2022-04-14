package credito.servicio;

import java.util.List;

import tesoreria.servicio.ConceptosDivServicio.Enum_Lis_ConceptosDiv;
import credito.dao.ConceptosCarteraDAO;
import general.servicio.BaseServicio;

public class ConceptosCarteraServicio extends BaseServicio{
	
	//---------- Variables ------------------------------------------------------------------------

	ConceptosCarteraDAO conceptosCarteraDAO = null;
	
	public ConceptosCarteraServicio(){
		super();
	}
	
	//---------- Tipos de Listas---------------------------------------------------------------

	public static interface Enum_Lis_ConceptosCart {
		int conceptosCart   = 1;
	}

	// listas para comboBox

	public  Object[] listaCombo(int tipoLista) {
		List listaConceptosCart = null;
		switch(tipoLista){
			case (Enum_Lis_ConceptosCart.conceptosCart): 
				listaConceptosCart =  conceptosCarteraDAO.listaConceptosCartera(tipoLista);
				break;
		}
		return listaConceptosCart.toArray();		
	}

	
	//------------------ Geters y Seters ------------------------------------------------------	

	public ConceptosCarteraDAO getConceptosCarteraDAO() {
		return conceptosCarteraDAO;
	}

	public void setConceptosCarteraDAO(ConceptosCarteraDAO conceptosCarteraDAO) {
		this.conceptosCarteraDAO = conceptosCarteraDAO;
	}

	
	
	
	
	

}
