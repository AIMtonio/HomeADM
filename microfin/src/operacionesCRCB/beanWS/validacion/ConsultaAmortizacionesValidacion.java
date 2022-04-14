package operacionesCRCB.beanWS.validacion;

import herramientas.Constantes;
import herramientas.Utileria;
import operacionesCRCB.beanWS.request.ConsultaAmortizacionesRequest;
import operacionesCRCB.beanWS.response.ConsultaAmortizacionesResponse;

public class ConsultaAmortizacionesValidacion {
	
	private ConsultaAmortizacionesRequest consultaAmortizacionesRequest = null;
	private ConsultaAmortizacionesResponse consultaAmortizacionesResponse = null;
	
	public boolean isCreditoIDValid(){
	  if ( consultaAmortizacionesRequest.getCreditoID().equals(Constantes.STRING_VACIO)){  
	      consultaAmortizacionesResponse.setCodigoRespuesta("5");
	      consultaAmortizacionesResponse.setMensajeRespuesta("El Número de Crédito está vacío");
	      return false;
	  }
	  
	  if( !Utileria.esLong(consultaAmortizacionesRequest.getCreditoID()) ){
		  consultaAmortizacionesResponse.setCodigoRespuesta("400");
	      consultaAmortizacionesResponse.setMensajeRespuesta("El Número de Crédito es Inválido");
	      return false;
	  }
	  
	  return true;
	}
	
	public ConsultaAmortizacionesResponse isRequestValid(ConsultaAmortizacionesRequest consultaAmortizacionesRequest){
		this.consultaAmortizacionesRequest = consultaAmortizacionesRequest;
		consultaAmortizacionesResponse = new ConsultaAmortizacionesResponse();
		
		if(     isCreditoIDValid()  
				){
			consultaAmortizacionesResponse.setCodigoRespuesta("0");
			consultaAmortizacionesResponse.setMensajeRespuesta("Request válido");
		}
		
		return consultaAmortizacionesResponse;
	}
}
