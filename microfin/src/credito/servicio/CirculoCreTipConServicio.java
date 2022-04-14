package credito.servicio;

import general.servicio.BaseServicio;

import java.util.List;

import credito.bean.CirculoCreTipConBean;
import credito.dao.CirculoCreTipConDAO;

public class CirculoCreTipConServicio extends BaseServicio {

	private CirculoCreTipConServicio(){
		super();
	}

	CirculoCreTipConDAO circuloCreTipConDAO = null;

	public static interface Enum_Lis_TipoContrato{
		int principal = 1;
	}
	
	public static interface Enum_Con_TipoContrato{
		int principal = 1;
	}
	
	public List lista(int tipoLista, CirculoCreTipConBean tipoContrato){		
		List listaTipocontratoBC = null;
		switch (tipoLista) {
			case Enum_Lis_TipoContrato.principal:		
				listaTipocontratoBC=  circuloCreTipConDAO.listaPrincipal(tipoContrato, Enum_Lis_TipoContrato.principal);				
				break;	
		}		
		return listaTipocontratoBC;
	}
	
	public CirculoCreTipConBean consulta(int tipoConsulta, CirculoCreTipConBean tipoContratoBC){
		CirculoCreTipConBean circuloCreTipConBean = null;
		switch(tipoConsulta){
			case Enum_Con_TipoContrato.principal:
				circuloCreTipConBean = circuloCreTipConDAO.consultaPrincipal(tipoContratoBC, Enum_Con_TipoContrato.principal);
			break;
		}
		return circuloCreTipConBean;
		
	}


	// ------------------ getters y setters ---------------------- 
	public CirculoCreTipConDAO getCirculoCreTipConDAO() {
		return circuloCreTipConDAO;
	}

	public void setCirculoCreTipConDAO(CirculoCreTipConDAO circuloCreTipConDAO) {
		this.circuloCreTipConDAO = circuloCreTipConDAO;
	}
	
}
