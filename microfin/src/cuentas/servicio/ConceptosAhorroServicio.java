package cuentas.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

import java.util.List;

import cuentas.bean.ConceptosAhorroBean;
import cuentas.dao.ConceptosAhorroDAO;
import cuentas.servicio.ConceptosAhorroServicio.Enum_Lis_ConceptosAhorro;


public class ConceptosAhorroServicio extends BaseServicio {

	
	//---------- Variables ------------------------------------------------------------------------
	ConceptosAhorroDAO conceptosAhorroDAO = null;

	//---------- Tipos de Listas---------------------------------------------------------------
	public static interface Enum_Lis_ConceptosAhorro {
		int conceptosAhorro   = 1;
	}

	public ConceptosAhorroServicio () {
		super();
		// TODO Auto-generated constructor stub
	}
	
	public List lista(int tipoLista, ConceptosAhorroBean monedas){		
		List listaConceptosAhorro = null;
		switch (tipoLista) {
			case Enum_Lis_ConceptosAhorro.conceptosAhorro:		
				listaConceptosAhorro=  conceptosAhorroDAO.listaConceptosAhorro(tipoLista);				
				break;				
		}		
		return listaConceptosAhorro;
	}
	
	// listas para comboBox
	public  Object[] listaCombo(int tipoLista) {
		List listaConceptosAhorro = null;
		switch(tipoLista){
			case (Enum_Lis_ConceptosAhorro.conceptosAhorro): 
				listaConceptosAhorro =  conceptosAhorroDAO.listaConceptosAhorro(tipoLista);
				break;
		}
		return listaConceptosAhorro.toArray();		
	}
	
	//------------------ Geters y Seters ------------------------------------------------------	
	public void setConceptosAhorroDAO(ConceptosAhorroDAO conceptosAhorroDAO) {
		this.conceptosAhorroDAO = conceptosAhorroDAO;
	}	
}
