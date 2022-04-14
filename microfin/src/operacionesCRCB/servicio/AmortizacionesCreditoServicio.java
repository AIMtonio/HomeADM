package operacionesCRCB.servicio;

import java.util.ArrayList;

import operacionesCRCB.beanWS.request.ConsultaAmortizacionesRequest;
import operacionesCRCB.beanWS.response.ConsultaAmortizacionesResponse;
import operacionesCRCB.dao.AmortizacionesCreditoDAO;
import general.servicio.BaseServicio;
import herramientas.Constantes;

public class AmortizacionesCreditoServicio extends BaseServicio {

	AmortizacionesCreditoDAO amortizacionesCreditoDAO = null;
	ArrayList listaAmortizacion = null;
	
	public AmortizacionesCreditoServicio(){
		super();
	}
	
	public static interface Enum_Lis_Amortiza{
		int listaAmortizaciones = 1;
	}
	
	
	public ConsultaAmortizacionesResponse lista(ConsultaAmortizacionesRequest consultaAmortizacionesBean, int tipoLista){
		
		ConsultaAmortizacionesResponse listaAmortizaRespuesta = null;
		
		
		listaAmortizaRespuesta = amortizacionesCreditoDAO.validaConsultaAmortizaciones(consultaAmortizacionesBean);
		
		if(listaAmortizaRespuesta.getCodigoRespuesta().equalsIgnoreCase(Constantes.STRING_CERO)){
			
			listaAmortizacion = (ArrayList)amortizacionesCreditoDAO.listaAmortiCredito(consultaAmortizacionesBean, tipoLista);
			
			if(listaAmortizacion == null){
				listaAmortizacion = new ArrayList();
				listaAmortizaRespuesta.setCodigoRespuesta("999");
				listaAmortizaRespuesta.setMensajeRespuesta("Estimado Usuario(a), Ha ocurrido una falla en el sistema, " 
						+ "estamos trabajando para resolverla. Disculpe las molestias que esto le ocasiona. Ref: WS-CONSULTAAMORTIZACIONES");
			}
			
			listaAmortizaRespuesta.setAmortiCredito(listaAmortizacion);
		}
		
		return listaAmortizaRespuesta;
		
	}


	public AmortizacionesCreditoDAO getAmortizacionesCreditoDAO() {
		return amortizacionesCreditoDAO;
	}


	public void setAmortizacionesCreditoDAO(
			AmortizacionesCreditoDAO amortizacionesCreditoDAO) {
		this.amortizacionesCreditoDAO = amortizacionesCreditoDAO;
	}
	
	
}
