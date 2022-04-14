package operacionesCRCB.beanWS.validacion;

import herramientas.Constantes;
import herramientas.Utileria;
import operacionesCRCB.beanWS.request.AbonoCuentaRequest;
import operacionesCRCB.beanWS.response.AbonoCuentaResponse;
import java.util.regex.Pattern;

public class AbonoCuentaValidacion {
	private AbonoCuentaRequest abonoCuentaRequest = null;
	private AbonoCuentaResponse abonoCuentaResponse = null;
	
	public boolean isCuentaAhoIDValid(){
		
		if (abonoCuentaRequest.getCuentaAhoID().equals(Constantes.STRING_VACIO) || abonoCuentaRequest.getCuentaAhoID().equals("?")){  
	
			abonoCuentaResponse.setCodigoRespuesta("1");
			abonoCuentaResponse.setMensajeRespuesta("El Número de Cuenta está vacío.");
		return false;
		}
		if (!Utileria.esLong(abonoCuentaRequest.getCuentaAhoID()) ){
			abonoCuentaResponse.setCodigoRespuesta("400");
			abonoCuentaResponse.setMensajeRespuesta("El Número de Cuenta es Incorrecto.");
			return false;
		}
		return true;
	}

	public boolean isMontoValid(){
		
		if (abonoCuentaRequest.getMonto().equals(Constantes.STRING_VACIO) || abonoCuentaRequest.getMonto().equals("?")){  
			abonoCuentaResponse.setCodigoRespuesta("5");
			abonoCuentaResponse.setMensajeRespuesta("La Cantidad está vacía.");
			return false;
		}
		if (!Utileria.esDouble(abonoCuentaRequest.getMonto())){
			abonoCuentaResponse.setCodigoRespuesta("400");
			abonoCuentaResponse.setMensajeRespuesta("Monto Incorrecto.");
			return false;
		}
		return true;
	}

	public boolean isUsuarioValid(){
		if (abonoCuentaRequest.getUsuario().equals(Constantes.STRING_VACIO) || abonoCuentaRequest.getUsuario().equals("?")){  

			abonoCuentaResponse.setCodigoRespuesta("901");
			abonoCuentaResponse.setMensajeRespuesta("Campo Usuario Auditoría vacío");
			return false;
		}
		if (!Utileria.esNumero(abonoCuentaRequest.getUsuario())){
			abonoCuentaResponse.setCodigoRespuesta("901");
			abonoCuentaResponse.setMensajeRespuesta("Campo Usuario Auditoría Incorrecto.");
			return false;
		}
		return true;
	}

	public boolean isDireccionIPValid(){
		if (abonoCuentaRequest.getDireccionIP().equals(Constantes.STRING_VACIO) || abonoCuentaRequest.getDireccionIP().equals("?")){

			abonoCuentaResponse.setCodigoRespuesta("902");
			abonoCuentaResponse.setMensajeRespuesta("Campo DireccionIP Auditoría vacío");
			return false;
		}
		return true;
	}

	public boolean isProgramaIDValid(){
		if (abonoCuentaRequest.getProgramaID().equals(Constantes.STRING_VACIO) || abonoCuentaRequest.getProgramaID().equals("?")){  

			abonoCuentaResponse.setCodigoRespuesta("903");
			abonoCuentaResponse.setMensajeRespuesta("Campo ProgramaID Auditoría vacío");
			return false;
		}
		return true;
	}

	public boolean isSucursalValid(){
		if (abonoCuentaRequest.getSucursal().equals(Constantes.STRING_VACIO) || abonoCuentaRequest.getSucursal().equals("?")){  

			abonoCuentaResponse.setCodigoRespuesta("904");
			abonoCuentaResponse.setMensajeRespuesta("Campo Sucursal Auditoría vacío");
			return false;
		}
		if (! Utileria.esNumero(abonoCuentaRequest.getSucursal())){
			abonoCuentaResponse.setCodigoRespuesta("904");
			abonoCuentaResponse.setMensajeRespuesta("Campo Sucursal Auditoría Incorrecto.");
			return false;
		}
		return true;
	}


	public AbonoCuentaResponse isRequestValid(AbonoCuentaRequest abonoCuentaRequest){
		this.abonoCuentaRequest = abonoCuentaRequest;
		abonoCuentaResponse = new AbonoCuentaResponse();
		abonoCuentaResponse.setCodigoRespuesta("0");
		
		if(     isCuentaAhoIDValid()  &
				isMontoValid()  &
				isUsuarioValid()  &
				isDireccionIPValid()  &
				isProgramaIDValid()  &
				isSucursalValid()   
				){
			abonoCuentaResponse.setCodigoRespuesta("0");
			abonoCuentaResponse.setMensajeRespuesta("Request válido");
		}
		
		return abonoCuentaResponse;
	}

}
