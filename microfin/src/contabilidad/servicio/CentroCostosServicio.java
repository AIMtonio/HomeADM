package contabilidad.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

import java.util.List;

import contabilidad.bean.CentroCostosBean;
import contabilidad.dao.CentroCostosDAO;


public class CentroCostosServicio extends BaseServicio {

	//---------- Variables ------------------------------------------------------------------------
	CentroCostosDAO centroCostosDAO = null;			   

	//---------- Tipo de Consulta ----------------------------------------------------------------
	public static interface Enum_Con_Centro {
		int principal = 1;
		int foranea = 2;
	}
	
	//---------- Tipo de Lista ----------------------------------------------------------------
	public static interface Enum_Lis_Centro {
		int principal = 1;
		int gridCentros = 2;
		int gridConsultaCentros = 3;
	}

	//---------- Tipo de Lista ----------------------------------------------------------------	
	public static interface Enum_Tra_Centro {
		int alta = 1;
		int modificacion = 2;
	}
	
	public CentroCostosServicio() {
		super();
		// TODO Auto-generated constructor stub
	}	
	
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, CentroCostosBean centro){
		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) {
			case Enum_Tra_Centro.alta:		
				mensaje = altaCentro(centro);				
				break;				
			case Enum_Tra_Centro.modificacion:
				mensaje = modificaCentro(centro);				
				break;
			
		}
		return mensaje;
	}
	
	
	public MensajeTransaccionBean altaCentro(CentroCostosBean centro){
		MensajeTransaccionBean mensaje = null;
		mensaje = centroCostosDAO.altaCentroCostos(centro);		
		return mensaje;
	}

	public MensajeTransaccionBean modificaCentro(CentroCostosBean centro){
		MensajeTransaccionBean mensaje = null;
		mensaje = centroCostosDAO.modificaCentroCostos(centro);		
		return mensaje;
	}
	
	
	public CentroCostosBean consulta(int tipoConsulta, CentroCostosBean centroBean){
		CentroCostosBean centro = null;
		switch (tipoConsulta) {
			case Enum_Con_Centro.principal:		
				centro = centroCostosDAO.consultaPrincipal(centroBean, tipoConsulta);				
				break;	
			case Enum_Con_Centro.foranea:		
				centro = centroCostosDAO.consultaForanea(centroBean, tipoConsulta);				
			break;	
		}
				
		return centro;
	}
	
	public List lista(int tipoLista, CentroCostosBean centroBean){		
		List listaCentros = null;
		switch (tipoLista) {
			case Enum_Lis_Centro.principal:		
				listaCentros = centroCostosDAO.lista(centroBean, tipoLista);				
				break;
			case Enum_Lis_Centro.gridCentros :				
				listaCentros = centroCostosDAO.listaGrid(centroBean,tipoLista);
				break;
			case Enum_Lis_Centro.gridConsultaCentros :
					listaCentros = centroCostosDAO.listaGrid(centroBean,tipoLista);
				break;
		}		
		return listaCentros;
	}

		
	//------------------ Geters y Seters ------------------------------------------------------	

	public void setCentroCostosDAO(CentroCostosDAO centroCostosDAO) {
		this.centroCostosDAO = centroCostosDAO;
	}	
}

