package arrendamiento.servicio;

import java.util.List;

import general.servicio.BaseServicio;
import arrendamiento.bean.SegurosArrendaBean;
import arrendamiento.dao.SegurosArrendaDAO;

public class SegurosArrendaServicio extends BaseServicio {

	//---------- Variables ------------------------------------------------------------------------
	SegurosArrendaDAO arrendamientosDAO = null;			   

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
	
	public SegurosArrendaServicio() {
		super();
		// TODO Auto-generated constructor stub
	}	
	
	
	public SegurosArrendaBean consulta(int tipoConsulta, SegurosArrendaBean segurosArrendaBean){
		SegurosArrendaBean resultado = null;
		switch (tipoConsulta) {
			case Enum_Con_Arrenda.principal:		
				resultado = arrendamientosDAO.consultaPrincipal(segurosArrendaBean, tipoConsulta);				
				break;	
			case Enum_Con_Arrenda.mueble:		
				resultado = arrendamientosDAO.consultaPrincipal(segurosArrendaBean, tipoConsulta);				
				break;
		}	
		return resultado;
	}
	
	public List lista(int tipoLista, SegurosArrendaBean segurosArrendaBean){		
		List resultado = null;
		switch (tipoLista) {
			case Enum_Lis_Arrenda.principal:		
				resultado = arrendamientosDAO.listaPrincipal(segurosArrendaBean, tipoLista);				
				break;
			case Enum_Lis_Arrenda.mueble:		
				resultado = arrendamientosDAO.listaPrincipal(segurosArrendaBean, tipoLista);				
				break;
		}		
		return resultado;
	}
	

	
	//------------------ Geters y Seters ------------------------------------------------------	
	public SegurosArrendaDAO getSegurosArrendaDAO() {
		return arrendamientosDAO;
	}


	public void setSegurosArrendaDAO(SegurosArrendaDAO arrendamientosDAO) {
		this.arrendamientosDAO = arrendamientosDAO;
	}
	
			
}


