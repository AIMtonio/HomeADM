package arrendamiento.servicio;

import java.util.List;

import arrendamiento.bean.SubCtaTipoArrendaBean;
import arrendamiento.dao.SubCtaTipoArrendaDAO;

import general.servicio.BaseServicio;

public class SubCtaTipoArrendaServicio extends BaseServicio {

	//---------- Variables ------------------------------------------------------------------------
	SubCtaTipoArrendaDAO subCtaTipoArrendaDAO = null;			   

	//---------- Tipo de Consulta ----------------------------------------------------------------
	public static interface Enum_Con_Arrenda {
		int principal = 1;
	}

	//---------- Tipo de Lista ----------------------------------------------------------------
	public static interface Enum_Lis_Arrenda {
		int principal = 1;
	}
	
	public SubCtaTipoArrendaServicio() {
		super();
		// TODO Auto-generated constructor stub
	}	
	
	
	public SubCtaTipoArrendaBean consulta(int tipoConsulta, SubCtaTipoArrendaBean subCtaTipoArrendaBean){
		SubCtaTipoArrendaBean resultado = null;
		switch (tipoConsulta) {
			case Enum_Con_Arrenda.principal:		
				resultado = subCtaTipoArrendaDAO.consultaPrincipal(subCtaTipoArrendaBean, tipoConsulta);				
				break;	
		}	
		return resultado;
	}
	
	//------------------ Geters y Seters ------------------------------------------------------	
	public SubCtaTipoArrendaDAO getSubCtaTipoArrendaDAO() {
		return subCtaTipoArrendaDAO;
	}

	public void setSubCtaTipoArrendaDAO(SubCtaTipoArrendaDAO subCtaTipoArrendaDAO) {
		this.subCtaTipoArrendaDAO = subCtaTipoArrendaDAO;
	}		
}


