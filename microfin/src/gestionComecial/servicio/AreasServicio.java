package gestionComecial.servicio;

import java.util.List;

import general.servicio.BaseServicio;
import gestionComecial.bean.AreasBean;
import gestionComecial.bean.EmpleadosBean;
import gestionComecial.dao.AreasDAO;
import gestionComecial.dao.EmpleadosDAO;
import gestionComecial.servicio.EmpleadosServicio.Enum_Lis_Empleados;

public class AreasServicio extends BaseServicio {

	private AreasServicio(){
		super();
	}

	AreasDAO areasDAO = null;

	public static interface Enum_Lis_Areas{
		int alfanumerica = 1;
	}
	
	
	public List lista(int tipoLista, AreasBean areas){		
		List listaAreas = null;
		switch (tipoLista) {
			case Enum_Lis_Areas.alfanumerica:		
				listaAreas=  areasDAO.listaAlfanumerica(areas, Enum_Lis_Areas.alfanumerica);				
				break;	
		}		
		return listaAreas;
	}
	
		
	public void setAreasDAO(AreasDAO areasDAO ){
		this.areasDAO = areasDAO;
	}

	public AreasDAO getAreasDAO() {
		return areasDAO;
	}

}
