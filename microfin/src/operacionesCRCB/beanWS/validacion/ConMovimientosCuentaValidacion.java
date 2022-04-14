package operacionesCRCB.beanWS.validacion;

import herramientas.Constantes;
import herramientas.Utileria;
import operacionesCRCB.beanWS.request.ConMovimientosCuentaRequest;
import operacionesCRCB.beanWS.response.ConMovimientosCuentaResponse;

public class ConMovimientosCuentaValidacion {
	
	private ConMovimientosCuentaRequest conMovimientosCuentaRequest = null;
	private ConMovimientosCuentaResponse conMovimientosCuentaResponse = null;
	
	public boolean isCuentaAhoIDValid(){
	conMovimientosCuentaRequest.setCuentaAhoID(conMovimientosCuentaRequest.getCuentaAhoID().replace("?", Constantes.STRING_VACIO));
	  if ( conMovimientosCuentaRequest.getCuentaAhoID().equals(Constantes.STRING_VACIO)){  
	      conMovimientosCuentaResponse.setCodigoRespuesta("1");
	      conMovimientosCuentaResponse.setMensajeRespuesta("El Número de Cuenta está Vacío.");
	      return false;
	  }
	  if (! Utileria.esLong(conMovimientosCuentaRequest.getCuentaAhoID()) ){
		  conMovimientosCuentaResponse.setCodigoRespuesta("400"); 
		  conMovimientosCuentaResponse.setMensajeRespuesta("El Formato de la Cuenta es Inválido."); 
		  return false; 
	  }
	  return true;
	}

	public boolean isAñoValid(){
	conMovimientosCuentaRequest.setAnio(conMovimientosCuentaRequest.getAnio().replace("?", Constantes.STRING_VACIO));
	  if ( conMovimientosCuentaRequest.getAnio().equals(Constantes.STRING_VACIO)){  
	      conMovimientosCuentaResponse.setCodigoRespuesta("2");
	      conMovimientosCuentaResponse.setMensajeRespuesta("El Año está Vacío.");
	      return false;
	  }
	  if (! Utileria.esNumero(conMovimientosCuentaRequest.getAnio()) ){
		  conMovimientosCuentaResponse.setCodigoRespuesta("400"); 
		  conMovimientosCuentaResponse.setMensajeRespuesta("El Formato Año es Inválido."); 
		  return false; 
	  }
	  return true;
	}

	public boolean isMesValid(){
	conMovimientosCuentaRequest.setMes(conMovimientosCuentaRequest.getMes().replace("?", Constantes.STRING_VACIO));
	  if ( conMovimientosCuentaRequest.getMes().equals(Constantes.STRING_VACIO)){  
	      conMovimientosCuentaResponse.setCodigoRespuesta("3");
	      conMovimientosCuentaResponse.setMensajeRespuesta("El Mes está Vacío.");
	      return false;
	  }
	  if (! Utileria.esNumero(conMovimientosCuentaRequest.getMes()) ){
		  conMovimientosCuentaResponse.setCodigoRespuesta("400"); 
		  conMovimientosCuentaResponse.setMensajeRespuesta("El Formato Mes es Inválido."); 
		  return false; 
	  }
	  return true;
	}
	
	public ConMovimientosCuentaResponse isRequestValid(ConMovimientosCuentaRequest conMovimientosCuentaRequest){
		this.conMovimientosCuentaRequest = conMovimientosCuentaRequest;
		conMovimientosCuentaResponse = new ConMovimientosCuentaResponse();
		conMovimientosCuentaResponse.setSaldoInicialMes("0.00");
		conMovimientosCuentaResponse.setAbonosMes("0.00");
		conMovimientosCuentaResponse.setCargosMes("0.00");
		conMovimientosCuentaResponse.setSaldoDisponible("0.00");
		
		if(     isCuentaAhoIDValid()  &
				isAñoValid()  &
				isMesValid()  
				){
			conMovimientosCuentaResponse.setCodigoRespuesta("0");
			conMovimientosCuentaResponse.setMensajeRespuesta("Request válido");
		}
		
		return conMovimientosCuentaResponse;
	}
	

	
}
