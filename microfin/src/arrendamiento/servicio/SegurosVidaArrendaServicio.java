package arrendamiento.servicio;

import java.util.List;

import general.servicio.BaseServicio;
import arrendamiento.bean.SegurosVidaArrendaBean;
import arrendamiento.dao.SegurosVidaArrendaDAO;

public class SegurosVidaArrendaServicio extends BaseServicio {

	//---------- Variables ------------------------------------------------------------------------
	SegurosVidaArrendaDAO segurosVidaArrendaDAO = null;			   

	//---------- Tipo de Consulta ----------------------------------------------------------------
	public static interface Enum_Con_Arrenda {
		int principal = 1;
		int mueble = 2;
		int vida = 3;
	}

	//---------- Tipo de Lista ----------------------------------------------------------------
	public static interface Enum_Lis_Arrenda {
		int principal = 1;
		int mueble = 2;
		int vida = 3;
	}
	
	public SegurosVidaArrendaServicio() {
		super();
		// TODO Auto-generated constructor stub
	}	
	
	
	public SegurosVidaArrendaBean consulta(int tipoConsulta, SegurosVidaArrendaBean segurosArrendaBean){
		SegurosVidaArrendaBean resultado = null;
		switch (tipoConsulta) {
			case Enum_Con_Arrenda.principal:		
				resultado = segurosVidaArrendaDAO.consultaPrincipal(segurosArrendaBean, tipoConsulta);				
				break;	
			case Enum_Con_Arrenda.vida:		
				resultado = segurosVidaArrendaDAO.consultaPrincipal(segurosArrendaBean, tipoConsulta);				
				break;
		}	
		return resultado;
	}
	
	public List lista(int tipoLista, SegurosVidaArrendaBean segurosArrendaBean){		
		List resultado = null;
		switch (tipoLista) {
			case Enum_Lis_Arrenda.principal:		
				resultado = segurosVidaArrendaDAO.listaPrincipal(segurosArrendaBean, tipoLista);				
				break;
			case Enum_Lis_Arrenda.vida:		
				resultado = segurosVidaArrendaDAO.listaPrincipal(segurosArrendaBean, tipoLista);				
				break;
		}		
		return resultado;
	}




	
	//------------------ Geters y Seters ------------------------------------------------------	
	public SegurosVidaArrendaDAO getSegurosVidaArrendaDAO() {
		return segurosVidaArrendaDAO;
	}


	public void setSegurosVidaArrendaDAO(SegurosVidaArrendaDAO segurosVidaArrendaDAO) {
		this.segurosVidaArrendaDAO = segurosVidaArrendaDAO;
	}
	
	
			
}


