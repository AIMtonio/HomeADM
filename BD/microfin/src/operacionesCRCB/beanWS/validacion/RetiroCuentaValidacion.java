package operacionesCRCB.beanWS.validacion;

import java.util.regex.Pattern;

import herramientas.Constantes;
import herramientas.Utileria;
import operacionesCRCB.beanWS.request.RetiroCuentaRequest;
import operacionesCRCB.beanWS.response.RetiroCuentaResponse;

public class RetiroCuentaValidacion {
	
	private RetiroCuentaRequest retiroCuentaRequest = null;
	private RetiroCuentaResponse retiroCuentaResponse = null;
	
	public boolean isCuentaAhoIDValid(){
		if (retiroCuentaRequest.getCuentaAhoID().equals(Constantes.STRING_VACIO) || retiroCuentaRequest.getCuentaAhoID().equals("?")){  

			retiroCuentaResponse.setCodigoRespuesta("1");
			retiroCuentaResponse.setMensajeRespuesta("El Numero de Cuenta esta vacío");
			return false;
		}
		if(!Utileria.esLong(retiroCuentaRequest.getCuentaAhoID())){
			retiroCuentaResponse.setCodigoRespuesta("400");
			retiroCuentaResponse.setMensajeRespuesta("El Número de Cuenta es Incorrecto.");
			return false;
		}
		return true;
	}
	
	public boolean isMontoValid(){
		if (retiroCuentaRequest.getMonto().equals(Constantes.STRING_VACIO) || retiroCuentaRequest.getMonto().equals("?")){  

			retiroCuentaResponse.setCodigoRespuesta("5");
			retiroCuentaResponse.setMensajeRespuesta("La Cantidad esta Vacia");
			return false;
		}
		if (!Utileria.esDouble(retiroCuentaRequest.getMonto())){
			retiroCuentaResponse.setCodigoRespuesta("400");
			retiroCuentaResponse.setMensajeRespuesta("Monto Incorrecto.");
			return false;
		}
		return true;
	}
	
	public boolean isUsuarioValid(){
		if (retiroCuentaRequest.getUsuario().equals(Constantes.STRING_VACIO) || retiroCuentaRequest.getUsuario().equals("?")){

		retiroCuentaResponse.setCodigoRespuesta("901");
		retiroCuentaResponse.setMensajeRespuesta("Campo Usuario Auditoría vacío");
		return false;
		}
		if(!Pattern.matches("^\\d+$",retiroCuentaRequest.getUsuario().trim())){
			retiroCuentaResponse.setCodigoRespuesta("901");
			retiroCuentaResponse.setMensajeRespuesta("Campo Usuario Auditoría Incorrecto.");
			return false;
		}
		return true;
	}
	
	public boolean isDireccionIPValid(){
		if (retiroCuentaRequest.getDireccionIP().equals(Constantes.STRING_VACIO) || retiroCuentaRequest.getDireccionIP().equals("?")){ 

			retiroCuentaResponse.setCodigoRespuesta("902");
			retiroCuentaResponse.setMensajeRespuesta("Campo DireccionIP Auditoría vacío");
			return false;
		}
		return true;
	}
	
	public boolean isProgramaIDValid(){
		if (retiroCuentaRequest.getProgramaID().equals(Constantes.STRING_VACIO) || retiroCuentaRequest.getProgramaID().equals("?")){  
			retiroCuentaResponse.setCodigoRespuesta("903");
			retiroCuentaResponse.setMensajeRespuesta("Campo ProgramaID Auditoría vacío");
			return false;
		}
		return true;
	}
	
	public boolean isSucursalValid(){
		if (retiroCuentaRequest.getSucursal().equals(Constantes.STRING_VACIO) || retiroCuentaRequest.getSucursal().equals("?")){  
			retiroCuentaResponse.setCodigoRespuesta("904");
			retiroCuentaResponse.setMensajeRespuesta("Campo Sucursal Auditoría vacío");
			return false;
		}
		if(!Pattern.matches("^\\d+$",retiroCuentaRequest.getSucursal().trim())){
			retiroCuentaResponse.setCodigoRespuesta("904");
			retiroCuentaResponse.setMensajeRespuesta("Campo Sucursal Auditoría Incorrecto.");
			return false;
		}
		return true;
	}
	
	public RetiroCuentaResponse isRequestValid(RetiroCuentaRequest retiroCuentaRequest){
		this.retiroCuentaRequest = retiroCuentaRequest;
		retiroCuentaResponse = new RetiroCuentaResponse();
		
		if(     isCuentaAhoIDValid()  &
				isMontoValid()  &
				isUsuarioValid()  &
				isDireccionIPValid()  &
				isProgramaIDValid()  &
				isSucursalValid()   
				){
			retiroCuentaResponse.setCodigoRespuesta("0");
			retiroCuentaResponse.setMensajeRespuesta("Request válido");
		}
		
		return retiroCuentaResponse;
	}
		
		
}
