package invkubo.servicio;

import invkubo.bean.SubctaMonedaKuboBean;
import invkubo.dao.SubctaMonedaKuboDAO;
import general.servicio.BaseServicio;

public class SubctaMonedaKuboServicio extends BaseServicio{
	
	//---------- Variables ------------------------------------------------------------------------
	
	SubctaMonedaKuboDAO subctaMonedaKuboDAO = null;
	
	public SubctaMonedaKuboServicio() {
		super();
	}
	
	
	//---------- Tipos de Transacciones---------------------------------------------------------------

	public static interface Enum_Tra_SubctaMonedaKubo {
		int alta = 1;
		int modificacion = 2;
		int baja = 3;
	}

	//---------- Tipos de Consultas---------------------------------------------------------------

	public static interface Enum_Con_SubctaMonedaKubo {
		int principal = 1;
		int foranea = 2;
	}

	//---------- Tipos de Listas---------------------------------------------------------------

	public static interface Enum_Lis_SubctaMonedaKubo{
		int principal = 1;
		int foranea = 2;
	}
	
	//---------- Metodo que contiene las consultas ---------------------------------------------------------------

	public SubctaMonedaKuboBean consulta(int tipoConsulta, SubctaMonedaKuboBean subctaMonedaKuboBean){
		SubctaMonedaKuboBean subctaMonedaKubo = null;
		
		switch(tipoConsulta){
		      case Enum_Con_SubctaMonedaKubo.principal:
		    	  subctaMonedaKubo = subctaMonedaKuboDAO.consultaPrincipal(subctaMonedaKuboBean, tipoConsulta);
		}
		
		return subctaMonedaKubo;
		
	}

	
	//------------------ Geters y Seters ------------------------------------------------------	

	public SubctaMonedaKuboDAO getSubctaMonedaKuboDAO() {
		return subctaMonedaKuboDAO;
	}

	public void setSubctaMonedaKuboDAO(SubctaMonedaKuboDAO subctaMonedaKuboDAO) {
		this.subctaMonedaKuboDAO = subctaMonedaKuboDAO;
	}
	
	

}
