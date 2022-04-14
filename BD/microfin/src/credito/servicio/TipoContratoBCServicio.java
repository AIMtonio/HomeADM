package credito.servicio;

import general.servicio.BaseServicio;

import java.util.List;

import credito.bean.TipoContratoBCBean;
import credito.dao.TipoContratoBCDAO;

import pld.bean.MotivosInuBean;
import pld.dao.MotivosInuDAO;
import pld.servicio.MotivosInuServicio.Enum_Con_MotivosInu;
import pld.servicio.MotivosInuServicio.Enum_Lis_MotivosInu;

public class TipoContratoBCServicio extends BaseServicio {

	private TipoContratoBCServicio(){
		super();
	}

	TipoContratoBCDAO tipoContratoBCDAO = null;

	public static interface Enum_Lis_TipoContrato{
		int alfanumerica = 1;
	}
	
	public static interface Enum_Con_TipoContrato{
		int principal = 1;
	}
	
	public List lista(int tipoLista, TipoContratoBCBean tipoContrato){		
		List listaTipocontratoBC = null;
		switch (tipoLista) {
			case Enum_Lis_TipoContrato.alfanumerica:		
				listaTipocontratoBC=  tipoContratoBCDAO.listaAlfanumerica(tipoContrato, Enum_Lis_TipoContrato.alfanumerica);				
				break;	
		}		
		return listaTipocontratoBC;
	}
	
	public TipoContratoBCBean consulta(int tipoConsulta, TipoContratoBCBean tipoContratoBC){
		TipoContratoBCBean tipoContratoBCBean = null;
		switch(tipoConsulta){
			case Enum_Con_TipoContrato.principal:
				tipoContratoBCBean = tipoContratoBCDAO.consultaPrincipal(tipoContratoBC, Enum_Con_TipoContrato.principal);
			break;
		}
		return tipoContratoBCBean;
		
	}

	public TipoContratoBCDAO getTipoContratoBCDAO() {
		return tipoContratoBCDAO;
	}

	public void setTipoContratoBCDAO(TipoContratoBCDAO tipoContratoBCDAO) {
		this.tipoContratoBCDAO = tipoContratoBCDAO;
	}

	
}
