package operacionesCRCB.beanWS.validacion;

import herramientas.Constantes;
import herramientas.Utileria;
import operacionesCRCB.beanWS.request.AltaCreditoRequest;
import operacionesCRCB.beanWS.response.AltaCreditoResponse;

public class AltaCreditoValidacion {
	
	private AltaCreditoRequest altaCreditoRequest = null;
	private AltaCreditoResponse altaCreditoResponse = null;
	
	public static interface Cons_Credito {
		String mensual = "M";
		String spei   = "S";
		String aniversario = "A";
	}
	
	public boolean isClienteIDValid(){
	altaCreditoRequest.setClienteID(altaCreditoRequest.getClienteID().replace("?", Constantes.STRING_VACIO));
	  if ( altaCreditoRequest.getClienteID().equals(Constantes.STRING_VACIO)){  
	      altaCreditoResponse.setCodigoRespuesta("1");
	      altaCreditoResponse.setMensajeRespuesta("El Cliente está Vacío."); 
	      return false;
	  }
	  if (! Utileria.esNumero(altaCreditoRequest.getClienteID()) ){
		  altaCreditoResponse.setCodigoRespuesta("400"); 
		  altaCreditoResponse.setMensajeRespuesta("El Formato del Cliente es Inválido."); 
		  return false; 
	  }
	  return true;
	}
	
	
	public boolean isMontoValid(){
	altaCreditoRequest.setMonto(altaCreditoRequest.getMonto().replace("?", Constantes.STRING_VACIO));
	  if ( altaCreditoRequest.getMonto().equals(Constantes.STRING_VACIO)){  
	      altaCreditoResponse.setCodigoRespuesta("3");
	      altaCreditoResponse.setMensajeRespuesta("El Monto Solicitado está Vacío.");
	      return false;
	  }
	  if (! Utileria.esDouble(altaCreditoRequest.getMonto()) ){
	      altaCreditoResponse.setCodigoRespuesta("400");
	      altaCreditoResponse.setMensajeRespuesta("El Formato del Monto Solicitado es Inválido."); 
	      return false;
	  }
	  return true;
	}

	
	public boolean isProductoCreditoIDValid(){
	altaCreditoRequest.setProductoCreditoID(altaCreditoRequest.getProductoCreditoID().replace("?", Constantes.STRING_VACIO));
	  if ( altaCreditoRequest.getProductoCreditoID().equals(Constantes.STRING_VACIO)){  
	      altaCreditoResponse.setCodigoRespuesta("4");
	      altaCreditoResponse.setMensajeRespuesta("El Producto de Crédito Solicitado está Vacío.");
	      return false;
	  }
	  if (! Utileria.esNumero(altaCreditoRequest.getProductoCreditoID()) ){
		  altaCreditoResponse.setCodigoRespuesta("400"); 
		  altaCreditoResponse.setMensajeRespuesta("El Formato del Producto de Crédito es Inválido."); 
		  return false; 
	  }
	  return true;
	}

		
	public boolean isTasaFijaValid(){
	altaCreditoRequest.setTasaFija(altaCreditoRequest.getTasaFija().replace("?", Constantes.STRING_VACIO));
	  if ( altaCreditoRequest.getTasaFija().equals(Constantes.STRING_VACIO)){  
	      altaCreditoResponse.setCodigoRespuesta("5");
	      altaCreditoResponse.setMensajeRespuesta("La Tasa Fija Solicitada está Vacía.");
	      return false;
	  }
	  if (! Utileria.esDouble(altaCreditoRequest.getTasaFija()) ){
	      altaCreditoResponse.setCodigoRespuesta("400");
	      altaCreditoResponse.setMensajeRespuesta("El Formato de la Tasa Fija Solicitada es Inválido."); 
	      return false;
	  }
	  return true;
	}
		
	public boolean isPlazoIDValid(){
	altaCreditoRequest.setPlazoID(altaCreditoRequest.getPlazoID().replace("?", Constantes.STRING_VACIO));
	  if ( altaCreditoRequest.getPlazoID().equals(Constantes.STRING_VACIO)){  
	      altaCreditoResponse.setCodigoRespuesta("6");
	      altaCreditoResponse.setMensajeRespuesta("El Plazo está Vacío.");
	      return false;
	  }
	  if (! Utileria.esNumero(altaCreditoRequest.getPlazoID()) ){
		  altaCreditoResponse.setCodigoRespuesta("400"); 
		  altaCreditoResponse.setMensajeRespuesta("El Formato del Plazo es Inválido."); 
		  return false; 
	  }
	  return true;
	}
		
	public boolean isFrecuenciaValid(){
	altaCreditoRequest.setFrecuencia(altaCreditoRequest.getFrecuencia().replace("?", Constantes.STRING_VACIO));
	  if ( altaCreditoRequest.getFrecuencia().equals(Constantes.STRING_VACIO)){  
	      altaCreditoResponse.setCodigoRespuesta("7");
	      altaCreditoResponse.setMensajeRespuesta("La Frecuencia está Vacía."); 
	      return false;
	  }
	  return true;
	}
	
	public boolean isTipoDispersionValid(){
	altaCreditoRequest.setTipoDispersion(altaCreditoRequest.getTipoDispersion().replace("?", Constantes.STRING_VACIO));
	  if ( altaCreditoRequest.getTipoDispersion().equals(Constantes.STRING_VACIO)){  
	      altaCreditoResponse.setCodigoRespuesta("14");
	      altaCreditoResponse.setMensajeRespuesta("El Tipo de Dispersión está Vacío.");
	      return false;
	  }
	  return true;
	}
		
		
	public boolean isDestinoCreditoValid(){
	altaCreditoRequest.setDestinoCredito(altaCreditoRequest.getDestinoCredito().replace("?", Constantes.STRING_VACIO));
	  if ( altaCreditoRequest.getDestinoCredito().equals(Constantes.STRING_VACIO)){  
	      altaCreditoResponse.setCodigoRespuesta("17");
	      altaCreditoResponse.setMensajeRespuesta("El Destino de Crédito está Vacío.");
	      return false;
	  }
	  if (! Utileria.esNumero(altaCreditoRequest.getDestinoCredito()) ){
		  altaCreditoResponse.setCodigoRespuesta("400"); 
		  altaCreditoResponse.setMensajeRespuesta("El Formato Destino de Crédito es Inválido."); 
		  return false; 
	  }
	  return true;
	}
		
	public boolean isCuentaClabeValid(){
	altaCreditoRequest.setCuentaClabe(altaCreditoRequest.getCuentaClabe().replace("?", Constantes.STRING_VACIO));
	  if ( altaCreditoRequest.getTipoDispersion().equals(Cons_Credito.spei) & altaCreditoRequest.getCuentaClabe().equals(Constantes.STRING_VACIO)){  
	      altaCreditoResponse.setCodigoRespuesta("20");
	      altaCreditoResponse.setMensajeRespuesta("La Cuenta CLABE está Vacía.");
	      return false;
	  }
	  return true;
	}
	
	public boolean isMontoPorComAperValid(){
	altaCreditoRequest.setMontoPorComAper(altaCreditoRequest.getMontoPorComAper().replace("?", Constantes.STRING_VACIO));
	  if ( altaCreditoRequest.getMontoPorComAper().equals(Constantes.STRING_VACIO)){  
	      altaCreditoResponse.setCodigoRespuesta("30");
	      altaCreditoResponse.setMensajeRespuesta("El Monto de Comisión por Apertura está Vacío.");
	      return false;
	  }
	  if (! Utileria.esDouble(altaCreditoRequest.getMontoPorComAper()) ){
		  altaCreditoResponse.setCodigoRespuesta("400"); 
		  altaCreditoResponse.setMensajeRespuesta("El Formato Monto de Comisión por Apertura es Inválido."); 
		  return false; 
	  }
	  return true;
	}
	
	public boolean isPromotorIDValid(){
	altaCreditoRequest.setPromotorID(altaCreditoRequest.getPromotorID().replace("?", Constantes.STRING_VACIO));
	  if ( altaCreditoRequest.getPromotorID().equals(Constantes.STRING_VACIO)){  
	      altaCreditoResponse.setCodigoRespuesta("32");
	      altaCreditoResponse.setMensajeRespuesta("El Promotor está Vacío.");
	      return false;
	  }
	  if (! Utileria.esNumero(altaCreditoRequest.getPromotorID()) ){
		  altaCreditoResponse.setCodigoRespuesta("400"); 
		  altaCreditoResponse.setMensajeRespuesta("El Formato Promotor es Inválido."); 
		  return false; 
	  }
	  return true;
	}
	
	public boolean isDiaPagoValid(){
	altaCreditoRequest.setDiaPago(altaCreditoRequest.getDiaPago().replace("?", Constantes.STRING_VACIO));
	  if ( altaCreditoRequest.getDiaPago().equals(Constantes.STRING_VACIO) &  altaCreditoRequest.getFrecuencia().equals(Cons_Credito.mensual)){  
	      altaCreditoResponse.setCodigoRespuesta("36");
	      altaCreditoResponse.setMensajeRespuesta("El Día de Pago está Vacío.");
	      return false;
	  }
	  return true;
	}
		
	public boolean isDiaMesPagoValid(){
	altaCreditoRequest.setDiaMesPago(altaCreditoRequest.getDiaMesPago().replace("?", Constantes.STRING_VACIO));
	  if ( altaCreditoRequest.getFrecuencia().equals(Cons_Credito.mensual) & altaCreditoRequest.getDiaPago().equals(Cons_Credito.aniversario) 
			  & altaCreditoRequest.getDiaMesPago().equals(Constantes.STRING_VACIO) ){  
	      altaCreditoResponse.setCodigoRespuesta("38");
	      altaCreditoResponse.setMensajeRespuesta("El Día de Mes del Pago está Vacío.");
	      return false;
	  }
	  if ( altaCreditoRequest.getFrecuencia().equals(Cons_Credito.mensual) & altaCreditoRequest.getDiaPago().equals(Cons_Credito.aniversario) &
			  ! Utileria.esNumero(altaCreditoRequest.getDiaMesPago()) ){
		  altaCreditoResponse.setCodigoRespuesta("400"); 
		  altaCreditoResponse.setMensajeRespuesta("El Formato Día de Mes del Pago es Inválido."); 
		  return false; 
	  }
	  return true;
	}


	public boolean isFechaIniPrimAmorValid(){
	altaCreditoRequest.setFechaIniPrimAmor(altaCreditoRequest.getFechaIniPrimAmor().replace("?", Constantes.STRING_VACIO));
	  if ( altaCreditoRequest.getFechaIniPrimAmor().equals(Constantes.STRING_VACIO)){  
	      altaCreditoResponse.setCodigoRespuesta("39");
	      altaCreditoResponse.setMensajeRespuesta("La Fecha de Inicio de las Amortizaciones está Vacía.");
	      return false;
	  }
	  if (! Utileria.esFecha(altaCreditoRequest.getFechaIniPrimAmor()) ){
		  altaCreditoResponse.setCodigoRespuesta("400"); 
		  altaCreditoResponse.setMensajeRespuesta("El Formato Fecha de Inicio de las Amortizaciones es Inválido."); 
		  return false; 
	  }
	  return true;
	}

	public boolean isUsuarioValid(){
	altaCreditoRequest.setUsuario(altaCreditoRequest.getUsuario().replace("?", Constantes.STRING_VACIO));
	  if ( altaCreditoRequest.getUsuario().equals(Constantes.STRING_VACIO)){  
	      altaCreditoResponse.setCodigoRespuesta("901");
	      altaCreditoResponse.setMensajeRespuesta("Campo Usuario de Auditoría Vacío.");
	      return false;
	  }
	  if (! Utileria.esNumero(altaCreditoRequest.getUsuario()) ){
		  altaCreditoResponse.setCodigoRespuesta("400"); 
		  altaCreditoResponse.setMensajeRespuesta("El Formato Usuario de Auditoría es Inválido."); 
		  return false; 
	  }
	  return true;
	}

	public boolean isDireccionIPValid(){
	altaCreditoRequest.setDireccionIP(altaCreditoRequest.getDireccionIP().replace("?", Constantes.STRING_VACIO));
	  if ( altaCreditoRequest.getDireccionIP().equals(Constantes.STRING_VACIO)){  
	      altaCreditoResponse.setCodigoRespuesta("902");
	      altaCreditoResponse.setMensajeRespuesta("Campo Dirección IP de Auditoría Vacío.");
	      return false;
	  }
	  return true;
	}

	public boolean isProgramaIDValid(){
	altaCreditoRequest.setProgramaID(altaCreditoRequest.getProgramaID().replace("?", Constantes.STRING_VACIO));
	  if ( altaCreditoRequest.getProgramaID().equals(Constantes.STRING_VACIO)){  
	      altaCreditoResponse.setCodigoRespuesta("903");
	      altaCreditoResponse.setMensajeRespuesta("Campo Programa de Auditoría Vacío.");
	      return false;
	  }
	  return true;
	}

	public boolean isSucursalValid(){
	altaCreditoRequest.setSucursal(altaCreditoRequest.getSucursal().replace("?", Constantes.STRING_VACIO));
	  if ( altaCreditoRequest.getSucursal().equals(Constantes.STRING_VACIO)){  
	      altaCreditoResponse.setCodigoRespuesta("904");
	      altaCreditoResponse.setMensajeRespuesta("Campo Sucursal de Auditoría Vacío.");
	      return false;
	  }
	  if (! Utileria.esNumero(altaCreditoRequest.getSucursal()) ){
		  altaCreditoResponse.setCodigoRespuesta("400"); 
		  altaCreditoResponse.setMensajeRespuesta("El Formato Sucursal de Auditoría es Inválido."); 
		  return false; 
	  }
	  return true;
	}
	
	public boolean isTipoConsultaSICValid(){
	altaCreditoRequest.setTipoConsultaSIC(altaCreditoRequest.getTipoConsultaSIC().replace("?", Constantes.STRING_VACIO));
	  if ( altaCreditoRequest.getTipoConsultaSIC().equals(Constantes.STRING_VACIO)){  
	      altaCreditoResponse.setCodigoRespuesta("40");
	      altaCreditoResponse.setMensajeRespuesta("El Tipo de Consulta SIC está Vacío.");
	      return false;
	  }
	  if (altaCreditoRequest.getTipoConsultaSIC().length()>2){
		  altaCreditoResponse.setCodigoRespuesta("41"); 
		  altaCreditoResponse.setMensajeRespuesta("El Formato de Tipo de Consulta SIC es Inválido."); 
		  return false; 
	  }
	  return true;
	}
	
	public boolean isFolioConsultaSICValid(){
		altaCreditoRequest.setFolioConsultaSIC(altaCreditoRequest.getFolioConsultaSIC().replace("?", Constantes.STRING_VACIO));
		  if ( altaCreditoRequest.getFolioConsultaSIC().equals(Constantes.STRING_VACIO)){  
		      altaCreditoResponse.setCodigoRespuesta("42");
		      altaCreditoResponse.setMensajeRespuesta("El Folio de Consulta SIC está Vacío.");
		      return false;
		  }
		  return true;
		}
		
	public AltaCreditoResponse isRequestValid(AltaCreditoRequest altaCreditoRequest){
		this.altaCreditoRequest = altaCreditoRequest;
		altaCreditoResponse  = new AltaCreditoResponse();
		altaCreditoResponse.setCreditoID("0");
		altaCreditoResponse.setCuentaAhoID("0");
		
		if(		isClienteIDValid() &
				isProductoCreditoIDValid() &
				isMontoValid() &
				isTasaFijaValid() &
				isFrecuenciaValid() &
				isDiaPagoValid() &
				isPlazoIDValid() &
				isDestinoCreditoValid() &
				isTipoDispersionValid() &
				isMontoPorComAperValid() &
				isPromotorIDValid() &
				isFechaIniPrimAmorValid() &
				isUsuarioValid() &
				isDireccionIPValid() &
				isProgramaIDValid() &
				isSucursalValid() &
				isDiaMesPagoValid() &
				isCuentaClabeValid() &
				isTipoConsultaSICValid() &
				isFolioConsultaSICValid()
				){
			altaCreditoResponse.setCodigoRespuesta("0");
			altaCreditoResponse.setMensajeRespuesta("Request Válido");
		}
		
		return altaCreditoResponse;
	}
}
