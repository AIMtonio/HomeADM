package credito.servicio;

import general.servicio.BaseServicio;
import credito.bean.SubctaTipoCartBean;
import credito.dao.SubctaTipoCartDAO;

public class SubctaTipoCartServicio extends BaseServicio{

	//---------- Variables ------------------------------------------------------------------------

	SubctaTipoCartDAO subctaTipoCartDAO = null;
	
	public SubctaTipoCartServicio() {
		super();
	}

	//---------- Tipos de Transacciones---------------------------------------------------------------

	public static interface Enum_Tra_SubctaTipoCart {
		int alta = 1;
		int modificacion = 2;
		int baja = 3;
	}
	
	//---------- Tipos de Consultas---------------------------------------------------------------

	public static interface Enum_Con_SubctaTipoCart {
		int principal = 1;
		int foranea = 2;
	}	

	//---------- Tipos de Listas---------------------------------------------------------------

	public static interface Enum_Lis_SubctaTipoCart {
		int principal = 1;
		int foranea = 2;
	}
	
	//---------- Metodo que contiene las consultas ---------------------------------------------------------------
	
	public SubctaTipoCartBean consulta(int tipoConsulta, SubctaTipoCartBean subctaTipoCartBean){
		SubctaTipoCartBean subctaTipoCart = null;
		
		switch(tipoConsulta){
				case  Enum_Con_SubctaTipoCart.principal:
					  subctaTipoCart = subctaTipoCartDAO.consultaPrincipal(subctaTipoCartBean, tipoConsulta);	
		}
		
		return subctaTipoCart;
		
	}
	
	
	//------------------ Geters y Seters ------------------------------------------------------	
	
	public SubctaTipoCartDAO getSubctaTipoCartDAO() {
		return subctaTipoCartDAO;
	}

	public void setSubctaTipoCartDAO(SubctaTipoCartDAO subctaTipoCartDAO) {
		this.subctaTipoCartDAO = subctaTipoCartDAO;
	}
	
}
