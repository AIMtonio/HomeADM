package arrendamiento.servicio;

import arrendamiento.bean.SubCtaPlazoArrendaBean;
import arrendamiento.dao.SubCtaPlazoArrendaDAO;

import general.servicio.BaseServicio;

public class SubCtaPlazoArrendaServicio extends BaseServicio {

	//---------- Variables ------------------------------------------------------------------------
	SubCtaPlazoArrendaDAO subCtaPlazoArrendaDAO = null;			   

	//---------- Tipo de Consulta ----------------------------------------------------------------
	public static interface Enum_Con_Arrenda {
		int principal = 1;
	}

	//---------- Tipo de Lista ----------------------------------------------------------------
	public static interface Enum_Lis_Arrenda {
		int principal = 1;
	}
	
	public SubCtaPlazoArrendaServicio() {
		super();
		// TODO Auto-generated constructor stub
	}	
	
	
	public SubCtaPlazoArrendaBean consulta(int tipoConsulta, SubCtaPlazoArrendaBean subCtaPlazoArrendaBean){
		SubCtaPlazoArrendaBean resultado = null;
		switch (tipoConsulta) {
			case Enum_Con_Arrenda.principal:		
				resultado = subCtaPlazoArrendaDAO.consultaPrincipal(subCtaPlazoArrendaBean, tipoConsulta);				
				break;	
		}	
		return resultado;
	}

	
	//------------------ Geters y Seters ------------------------------------------------------	

	public SubCtaPlazoArrendaDAO getSubCtaPlazoArrendaDAO() {
		return subCtaPlazoArrendaDAO;
	}


	public void setSubCtaPlazoArrendaDAO(SubCtaPlazoArrendaDAO subCtaPlazoArrendaDAO) {
		this.subCtaPlazoArrendaDAO = subCtaPlazoArrendaDAO;
	}


}


