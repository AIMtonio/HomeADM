package cliente.servicio;
import herramientas.Utileria;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

import java.util.List;

import cliente.bean.EstadosRepubBean;
import cliente.dao.EstadosRepubDAO;

public class EstadosRepubServicio extends BaseServicio {

	//---------- Variables ------------------------------------------------------------------------
	EstadosRepubDAO estadosDAO = null;

	//---------- Tipod de Consulta ----------------------------------------------------------------
	public static interface Enum_Con_Estados {
		int principal = 1;
		int foranea = 2;		
	}

	public static interface Enum_Lis_Estados {
		int principal = 1;
	}

	public EstadosRepubServicio () {
		super();
		// TODO Auto-generated constructor stub
	}
	
	
	
	public EstadosRepubBean consulta(int tipoConsulta, String estadoID){
		EstadosRepubBean estados = null;
		
		estados = estadosDAO.consulta(Utileria.convierteEntero(estadoID),
				Enum_Con_Estados.principal);
		
		
		return estados;
	}
	

	
	public List lista(int tipoLista,EstadosRepubBean estados){		
		List listaEstados = null;
		switch (tipoLista) {
			case Enum_Lis_Estados.principal:		
				listaEstados=  estadosDAO.listaEstados(estados,tipoLista);				
				break;				
		}		
		return listaEstados;
	}
	
	//------------------ Geters y Seters ------------------------------------------------------	
	public void setEstadosRepubDAO(EstadosRepubDAO estadosDAO) {
		this.estadosDAO = estadosDAO;
	}	
	

}
