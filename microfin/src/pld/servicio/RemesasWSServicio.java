package pld.servicio;

import java.util.List;

import general.servicio.BaseServicio;
import pld.bean.RemesasWSBean;
import pld.dao.RemesasWSDAO;

public class RemesasWSServicio extends BaseServicio{
	
	public RemesasWSServicio(){
		super();
	}
	
	RemesasWSDAO remesasWSDAO = null;
	
	// --------- Tipo Lista de Remesas -----------
	public static interface Enum_Lis_Remesas{
		int listaRefRemesas    = 1; 	// Lista de Referencias de Remesas
		int listaRefRemesasWS    = 2; 	// Lista de Referencias de Remesas ws
		int listaRefRemesasWScbe    = 3; 	// Lista de Referencias de Remesas ws clabe cobro
	}
	
	// Lista de Remesas
	public List lista(int tipoLista, RemesasWSBean remesasBean){		
		List listaRemesas = null;
		switch (tipoLista) {
			case Enum_Lis_Remesas.listaRefRemesas:		
				listaRemesas = remesasWSDAO.listaReferenciaRemesas(remesasBean, tipoLista);				
			break;
			case Enum_Lis_Remesas.listaRefRemesasWS:		
				listaRemesas = remesasWSDAO.listaReferenciaRemesas(remesasBean, tipoLista);				
			break;
			case Enum_Lis_Remesas.listaRefRemesasWScbe:		
				listaRemesas = remesasWSDAO.listaReferenciaRemesas(remesasBean, tipoLista);				
			break;	
		}		
		return listaRemesas;
	}
	
	// GETTER && SETTER
	public RemesasWSDAO getRemesasWSDAO() {
		return remesasWSDAO;
	}

	public void setRemesasWSDAO(RemesasWSDAO remesasWSDAO) {
		this.remesasWSDAO = remesasWSDAO;
	}	
}
