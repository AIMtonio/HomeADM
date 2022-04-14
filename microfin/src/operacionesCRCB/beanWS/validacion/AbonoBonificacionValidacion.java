package operacionesCRCB.beanWS.validacion;

import herramientas.Constantes;
import herramientas.Utileria;
import operacionesCRCB.beanWS.request.AbonoBonificacionRequest;
import operacionesCRCB.beanWS.response.AbonoBonificacionResponse;

public class AbonoBonificacionValidacion {
	AbonoBonificacionRequest abonoBonificacionRequest = null;
	AbonoBonificacionResponse abonoBonificacionResponse = null;


	public AbonoBonificacionResponse isRequestValid(AbonoBonificacionRequest request){
		this.abonoBonificacionRequest = request;
		abonoBonificacionResponse = new AbonoBonificacionResponse();

		if( isCuentaIDValid() && isClienteIDValid() && isMontoValid() && isTipoDispersionValid() && isCuentaClabeValid()
			&& isMesesValid() && isUsuarioValid() && isDireccionIPValid() && isProgramaIDValid() && isSucursalValid()){
			abonoBonificacionResponse.setCodigoRespuesta("0");
			abonoBonificacionResponse.setMensajeRespuesta("Request válido");
		}
		return abonoBonificacionResponse;
	}


	private boolean isCuentaIDValid(){
		if(abonoBonificacionRequest.getCuentaID().equals(Constantes.STRING_VACIO) || abonoBonificacionRequest.getCuentaID().equals("?")){
			abonoBonificacionResponse.setCodigoRespuesta("1");
			abonoBonificacionResponse.setMensajeRespuesta("El Número de Cuenta esta Vacío.");
			return false;
		}

		if(!Utileria.esLong(abonoBonificacionRequest.getCuentaID())){
			abonoBonificacionResponse.setCodigoRespuesta("011");
			abonoBonificacionResponse.setMensajeRespuesta("El Número de Cuenta es incorrecto.");
			return false;
		}
		return true;
	}


	private boolean isClienteIDValid(){
		if(abonoBonificacionRequest.getClienteID().equals(Constantes.STRING_VACIO) || abonoBonificacionRequest.getClienteID().equals("?")){
			abonoBonificacionResponse.setCodigoRespuesta("2");
			abonoBonificacionResponse.setMensajeRespuesta("El Número de Cliente esta Vacío.");
			return false;
		}

		if(!Utileria.esNumero(abonoBonificacionRequest.getClienteID())){
			abonoBonificacionResponse.setCodigoRespuesta("012");
			abonoBonificacionResponse.setMensajeRespuesta("El Número de Cliente es incorrecto.");
			return false;
		}
		return true;
	}


	private boolean isMontoValid(){
		if (abonoBonificacionRequest.getMonto().equals(Constantes.STRING_VACIO) || abonoBonificacionRequest.getMonto().equals("?")){
			abonoBonificacionResponse.setCodigoRespuesta("3");
			abonoBonificacionResponse.setMensajeRespuesta("El Monto está vacío.");
			return false;
		}
		if (!Utileria.esDouble(abonoBonificacionRequest.getMonto())){
			abonoBonificacionResponse.setCodigoRespuesta("013");
			abonoBonificacionResponse.setMensajeRespuesta("Monto Incorrecto.");
			return false;
		}
		if(Utileria.eliminaDecimales(abonoBonificacionRequest.getMonto()).length() > 10){
			abonoBonificacionResponse.setCodigoRespuesta("023");
			abonoBonificacionResponse.setMensajeRespuesta("Monto Incorrecto.");
			return false;
		}
		return true;
	}


	private boolean isTipoDispersionValid(){
		if (abonoBonificacionRequest.getTipoDispersion().equals(Constantes.STRING_VACIO) || abonoBonificacionRequest.getTipoDispersion().equals("?")){
			abonoBonificacionResponse.setCodigoRespuesta("5");
			abonoBonificacionResponse.setMensajeRespuesta("El Tipo de Dispersión está Vacío.");
			return false;
		}
		if (abonoBonificacionRequest.getTipoDispersion().length() > 1){
			abonoBonificacionResponse.setCodigoRespuesta("015");
			abonoBonificacionResponse.setMensajeRespuesta("Tipo de Dispersión Incorrecto.");
			return false;
		}
		return true;
	}


	private boolean isCuentaClabeValid(){
		if(abonoBonificacionRequest.getTipoDispersion().equals("S")){
			if (abonoBonificacionRequest.getCuentaClabe().equals(Constantes.STRING_VACIO) || abonoBonificacionRequest.getCuentaClabe().equals("?")){
				abonoBonificacionResponse.setCodigoRespuesta("6");
				abonoBonificacionResponse.setMensajeRespuesta("La Cuenta Clabe está Vacía.");
				return false;
			}

			if (abonoBonificacionRequest.getCuentaClabe().length() != 18){
				abonoBonificacionResponse.setCodigoRespuesta("016");
				abonoBonificacionResponse.setMensajeRespuesta("La Cuenta Clabe debe ser de 18 caracteres.");
				return false;
			}
		}

		return true;
	}


	private boolean isMesesValid(){
		if(abonoBonificacionRequest.getMeses().equals(Constantes.STRING_VACIO) || abonoBonificacionRequest.getMeses().equals("?")){
			abonoBonificacionResponse.setCodigoRespuesta("7");
			abonoBonificacionResponse.setMensajeRespuesta("Los Meses están Vacíos.");
			return false;
		}

		if(!Utileria.esNumero(abonoBonificacionRequest.getMeses())){
			abonoBonificacionResponse.setCodigoRespuesta("17");
			abonoBonificacionResponse.setMensajeRespuesta("El Número de Meses es incorrecto.");
			return false;
		}

		if(abonoBonificacionRequest.getMeses().length() > 5){
			abonoBonificacionResponse.setCodigoRespuesta("27");
			abonoBonificacionResponse.setMensajeRespuesta("El Número de Meses es incorrecto.");
			return false;
		}
		return true;
	}


	private boolean isUsuarioValid(){
		if(abonoBonificacionRequest.getUsuario().equals(Constantes.STRING_VACIO) || abonoBonificacionRequest.getUsuario().equals("?")){
			abonoBonificacionResponse.setCodigoRespuesta("8");
			abonoBonificacionResponse.setMensajeRespuesta("El Usuario está vacío.");
			return false;
		}

		if(!Utileria.esNumero(abonoBonificacionRequest.getUsuario())){
			abonoBonificacionResponse.setCodigoRespuesta("18");
			abonoBonificacionResponse.setMensajeRespuesta("El Número de Usuario es incorrecto.");
			return false;
		}

		if(abonoBonificacionRequest.getUsuario().length() > 5){
			abonoBonificacionResponse.setCodigoRespuesta("28");
			abonoBonificacionResponse.setMensajeRespuesta("El Número de Usuario es incorrecto.");
			return false;
		}
		return true;
	}


	private boolean isDireccionIPValid(){
		if(abonoBonificacionRequest.getDireccionIP().equals(Constantes.STRING_VACIO) || abonoBonificacionRequest.getDireccionIP().equals("?")){
			abonoBonificacionResponse.setCodigoRespuesta("9");
			abonoBonificacionResponse.setMensajeRespuesta("La Direccion IP está vacía");
			return false;
		}

		if(abonoBonificacionRequest.getDireccionIP().length() > 15){
			abonoBonificacionResponse.setCodigoRespuesta("19");
			abonoBonificacionResponse.setMensajeRespuesta("La Direccion IP es incorrecta.");
			return false;
		}
		return true;
	}


	private boolean isProgramaIDValid(){
		if(abonoBonificacionRequest.getProgramaID().equals(Constantes.STRING_VACIO) || abonoBonificacionRequest.getProgramaID().equals("?")){
			abonoBonificacionResponse.setCodigoRespuesta("10");
			abonoBonificacionResponse.setMensajeRespuesta("El Programa ID está vacío.");
			return false;
		}

		if(abonoBonificacionRequest.getProgramaID().length() > 50){
			abonoBonificacionResponse.setCodigoRespuesta("20");
			abonoBonificacionResponse.setMensajeRespuesta("El Programa ID es incorrecto.");
			return false;
		}
		return true;
	}


	private boolean isSucursalValid(){
		if(abonoBonificacionRequest.getSucursal().equals(Constantes.STRING_VACIO) || abonoBonificacionRequest.getSucursal().equals("?")){
			abonoBonificacionResponse.setCodigoRespuesta("30");
			abonoBonificacionResponse.setMensajeRespuesta("El número de Sucursal está vacío.");
			return false;
		}

		if(!Utileria.esNumero(abonoBonificacionRequest.getSucursal())){
			abonoBonificacionResponse.setCodigoRespuesta("31");
			abonoBonificacionResponse.setMensajeRespuesta("El número de Sucursal es incorrecto.");
			return false;
		}

		if(abonoBonificacionRequest.getSucursal().length() > 10){
			abonoBonificacionResponse.setCodigoRespuesta("32");
			abonoBonificacionResponse.setMensajeRespuesta("El número de Sucursal es incorrecto.");
			return false;
		}
		return true;
	}
}
