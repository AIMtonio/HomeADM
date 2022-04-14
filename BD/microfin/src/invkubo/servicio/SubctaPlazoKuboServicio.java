package invkubo.servicio;


import invkubo.bean.SubctaPlazoKuboBean;
import invkubo.dao.SubctaPlazoKuboDAO;
import general.servicio.BaseServicio;

public class SubctaPlazoKuboServicio extends BaseServicio{
	//---------- Variables ------------------------------------------------------------------------

	SubctaPlazoKuboDAO subctaPlazoKuboDAO = null;

	public SubctaPlazoKuboServicio() {
		super();
	}
	
	

	public static interface Enum_Tra_SubctaPlazoKubo {
		int alta = 1;
		int modificacion = 2;
		int baja = 3;
	}

	//---------- Tipos de Consultas---------------------------------------------------------------

	public static interface Enum_Con_SubctaPlazoKubo{
		int principal = 1;
		int foranea = 2;
	}

	//---------- Tipos de Listas---------------------------------------------------------------

	public static interface Enum_Lis_SubctaPlazoKubo{
		int principal = 1;
		int foranea = 2;
	}
	
	
	//---------- Metodo que contiene las consultas ---------------------------------------------------------------

	public SubctaPlazoKuboBean consulta(int tipoConsulta, SubctaPlazoKuboBean subctaPlazoKuboBean){
		SubctaPlazoKuboBean subctaPlazoKubo = null;
		
		switch(tipoConsulta){
		      case Enum_Con_SubctaPlazoKubo.principal:
		    	   subctaPlazoKubo = subctaPlazoKuboDAO.consultaPrincipal(subctaPlazoKuboBean, tipoConsulta);
		    	   break;
		}
		
		return subctaPlazoKubo;
		
	}
	
	//------------------ Geters y Seters ------------------------------------------------------	


	public SubctaPlazoKuboDAO getSubctaPlazoKuboDAO() {
		return subctaPlazoKuboDAO;
	}

	public void setSubctaPlazoKuboDAO(SubctaPlazoKuboDAO subctaPlazoKuboDAO) {
		this.subctaPlazoKuboDAO = subctaPlazoKuboDAO;
	}
	
	

	
	
}
