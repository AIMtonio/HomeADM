package operacionesCRCB.beanWS.validacion;

import herramientas.Constantes;
import herramientas.Utileria;
import operacionesCRCB.beanWS.request.ActualizaClienteRequest;
import operacionesCRCB.beanWS.response.ActualizaClienteResponse;

public class ActualizaClienteValidacion {
	
	private ActualizaClienteRequest actualizaClienteRequest = null;
	private ActualizaClienteResponse actualizaClienteResponse = null;
	
	public boolean isClienteIDValid(){
	actualizaClienteRequest.setClienteID(actualizaClienteRequest.getClienteID().replace("?", Constantes.STRING_VACIO));
	  if ( actualizaClienteRequest.getClienteID().equals(Constantes.STRING_VACIO)){  
	      actualizaClienteResponse.setCodigoRespuesta("1");
	      actualizaClienteResponse.setMensajeRespuesta("El Número de Cliente está Vacío.");
	      return false;
	  }
	  if (! Utileria.esNumero(actualizaClienteRequest.getClienteID()) ){
		  actualizaClienteResponse.setCodigoRespuesta("400"); 
		  actualizaClienteResponse.setMensajeRespuesta("El Formato del Cliente es Inválido."); 
		  return false; 
	  }
	  return true;
	}

	public boolean isUsuarioValid(){
		actualizaClienteRequest.setUsuario(actualizaClienteRequest.getUsuario().replace("?", Constantes.STRING_VACIO));
	  if ( actualizaClienteRequest.getUsuario().equals(Constantes.STRING_VACIO)){  
	      actualizaClienteResponse.setCodigoRespuesta("901");
	      actualizaClienteResponse.setMensajeRespuesta("Campo Usuario Auditoría Vacío.");
	      return false;
	  }
	  if (! Utileria.esNumero(actualizaClienteRequest.getUsuario()) ){
		  actualizaClienteResponse.setCodigoRespuesta("400"); 
		  actualizaClienteResponse.setMensajeRespuesta("El Formato Usuario de Auditoría es Inválido."); 
		  return false; 
	  }
	  return true;
	}

	public boolean isDireccionIPValid(){
		actualizaClienteRequest.setDireccionIP(actualizaClienteRequest.getDireccionIP().replace("?", Constantes.STRING_VACIO));
	  if ( actualizaClienteRequest.getDireccionIP().equals(Constantes.STRING_VACIO)){  
	      actualizaClienteResponse.setCodigoRespuesta("902");
	      actualizaClienteResponse.setMensajeRespuesta("Campo DireccionIP Auditoría Vacío.");
	      return false;
	  }
	  return true;
	}

	public boolean isProgramaIDValid(){
	actualizaClienteRequest.setProgramaID(actualizaClienteRequest.getProgramaID().replace("?", Constantes.STRING_VACIO));
	  if ( actualizaClienteRequest.getProgramaID().equals(Constantes.STRING_VACIO)){  
	      actualizaClienteResponse.setCodigoRespuesta("903");
	      actualizaClienteResponse.setMensajeRespuesta("Campo ProgramaID Auditoría Vacío.");
	      return false;
	  }
	  return true;
	}

	public boolean isSucursalValid(){
		actualizaClienteRequest.setSucursal(actualizaClienteRequest.getSucursal().replace("?", Constantes.STRING_VACIO));
	  if ( actualizaClienteRequest.getSucursal().equals(Constantes.STRING_VACIO)){  
	      actualizaClienteResponse.setCodigoRespuesta("904");
	      actualizaClienteResponse.setMensajeRespuesta("Campo Sucursal Auditoría Vacío.");
	      return false;
	  }
	  if (! Utileria.esNumero(actualizaClienteRequest.getSucursal()) ){
		  actualizaClienteResponse.setCodigoRespuesta("400"); 
		  actualizaClienteResponse.setMensajeRespuesta("El Formato Sucursal de Auditoría es Inválido."); 
		  return false; 
	  }
	  return true;
	}
		
	public ActualizaClienteResponse isRequestValid(ActualizaClienteRequest actualizaCuentaRequest){
		this.actualizaClienteRequest = actualizaCuentaRequest;
		actualizaClienteResponse = new ActualizaClienteResponse();
		
		if(     isClienteIDValid()  &
				isUsuarioValid()  &
				isDireccionIPValid()  &
				isProgramaIDValid()  &
				isSucursalValid()  
				){
			actualizaClienteResponse.setCodigoRespuesta("0");
			actualizaClienteResponse.setMensajeRespuesta("Request válido");
		}
		
		return actualizaClienteResponse;
	}
}
