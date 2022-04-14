package operacionesCRCB.servicio;

import general.servicio.BaseServicio;
import herramientas.Constantes;

import java.util.ArrayList;
import java.util.List;

import operacionesCRCB.beanWS.request.ConsultaAmortizacionCedeRequest;
import operacionesCRCB.beanWS.request.ConsultaCedesRequest;
import operacionesCRCB.beanWS.response.ConsultaAmortizacionCedeResponse;
import operacionesCRCB.beanWS.response.ConsultaCedesResponse;
import operacionesCRCB.dao.ConsultaCedesDAO;

public class ConsultaCedesServicio extends BaseServicio{

	ConsultaCedesDAO consultaCedesDAO = null;
	ArrayList listaCedes = null;
	
	public ConsultaCedesServicio() {
		// TODO Auto-generated constructor stub
		super();
	}

	
	public static interface Enum_Con_Cedes_WS {
		int consultaAmo 		= 1;
		int consultaCede		= 2;

	}
	
	
	public Object lista(Object beanRequest, int tipoLista){		
		
		Object response = null;				
		switch (tipoLista) {	
			case Enum_Con_Cedes_WS.consultaAmo:
				response = consultaAmortizacionCedes((ConsultaAmortizacionCedeRequest)beanRequest,tipoLista);
			break;
			
			case Enum_Con_Cedes_WS.consultaCede:
				response = consultaCede((ConsultaCedesRequest)beanRequest,tipoLista);
			break;
		
		}				
		return response;			
	}
	
	
	// Metodo listar amortizaciones
	public ConsultaAmortizacionCedeResponse consultaAmortizacionCedes(ConsultaAmortizacionCedeRequest requestBean, int tipoLista){
		
		ConsultaAmortizacionCedeResponse listaAmortizaRespuesta = null;

		listaAmortizaRespuesta = consultaCedesDAO.validaConsultaAmortizaciones(requestBean,tipoLista);
		
		if(listaAmortizaRespuesta.getCodigoRespuesta().equalsIgnoreCase(Constantes.STRING_CERO)){
			
			listaCedes = (ArrayList)consultaCedesDAO.listaAmortiCedes(requestBean, tipoLista);
			
			if(listaCedes == null){
				listaCedes = new ArrayList();
				listaAmortizaRespuesta.setCodigoRespuesta("999");
				listaAmortizaRespuesta.setMensajeRespuesta("Estimado Usuario(a), Ha ocurrido una falla en el sistema, " 
						+ "estamos trabajando para resolverla. Disculpe las molestias que esto le ocasiona. Ref: WS-CONSULTAAMORTIZACIONESCEDES");
			}
			
			listaAmortizaRespuesta.setAmortiCedes(listaCedes);
		}
		
		return listaAmortizaRespuesta;
	}
	
	
	// Metodo consulta
	public ConsultaCedesResponse consultaCede(ConsultaCedesRequest requestBean,int tipoLista){
		
		ConsultaCedesResponse consultaRespuesta = new ConsultaCedesResponse();
		
		consultaRespuesta = consultaCedesDAO.validaConsultaCede(requestBean,tipoLista);
		
		if(consultaRespuesta.getCodigoRespuesta().equalsIgnoreCase(Constantes.STRING_CERO)){
			
			consultaRespuesta =  consultaCedesDAO.consultaCedes(requestBean,tipoLista);
		}
			
		return consultaRespuesta;
	}


	public ConsultaCedesDAO getConsultaCedesDAO() {
		return consultaCedesDAO;
	}


	public void setConsultaCedesDAO(ConsultaCedesDAO consultaCedesDAO) {
		this.consultaCedesDAO = consultaCedesDAO;
	}


	
}
