package cliente.servicio;

import herramientas.Utileria;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

import java.util.List;
import cliente.bean.MunicipiosRepubBean;
import cliente.dao.MunicipiosRepubDAO;
import cliente.servicio.ClienteServicio.Enum_Tra_Cliente;



public class MunicipiosRepubServicio extends BaseServicio {

	//---------- Variables ------------------------------------------------------------------------
	MunicipiosRepubDAO municipiosRepubDAO = null;

	//---------- Tipod de Consulta ----------------------------------------------------------------
	public static interface Enum_Con_Municipios {
		int principal = 1;
		int foranea = 2;
		int linFondeo = 3;
	}

	public static interface Enum_Lis_Municipios {
		int principal = 1;
		int ciudades = 2;
	}

	public MunicipiosRepubServicio () {
		super();
		// TODO Auto-generated constructor stub
	}
	
	
	
	public MunicipiosRepubBean consulta(int tipoConsulta,String estadoID, String municipioID){
		MunicipiosRepubBean municipios = null;
		
		switch(tipoConsulta){
		case Enum_Con_Municipios.principal:
			municipios = municipiosRepubDAO.consultaPrincipal(Integer.parseInt(estadoID),Integer.parseInt(municipioID),Enum_Con_Municipios.principal);
		break;
		case Enum_Con_Municipios.foranea:
			municipios = municipiosRepubDAO.consultaForanea(Utileria.convierteEntero(estadoID),Utileria.convierteEntero(municipioID), Enum_Con_Municipios.foranea);
		break;
		// Consulta en alta de gestores del modulo de seguimiento
		case Enum_Con_Municipios.linFondeo:
			municipios = municipiosRepubDAO.consultaLinFondeo(Integer.parseInt(estadoID),Integer.parseInt(municipioID), Enum_Con_Municipios.linFondeo);
		break;
		}
		
		return municipios;
	}
	

	
	public List lista(int tipoLista,MunicipiosRepubBean municipios){		
		List listaMunicipios = null;
		switch (tipoLista) {
			case Enum_Lis_Municipios.principal:		
				listaMunicipios=  municipiosRepubDAO.listaMunicipios(municipios,tipoLista);				
				break;				
			case Enum_Lis_Municipios.ciudades:
				listaMunicipios=  municipiosRepubDAO.listaCiudades(municipios, tipoLista);
				break;
		}		
		return listaMunicipios;
	}
	
	//------------------ Geters y Seters ------------------------------------------------------	
	public void setMunicipiosRepubDAO(MunicipiosRepubDAO municipiosRepubDAO) 
	{              
		this.municipiosRepubDAO = municipiosRepubDAO;
	}	
	

}
