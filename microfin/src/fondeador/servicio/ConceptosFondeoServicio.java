package fondeador.servicio;

import fondeador.bean.ConceptosFondeoBean;
import fondeador.dao.ConceptosFondeoDAO;
import general.servicio.BaseServicio;

import java.util.List;


public class ConceptosFondeoServicio extends BaseServicio{

	
	//---------- Variables ------------------------------------------------------------------------
	ConceptosFondeoDAO conceptosFondeoDAO = null;

	//---------- Tipos de Listas---------------------------------------------------------------
	public static interface Enum_Lis_ConceptosAhorro {
		int conceptosAhorro   = 1;
	}

	public ConceptosFondeoServicio () {
		super();
		// TODO Auto-generated constructor stub
	}
	
	public List lista(int tipoLista, ConceptosFondeoBean monedas){		
		List listaConceptosFondeo = null;
		switch (tipoLista) {
			case Enum_Lis_ConceptosAhorro.conceptosAhorro:		
				listaConceptosFondeo=  conceptosFondeoDAO.listaConceptosFondeo(tipoLista);				
				break;				
		}		
		return listaConceptosFondeo;
	}
	
	// listas para comboBox
	public  Object[] listaCombo(int tipoLista) {
		List listaConceptosFondeo = null;
		switch(tipoLista){
			case (Enum_Lis_ConceptosAhorro.conceptosAhorro): 
				listaConceptosFondeo =  conceptosFondeoDAO.listaConceptosFondeo(tipoLista);
				break;
		}
		return listaConceptosFondeo.toArray();		
	}
	
	//------------------ Geters y Seters ------------------------------------------------------	
	public void setConceptosFondeoDAO(ConceptosFondeoDAO conceptosFondeoDAO) {
		this.conceptosFondeoDAO = conceptosFondeoDAO;
	}	
}
