package inversiones.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

import java.util.List;

import inversiones.bean.ConceptosInverBean;
import inversiones.dao.ConceptosInverDAO;
import inversiones.servicio.ConceptosInverServicio.Enum_Lis_ConceptosInver;

public class ConceptosInverServicio  extends BaseServicio {
	
	//---------- Variables ------------------------------------------------------------------------
	ConceptosInverDAO conceptosInverDAO = null;

	//---------- Tipos de Listas---------------------------------------------------------------
	public static interface Enum_Lis_ConceptosInver {
		int conceptosInver   = 1;
	}

	public ConceptosInverServicio () {
		super();
		// TODO Auto-generated constructor stub
	}

	
	// listas para comboBox
	public  Object[] listaCombo(int tipoLista) {
		List listaConceptosInver = null;
		switch(tipoLista){
			case (Enum_Lis_ConceptosInver.conceptosInver): 
				listaConceptosInver =  conceptosInverDAO.listaConceptosInver(tipoLista);
				break;
		}
		return listaConceptosInver.toArray();		
	}
	
	//------------------ Geters y Seters ------------------------------------------------------	
	public void setConceptosInverDAO(ConceptosInverDAO conceptosInverDAO) {
		this.conceptosInverDAO = conceptosInverDAO;
	}	
}
