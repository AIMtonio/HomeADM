package arrendamiento.servicio;

import arrendamiento.bean.SubCtaMonedaArrendaBean;
import arrendamiento.dao.SubCtaMonedaArrendaDAO;

import general.servicio.BaseServicio;

public class SubCtaMonedaArrendaServicio extends BaseServicio {

	//---------- Variables ------------------------------------------------------------------------
	SubCtaMonedaArrendaDAO subCtaMonedaArrendaDAO = null;			   

	//---------- Tipo de Consulta ----------------------------------------------------------------
	public static interface Enum_Con_Arrenda {
		int principal = 1;
	}

	//---------- Tipo de Lista ----------------------------------------------------------------
	public static interface Enum_Lis_Arrenda {
		int principal = 1;
	}
	
	public SubCtaMonedaArrendaServicio() {
		super();
		// TODO Auto-generated constructor stub
	}	
	
	
	public SubCtaMonedaArrendaBean consulta(int tipoConsulta, SubCtaMonedaArrendaBean subCtaMonedaArrendaBean){
		SubCtaMonedaArrendaBean resultado = null;
		switch (tipoConsulta) {
			case Enum_Con_Arrenda.principal:		
				resultado = subCtaMonedaArrendaDAO.consultaPrincipal(subCtaMonedaArrendaBean, tipoConsulta);				
				break;	
		}	
		return resultado;
	}



	
	//------------------ Geters y Seters ------------------------------------------------------	

	public SubCtaMonedaArrendaDAO getSubCtaMonedaArrendaDAO() {
		return subCtaMonedaArrendaDAO;
	}


	public void setSubCtaMonedaArrendaDAO(
			SubCtaMonedaArrendaDAO subCtaMonedaArrendaDAO) {
		this.subCtaMonedaArrendaDAO = subCtaMonedaArrendaDAO;
	}
	
			
}


