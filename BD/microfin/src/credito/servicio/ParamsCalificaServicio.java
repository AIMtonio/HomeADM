package credito.servicio;
import general.servicio.BaseServicio;

import java.util.List;

import credito.dao.ParamsCalificaDAO;

public class ParamsCalificaServicio extends BaseServicio {
	//---------- Variables ------------------------------------------------------------------------
	ParamsCalificaDAO paramsCalificaDAO = null;

	//---------- Tipod de Consulta ----------------------------------------------------------------
	public static interface Enum_Con_ParamsCal {
		int principal = 1;
		int foranea   = 2;
	}

	public static interface Enum_Lis_ParamsCal {
		int principal = 1;
		int foranea	  = 2;
		int combox	  = 3;
	}

	public ParamsCalificaServicio () {
		super();
		// TODO Auto-generated constructor stub
	}
	
	
	// listas para comboBox
	public  Object[] listaCombo(int tipoConsulta) {
		List listaParams = null;
		switch(tipoConsulta){
			case (Enum_Lis_ParamsCal.combox): 
				listaParams =  paramsCalificaDAO.listaParamsCalificaCombo(tipoConsulta);
				break;		
		}
		
		return listaParams.toArray();		
	}
	//------------------ Geters y Seters ------------------------------------------------------	

	public ParamsCalificaDAO getParamsCalificaDAO() {
		return paramsCalificaDAO;
	}
	public void setParamsCalificaDAO(ParamsCalificaDAO paramsCalificaDAO) {
		this.paramsCalificaDAO = paramsCalificaDAO;
	}

}
