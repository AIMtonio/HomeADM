package cliente.servicio;

import general.servicio.BaseServicio;

import java.util.List;

import cliente.bean.ColoniaRepubBean;
import cliente.dao.ColoniaRepubDAO;


public class ColoniaRepubServicio extends BaseServicio{
	ColoniaRepubDAO coloniaRepubDAO = null;
	
	public static interface Enum_Con_Municipios {
		int principal = 1;
		int foranea = 2;		
	}

	public static interface Enum_Lis_Municipios {
		int principal = 1;
	}
	public ColoniaRepubServicio () {
		super();
		// TODO Auto-generated constructor stub
	}
	public List lista(int tipoLista, ColoniaRepubBean colonia) {
		// TODO Auto-generated method stub
		List ListaColonia= null;
		switch (tipoLista) {
		case Enum_Lis_Municipios.principal:		
			ListaColonia=  coloniaRepubDAO.listaColonias(colonia,tipoLista);				
			break;				
	}		
	return ListaColonia;
		
	}
							  
	public ColoniaRepubBean consulta(int tipoConsulta,String estadoID, String municipioID, String coloniaID){
		ColoniaRepubBean colonias = null;		
		switch(tipoConsulta){
		case Enum_Con_Municipios.principal:
			colonias = coloniaRepubDAO.consultaPrincipal(Integer.parseInt(estadoID),Integer.parseInt(municipioID),Integer.parseInt(coloniaID),Enum_Con_Municipios.principal);
		break;
		}
		
		return colonias;
	}
	public ColoniaRepubDAO getColoniaRepubDAO() {
		return coloniaRepubDAO;
	}
	public void setColoniaRepubDAO(ColoniaRepubDAO coloniaRepubDAO) {
		this.coloniaRepubDAO = coloniaRepubDAO;
	}
	
}
