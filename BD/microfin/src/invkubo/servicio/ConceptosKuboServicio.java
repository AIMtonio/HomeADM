package invkubo.servicio;

import java.util.List;

import tesoreria.servicio.ConceptosDivServicio.Enum_Lis_ConceptosDiv;
import invkubo.dao.ConceptosKuboDAO;
import general.servicio.BaseServicio;

public class ConceptosKuboServicio extends BaseServicio{
	
	//---------- Variables ------------------------------------------------------------------------

	ConceptosKuboDAO conceptosKuboDAO = null;

	public ConceptosKuboServicio() {
		super();
	}
	
	//---------- Tipos de Listas---------------------------------------------------------------
	public static interface Enum_Lis_ConceptosKubo {
		int conceptosKubo   = 1;
	}
	

	// listas para comboBox
	public  Object[] listaCombo(int tipoLista) {
		List listaConceptosKubo = null;
		switch(tipoLista){
			case Enum_Lis_ConceptosKubo.conceptosKubo: 
				listaConceptosKubo =  conceptosKuboDAO.listaConceptosKubo(tipoLista);
				break;
		}
		return listaConceptosKubo.toArray();		
	}
	
	
	
	//------------------ Geters y Seters ------------------------------------------------------	

	public ConceptosKuboDAO getConceptosKuboDAO() {
		return conceptosKuboDAO;
	}

	public void setConceptosKuboDAO(ConceptosKuboDAO conceptosKuboDAO) {
		this.conceptosKuboDAO = conceptosKuboDAO;
	}
	
	
	

}
