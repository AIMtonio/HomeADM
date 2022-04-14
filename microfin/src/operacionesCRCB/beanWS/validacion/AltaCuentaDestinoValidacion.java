package operacionesCRCB.beanWS.validacion;

import java.util.regex.Pattern;

import herramientas.Constantes;
import herramientas.Utileria;
import operacionesCRCB.beanWS.request.AltaCuentaDestinoRequest;
import operacionesCRCB.beanWS.response.AltaCuentaDestinoResponse;

public class AltaCuentaDestinoValidacion {
	
	private AltaCuentaDestinoRequest altaCuentaDestinoRequest = null;
	private AltaCuentaDestinoResponse altaCuentaDestinoResponse = null;
	
	public boolean isClienteIDValid(){
		if (altaCuentaDestinoRequest.getClienteID().equals(Constantes.STRING_VACIO) || altaCuentaDestinoRequest.getClienteID().equals("?")){  

			altaCuentaDestinoResponse.setCodigoRespuesta("4");
			altaCuentaDestinoResponse.setMensajeRespuesta("El Cliente está vacío");

			return false;
		}
		if (!Utileria.esNumero(altaCuentaDestinoRequest.getClienteID())){
			altaCuentaDestinoResponse.setCodigoRespuesta("400");
			altaCuentaDestinoResponse.setMensajeRespuesta("El Número de Cliente es Incorrecto.");
			
			return false;
		}
	return true;
	}

	public boolean isBancoValid(){
		if (altaCuentaDestinoRequest.getBanco().equals(Constantes.STRING_VACIO) || altaCuentaDestinoRequest.getBanco().equals("?")){

			altaCuentaDestinoResponse.setCodigoRespuesta("5");
			altaCuentaDestinoResponse.setMensajeRespuesta("El Banco está vacío");

			return false;
		}
	return true;
	}

	public boolean isTipoCuentaSpeiValid(){
		if (altaCuentaDestinoRequest.getTipoCuentaSpei().equals(Constantes.STRING_VACIO) || altaCuentaDestinoRequest.getTipoCuentaSpei().equals("?")){ 

			altaCuentaDestinoResponse.setCodigoRespuesta("6");
			altaCuentaDestinoResponse.setMensajeRespuesta("El Tipo de Cuenta Spei está vacío");

			return false;
		}
	return true;
	}

	public boolean isCuentaValid(){
		if (altaCuentaDestinoRequest.getCuenta().equals(Constantes.STRING_VACIO) || altaCuentaDestinoRequest.getCuenta().equals("?")){  

			altaCuentaDestinoResponse.setCodigoRespuesta("7");
			altaCuentaDestinoResponse.setMensajeRespuesta("El Número de Cuenta está vacío");
			return false;
		}
		
	return true;
	}

	public boolean isBeneficiarioValid(){
		if (altaCuentaDestinoRequest.getBeneficiario().equals(Constantes.STRING_VACIO) || altaCuentaDestinoRequest.getBeneficiario().equals("?")){ 

			altaCuentaDestinoResponse.setCodigoRespuesta("8");
			altaCuentaDestinoResponse.setMensajeRespuesta("El Beneficiario está vacío");
			return false;
		}
	return true;
	}

	public boolean isAliasValid(){
		if (altaCuentaDestinoRequest.getAlias().equals(Constantes.STRING_VACIO) || altaCuentaDestinoRequest.getAlias().equals("?")){  

			altaCuentaDestinoResponse.setCodigoRespuesta("9");
			altaCuentaDestinoResponse.setMensajeRespuesta("El Alias de la Cuenta está vacío");
			return false;
		}
	return true;
	}

	public boolean isUsuarioValid(){
		if (altaCuentaDestinoRequest.getUsuario().equals(Constantes.STRING_VACIO) || altaCuentaDestinoRequest.getUsuario().equals("?")){  

			altaCuentaDestinoResponse.setCodigoRespuesta("901");
			altaCuentaDestinoResponse.setMensajeRespuesta("Campo Usuario vacío");
			return false;
		}
		if (!Utileria.esNumero(altaCuentaDestinoRequest.getUsuario())){
			altaCuentaDestinoResponse.setCodigoRespuesta("901");
			altaCuentaDestinoResponse.setMensajeRespuesta("Campo Usuario Incorrecto.");
			return false;
		}
	return true;
	}

	public boolean isDireccionIPValid(){
		if (altaCuentaDestinoRequest.getDireccionIP().equals(Constantes.STRING_VACIO)|| altaCuentaDestinoRequest.getDireccionIP().equals("?")){ 

			altaCuentaDestinoResponse.setCodigoRespuesta("902");
			altaCuentaDestinoResponse.setMensajeRespuesta("Campo DireccionIP vacío");
			return false;
		}
	return true;
	}

	public boolean isProgramaIDValid(){
		if (altaCuentaDestinoRequest.getProgramaID().equals(Constantes.STRING_VACIO) || altaCuentaDestinoRequest.getProgramaID().equals("?")){  

			altaCuentaDestinoResponse.setCodigoRespuesta("903");
			altaCuentaDestinoResponse.setMensajeRespuesta("Campo ProgramaID vacío");
			return false;
		}
	return true;
	}

	public boolean isSucursalValid(){
		if (altaCuentaDestinoRequest.getSucursal().equals(Constantes.STRING_VACIO) || altaCuentaDestinoRequest.getSucursal().equals("?")){  

			altaCuentaDestinoResponse.setCodigoRespuesta("904");
			altaCuentaDestinoResponse.setMensajeRespuesta("Campo Sucursal vacío");
			return false;
		}
		if (!Utileria.esNumero(altaCuentaDestinoRequest.getSucursal())){
			altaCuentaDestinoResponse.setCodigoRespuesta("904");
			altaCuentaDestinoResponse.setMensajeRespuesta("Campo Sucursal Incorrecto.");
			return false;
		}
	return true;
	}

	public AltaCuentaDestinoResponse isRequestValid(AltaCuentaDestinoRequest altaCuentaDestinoRequest){

		this.altaCuentaDestinoRequest = altaCuentaDestinoRequest;
		altaCuentaDestinoResponse = new AltaCuentaDestinoResponse();
		altaCuentaDestinoResponse.setClienteID("0");
		altaCuentaDestinoResponse.setCuentaTranID("0");

		if(isClienteIDValid()  &
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
			altaCuentaDestinoResponse.setCodigoRespuesta("0");
			altaCuentaDestinoResponse.setMensajeRespuesta("Request válido");
		}

		return altaCuentaDestinoResponse;
	}
	
}
