package aportaciones.servicio;

import java.util.List;

import aportaciones.dao.ConceptosAportacionDAO;
import general.servicio.BaseServicio;

public class ConceptosAportacionServicio extends BaseServicio{
	
	public ConceptosAportacionServicio () {
		super();
	}
	
	ConceptosAportacionDAO conceptosAportacionDAO = null;
	
	public static interface Enum_Lis_ConceptosAportacion {
		int conceptosAportacion   = 1;
	}
	
	// listas para comboBox
		public  Object[] listaCombo(int tipoLista) {
			List listaConceptosAportacion = null;
			switch(tipoLista){
				case (Enum_Lis_ConceptosAportacion.conceptosAportacion): 
					listaConceptosAportacion =  conceptosAportacionDAO.listaConceptosAportaciones(tipoLista);
					break;
			}
			return listaConceptosAportacion.toArray();		
		}

	public ConceptosAportacionDAO getConceptosAportacionDAO() {
		return conceptosAportacionDAO;
	}

	public void setConceptosAportacionDAO(
		ConceptosAportacionDAO conceptosAportacionDAO) {
		this.conceptosAportacionDAO = conceptosAportacionDAO;
	}
	
	
	
}
