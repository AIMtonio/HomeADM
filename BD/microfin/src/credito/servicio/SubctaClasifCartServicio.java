package credito.servicio;

import general.servicio.BaseServicio;
import credito.bean.SubctaClasifCartBean;
import credito.dao.SubctaClasifCartDAO;

public class SubctaClasifCartServicio extends BaseServicio {

	//---------- Variables ------------------------------------------------------------------------

	SubctaClasifCartDAO subctaClasifCartDAO = null;
	
	public SubctaClasifCartServicio() {
		super();
	}
	
	//---------- Tipos de Transacciones---------------------------------------------------------------

	public static interface Enum_Tra_SubctaClasifCart {
		int alta = 1;
		int modificacion = 2;
		int baja = 3;
	}
	
	//---------- Tipos de Consultas---------------------------------------------------------------

	public static interface Enum_Con_SubctaClasifCart {
		int principal = 1;
		int foranea = 2;
	}

	//---------- Tipos de Listas---------------------------------------------------------------

	public static interface Enum_Lis_SubctaClasifCart {
		int principal = 1;
		int foranea = 2;
	}
	
	//---------- Metodo que contiene las consultas ---------------------------------------------------------------

	public SubctaClasifCartBean consulta(int tipoConsulta, SubctaClasifCartBean subctaClasifCartBean){
		SubctaClasifCartBean subctaClasifCart = null;
		
		switch(tipoConsulta){
			  case Enum_Con_SubctaClasifCart.principal:
				  subctaClasifCart = subctaClasifCartDAO.consultaPrincipal(subctaClasifCartBean, tipoConsulta);
				  break;
		}
		
		return subctaClasifCart;
	}
	
	//------------------ Geters y Seters ------------------------------------------------------	

	public SubctaClasifCartDAO getSubctaClasifCartDAO() {
		return subctaClasifCartDAO;
	}

	public void setSubctaClasifCartDAO(SubctaClasifCartDAO subctaClasifCartDAO) {
		this.subctaClasifCartDAO = subctaClasifCartDAO;
	}
	
	

}
