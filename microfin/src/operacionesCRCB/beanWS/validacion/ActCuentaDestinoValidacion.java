package operacionesCRCB.beanWS.validacion;

import java.util.regex.Pattern;

import herramientas.Constantes;
import herramientas.Utileria;
import operacionesCRCB.beanWS.request.ActCuentaDestinoRequest;
import operacionesCRCB.beanWS.response.ActCuentaDestinoResponse;

public class ActCuentaDestinoValidacion {
	
	private ActCuentaDestinoRequest actCuentaDestinoRequest = null;
	private ActCuentaDestinoResponse actCuentaDestinoResponse = null;
	
	public boolean isClienteIDValid(){
		if (actCuentaDestinoRequest.getClienteID().equals(Constantes.STRING_VACIO) || actCuentaDestinoRequest.getClienteID().equals("?")){  
			
			actCuentaDestinoResponse.setCodigoRespuesta("4");
			actCuentaDestinoResponse.setMensajeRespuesta("El Cliente está vacío");
			return false;
		}
		if (!Utileria.esNumero(actCuentaDestinoRequest.getClienteID())){
			actCuentaDestinoResponse.setCodigoRespuesta("4");
			actCuentaDestinoResponse.setMensajeRespuesta("El Número de Cliente es Incorrecto.");
			
			return false;
		}
	return true;
	}

	public boolean isCuentaTranIDValid(){
		if (actCuentaDestinoRequest.getCuentaTranID().equals(Constantes.STRING_VACIO) || actCuentaDestinoRequest.getCuentaTranID().equals("?")){  
			
			actCuentaDestinoResponse.setCodigoRespuesta("5");
			actCuentaDestinoResponse.setMensajeRespuesta("La Cuenta está vacía");
			return false;
		}
	return true;
	}

	public boolean isBancoValid(){
		if (actCuentaDestinoRequest.getBanco().equals(Constantes.STRING_VACIO) || actCuentaDestinoRequest.getBanco().equals("?")){  
		
			actCuentaDestinoResponse.setCodigoRespuesta("6");
			actCuentaDestinoResponse.setMensajeRespuesta("El Banco está vacío");
			return false;
		}
	return true;
	}

	public boolean isTipoCuentaSpeiValid(){
		if (actCuentaDestinoRequest.getTipoCuentaSpei().equals(Constantes.STRING_VACIO) || actCuentaDestinoRequest.getTipoCuentaSpei().equals("?")){  
		
			actCuentaDestinoResponse.setCodigoRespuesta("7");
			actCuentaDestinoResponse.setMensajeRespuesta("El Tipo de Cuenta Spei está vacío");
			return false;
		}
	return true;
	}

	public boolean isCuentaValid(){
		if (actCuentaDestinoRequest.getCuenta().equals(Constantes.STRING_VACIO) || actCuentaDestinoRequest.getCuenta().equals("?")){  
		
			actCuentaDestinoResponse.setCodigoRespuesta("8");
			actCuentaDestinoResponse.setMensajeRespuesta("El Número de cuenta está vacío");
			return false;
		}
	return true;
	}

	public boolean isBeneficiarioValid(){
		if (actCuentaDestinoRequest.getBeneficiario().equals(Constantes.STRING_VACIO) || actCuentaDestinoRequest.getBeneficiario().equals("?")){  
		
			actCuentaDestinoResponse.setCodigoRespuesta("9");
			actCuentaDestinoResponse.setMensajeRespuesta("El beneficiario está vacío");
			return false;
		}
	return true;
	}

	public boolean isAliasValid(){
		if (actCuentaDestinoRequest.getAlias().equals(Constantes.STRING_VACIO) || actCuentaDestinoRequest.getAlias().equals("?")){  
		
			actCuentaDestinoResponse.setCodigoRespuesta("10");
			actCuentaDestinoResponse.setMensajeRespuesta("El Alias de la cuenta está vacío");
			return false;
		}
	return true;
	}

	public boolean isUsuarioValid(){
		if (actCuentaDestinoRequest.getUsuario().equals(Constantes.STRING_VACIO) || actCuentaDestinoRequest.getUsuario().equals("?")){  
		
			actCuentaDestinoResponse.setCodigoRespuesta("901");
			actCuentaDestinoResponse.setMensajeRespuesta("Campo Usuario Auditoría vacío");
			return false;
		}
		if (!Utileria.esNumero(actCuentaDestinoRequest.getUsuario())){
			actCuentaDestinoResponse.setCodigoRespuesta("901");
			actCuentaDestinoResponse.setMensajeRespuesta("Campo Usuario Incorrecto.");
			return false;
		}
	return true;
	}

	public boolean isDireccionIPValid(){
		if (actCuentaDestinoRequest.getDireccionIP().equals(Constantes.STRING_VACIO) || actCuentaDestinoRequest.getDireccionIP().equals("?")){  
		
			actCuentaDestinoResponse.setCodigoRespuesta("902");
			actCuentaDestinoResponse.setMensajeRespuesta("Campo DireccionIP Auditoría vacío");
			return false;
		}
	return true;
	}

	public boolean isProgramaIDValid(){
		if ( actCuentaDestinoRequest.getProgramaID().equals(Constantes.STRING_VACIO) || actCuentaDestinoRequest.getProgramaID().equals("?")){  

			actCuentaDestinoResponse.setCodigoRespuesta("903");
			actCuentaDestinoResponse.setMensajeRespuesta("Campo ProgramaID Auditoría vacío");
			return false;
		}
	return true;
	}

	public boolean isSucursalValid(){
		if (actCuentaDestinoRequest.getSucursal().equals(Constantes.STRING_VACIO) || actCuentaDestinoRequest.getSucursal().equals("?")){ 

			actCuentaDestinoResponse.setCodigoRespuesta("904");
			actCuentaDestinoResponse.setMensajeRespuesta("Campo Sucursal Auditoría vacío");
			return false;
		}
		if (!Utileria.esNumero(actCuentaDestinoRequest.getSucursal())){
			actCuentaDestinoResponse.setCodigoRespuesta("904");
			actCuentaDestinoResponse.setMensajeRespuesta("Campo Sucursal Incorrecto.");
			return false;
		}
	return true;
	}

	public ActCuentaDestinoResponse isRequestValid(ActCuentaDestinoRequest actCuentaDestinoRequest){
		this.actCuentaDestinoRequest = actCuentaDestinoRequest;
		actCuentaDestinoResponse = new ActCuentaDestinoResponse();
		actCuentaDestinoResponse.setCuentaTranID("0");
		actCuentaDestinoResponse.setClienteID("0");
		
		if(     isClienteIDValid()  &
				isCuentaTranIDValid()  &
				isBancoValid()  &
				isTipoCuentaSpeiValid()  &
				isCuentaValid()  &
				isBeneficiarioValid()  &
				isAliasValid()  &
				isUsuarioValid()  &
				isDireccionIPValid()  &
				isProgramaIDValid()  &
				isSucursalValid()  
				){
			actCuentaDestinoResponse.setCodigoRespuesta("0");
			actCuentaDestinoResponse.setMensajeRespuesta("Request válido");
		}
		
		return actCuentaDestinoResponse;
	}

		
}
