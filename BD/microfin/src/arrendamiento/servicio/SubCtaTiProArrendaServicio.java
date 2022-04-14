package arrendamiento.servicio;

import java.util.List;

import arrendamiento.bean.SubCtaTiProArrendaBean;
import arrendamiento.dao.SubCtaTiProArrendaDAO;

import general.servicio.BaseServicio;

public class SubCtaTiProArrendaServicio extends BaseServicio {

	//---------- Variables ------------------------------------------------------------------------
	SubCtaTiProArrendaDAO subCtaTiProArrendaDAO = null;			   

	//---------- Tipo de Consulta ----------------------------------------------------------------
	public static interface Enum_Con_Arrenda {
		int principal = 1;
	}

	//---------- Tipo de Lista ----------------------------------------------------------------
	public static interface Enum_Lis_Arrenda {
		int principal = 1;
	}
	
	public SubCtaTiProArrendaServicio() {
		super();
		// TODO Auto-generated constructor stub
	}	
	
	
	public SubCtaTiProArrendaBean consulta(int tipoConsulta, SubCtaTiProArrendaBean productoArrendaBean){
		SubCtaTiProArrendaBean resultado = null;
		switch (tipoConsulta) {
			case Enum_Con_Arrenda.principal:		
				resultado = subCtaTiProArrendaDAO.consultaPrincipal(productoArrendaBean, tipoConsulta);				
				break;	
		}	
		return resultado;
	}

	
	//------------------ Geters y Seters ------------------------------------------------------	
		public SubCtaTiProArrendaDAO getSubCtaTiProArrendaDAO() {
		return subCtaTiProArrendaDAO;
	}


	public void setSubCtaTiProArrendaDAO(SubCtaTiProArrendaDAO subCtaTiProArrendaDAO) {
		this.subCtaTiProArrendaDAO = subCtaTiProArrendaDAO;
	}
		
}


