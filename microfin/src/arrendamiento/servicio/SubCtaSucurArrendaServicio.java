package arrendamiento.servicio;

import arrendamiento.bean.SubCtaSucurArrendaBean;
import arrendamiento.dao.SubCtaSucurArrendaDAO;

import general.servicio.BaseServicio;

public class SubCtaSucurArrendaServicio extends BaseServicio {

	//---------- Variables ------------------------------------------------------------------------
	SubCtaSucurArrendaDAO subCtaSucurArrendaDAO = null;			   

	//---------- Tipo de Consulta ----------------------------------------------------------------
	public static interface Enum_Con_Arrenda {
		int principal = 1;
	}

	//---------- Tipo de Lista ----------------------------------------------------------------
	public static interface Enum_Lis_Arrenda {
		int principal = 1;
	}
	
	public SubCtaSucurArrendaServicio() {
		super();
		// TODO Auto-generated constructor stub
	}	
	
	
	public SubCtaSucurArrendaBean consulta(int tipoConsulta, SubCtaSucurArrendaBean subCtaSucurArrendaBean){
		SubCtaSucurArrendaBean resultado = null;
		switch (tipoConsulta) {
			case Enum_Con_Arrenda.principal:		
				resultado = subCtaSucurArrendaDAO.consultaPrincipal(subCtaSucurArrendaBean, tipoConsulta);				
				break;	
		}	
		return resultado;
	}



	
	//------------------ Geters y Seters ------------------------------------------------------	


	public SubCtaSucurArrendaDAO getSubCtaSucurArrendaDAO() {
		return subCtaSucurArrendaDAO;
	}


	public void setSubCtaSucurArrendaDAO(SubCtaSucurArrendaDAO subCtaSucurArrendaDAO) {
		this.subCtaSucurArrendaDAO = subCtaSucurArrendaDAO;
	}


			
}


