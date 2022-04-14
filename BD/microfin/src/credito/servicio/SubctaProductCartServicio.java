package credito.servicio;

import general.servicio.BaseServicio;
import credito.bean.SubctaProductCartBean;
import credito.dao.SubctaProductCartDAO;

public class SubctaProductCartServicio extends BaseServicio{

	//---------- Variables ------------------------------------------------------------------------

	SubctaProductCartDAO subctaProductCartDAO = null;
	
	public SubctaProductCartServicio() {
		super();
	}
	
	//---------- Tipos de Transacciones---------------------------------------------------------------
	
	public static interface Enum_Tra_SubctaProductCart {
		int alta = 1;
		int modificacion = 2;
		int baja = 3;
	}
	
	//---------- Tipos de Consultas---------------------------------------------------------------

	public static interface Enum_Con_SubctaProductCart{
		int principal = 1;
		int foranea = 2;
	}
	
	//---------- Tipos de Listas---------------------------------------------------------------

	public static interface Enum_Lis_SubctaProductCart{
		int principal = 1;
		int foranea = 2;
	}
	
	
	//---------- Metodo que contiene las consultas ---------------------------------------------------------------
	public SubctaProductCartBean consulta(int tipoConsulta, SubctaProductCartBean subctaProductCartBean){
		SubctaProductCartBean subctaProductCart = null;
		switch(tipoConsulta){
				case Enum_Con_SubctaProductCart.principal:
					subctaProductCart = subctaProductCartDAO.consultaPrincipal(subctaProductCartBean, tipoConsulta);
					break;
		}		
		return subctaProductCart;
	}


	//------------------ Geters y Seters ------------------------------------------------------	

	public SubctaProductCartDAO getSubctaProductCartDAO() {
		return subctaProductCartDAO;
	}


	public void setSubctaProductCartDAO(SubctaProductCartDAO subctaProductCartDAO) {
		this.subctaProductCartDAO = subctaProductCartDAO;
	}
	


	

}
