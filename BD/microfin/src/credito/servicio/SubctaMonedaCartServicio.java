package credito.servicio;

import general.servicio.BaseServicio;
import credito.bean.SubctaMonedaCartBean;
import credito.dao.SubctaMonedaCartDAO;

public class SubctaMonedaCartServicio extends BaseServicio{
	//---------- Variables ------------------------------------------------------------------------

	SubctaMonedaCartDAO subctaMonedaCartDAO = null;

	public SubctaMonedaCartServicio() {
		super();
	}
	
	//---------- Tipos de Transacciones---------------------------------------------------------------

	public static interface Enum_Tra_SubctaMonedaCart {
		int alta = 1;
		int modificacion = 2;
		int baja = 3;
	}

	//---------- Tipos de Consultas---------------------------------------------------------------

	public static interface Enum_Con_SubctaMonedaCart{
		int principal = 1;
		int foranea = 2;
	}

	//---------- Tipos de Listas---------------------------------------------------------------

	public static interface Enum_Lis_SubctaMonedaCart{
		int principal = 1;
		int foranea = 2;
	}
	
	//---------- Metodo que contiene las consultas ---------------------------------------------------------------

	public SubctaMonedaCartBean consulta(int tipoConsulta, SubctaMonedaCartBean subctaMonedaCart){
		SubctaMonedaCartBean subctaMonedaCartBean = null;
		
		switch(tipoConsulta){
		      case Enum_Con_SubctaMonedaCart.principal:
		    	   subctaMonedaCartBean = subctaMonedaCartDAO.consultaPrincipal(subctaMonedaCart, tipoConsulta);
		    	   break;
		}
		
		return subctaMonedaCartBean;
		
	}
	
	//------------------ Geters y Seters ------------------------------------------------------	

	public SubctaMonedaCartDAO getSubctaMonedaCartDAO() {
		return subctaMonedaCartDAO;
	}

	public void setSubctaMonedaCartDAO(SubctaMonedaCartDAO subctaMonedaCartDAO) {
		this.subctaMonedaCartDAO = subctaMonedaCartDAO;
	}
	
	

}
