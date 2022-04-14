package cliente.servicio;
import herramientas.Utileria;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

import java.util.List;

import cliente.bean.FuncionesPubBean;
import cliente.dao.FuncionesPubDAO;


public class FuncionesPubServicio extends BaseServicio {
	//---------- Variables ------------------------------------------------------------------------
	FuncionesPubDAO funcionesPubDAO = null;

	//---------- Tipod de Consulta ----------------------------------------------------------------
	public static interface Enum_Con_Funciones {
		int principal = 1;
		int foranea = 2;		
	}

	public static interface Enum_Lis_Funciones {
		int principal = 1;
	}

	public FuncionesPubServicio () {
		super();
		// TODO Auto-generated constructor stub
	}
	
	
	
	public FuncionesPubBean consulta(int tipoConsulta, FuncionesPubBean funcionesB){
		FuncionesPubBean funciones = null;
		funciones = funcionesPubDAO.consulta(funcionesB,Enum_Con_Funciones.principal);
		return funciones;
	}
	

	
	public List lista(int tipoLista,FuncionesPubBean funciones){		
		List listaFunciones = null;
		switch (tipoLista) {
			case Enum_Lis_Funciones.principal:		
				listaFunciones=  funcionesPubDAO.listaFunciones(funciones,tipoLista);				
				break;				
		}		
		return listaFunciones;
	}





	//------------------ Geters y Seters ------------------------------------------------------	

	public void setFuncionesPubDAO(FuncionesPubDAO funcionesPubDAO) {
		this.funcionesPubDAO = funcionesPubDAO;
	}
	

}
