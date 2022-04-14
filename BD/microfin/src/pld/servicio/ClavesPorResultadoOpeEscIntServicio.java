package pld.servicio;

import general.servicio.BaseServicio;

import java.util.List;

import pld.bean.ClavesPorResultadoOpeEscIntBean;
import pld.dao.ClavesPorResultadoOpeEscIntDAO;

public class ClavesPorResultadoOpeEscIntServicio extends BaseServicio{
	
	//------------Constantes------------------
	
	//---------- Variables ------------------------------------------------------------------------
	ClavesPorResultadoOpeEscIntDAO  clavesPorResultadoOpeEscIntDAO = null;			   

	//---------- Tipo de Consulta ----------------------------------------------------------------
	public static interface Enum_Con_ClavesPorResultadoOpeEscInt {
		int principal = 1;
		
	}

	//---------- Tipo de Lista ----------------------------------------------------------------
	public static interface Enum_Lis_ClavesPorResultadoOpeEscInt {
		int principal = 1;
		
	}

	//---------- Constructor ------------------------------------------------------------------------
	public ClavesPorResultadoOpeEscIntServicio() {
		super();
	}

	// listas para comboBox
	public  Object[] listaCombo(int tipoLista, ClavesPorResultadoOpeEscIntBean clavesPorResultadoOpeEscIntBean) {
		
		List clavesPorResultado = null;
		
		switch(tipoLista){
			case (Enum_Lis_ClavesPorResultadoOpeEscInt.principal):
				
				clavesPorResultado =  clavesPorResultadoOpeEscIntDAO.listaPrincipal(
													clavesPorResultadoOpeEscIntBean,
													tipoLista);
				break;
			
		}
		
		return clavesPorResultado.toArray();
	}

	
	//------------------ Geters y Seters ------------------------------------------------------
	
	public ClavesPorResultadoOpeEscIntDAO getClavesPorResultadoOpeEscIntDAO() {
		return clavesPorResultadoOpeEscIntDAO;
	}

	public void setClavesPorResultadoOpeEscIntDAO(
			ClavesPorResultadoOpeEscIntDAO clavesPorResultadoOpeEscIntDAO) {
		this.clavesPorResultadoOpeEscIntDAO = clavesPorResultadoOpeEscIntDAO;
	}
	


}
