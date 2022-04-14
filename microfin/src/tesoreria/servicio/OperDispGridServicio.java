package tesoreria.servicio;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import tesoreria.bean.DispersionBean;
import tesoreria.dao.OperDispersionDAO;
import general.servicio.BaseServicio;


public class OperDispGridServicio {
	
	OperDispersionDAO  operDispersionGridDAO = null;
	
	public OperDispGridServicio() {
		super();
	}

	//---------- Tipos de Consultas---------------------------------------------------------------

	public static interface Enum_Con_DispersionGrid {
		int principal = 1;
		int foranea = 2;
	}
	
	//---------- Metodo Lista de movimientos en TESORERIAMOVS Y MOVSCONCILIA ---------------------------------------------------------------

	public List DispersionList(DispersionBean dispersionBean, int tipoConsulta){
		List listaDisp = null;
					 	
	    listaDisp = operDispersionGridDAO.listaDispersionMovs(dispersionBean, tipoConsulta);
 
		return listaDisp;
		
	}


	//------------------ Geters y Seters ------------------------------------------------------	
	public void setOperDispersionDAO(OperDispersionDAO operDispersionDAO) {
		this.operDispersionGridDAO = operDispersionDAO;
	}

}
