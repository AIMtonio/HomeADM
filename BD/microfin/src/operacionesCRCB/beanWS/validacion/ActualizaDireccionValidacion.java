package operacionesCRCB.beanWS.validacion;

import herramientas.Constantes;
import herramientas.Utileria;
import operacionesCRCB.beanWS.request.ActualizaDireccionRequest;
import operacionesCRCB.beanWS.response.ActualizaDireccionResponse;


public class ActualizaDireccionValidacion  {
	
	private ActualizaDireccionRequest actualizaDireccionRequest = null;
	private ActualizaDireccionResponse actualizaDireccionResponse = null;
	
	
	public boolean isEstadoIDValid(){
		  if ( actualizaDireccionRequest.getEstadoID().equals(Constantes.STRING_VACIO)){  
		      actualizaDireccionResponse.setCodigoRespuesta("2");
		      actualizaDireccionResponse.setMensajeRespuesta("El Estado está vacío");
		      return false;
		  }
		  
		  if ( !Utileria.esNumero(actualizaDireccionRequest.getEstadoID())){  
		      actualizaDireccionResponse.setCodigoRespuesta("400");
		      actualizaDireccionResponse.setMensajeRespuesta("El Estado es Inválido");
		      return false;
		  }
		  return true;
		}
	
	public boolean isMunicipioIDValid(){
		  if ( actualizaDireccionRequest.getMunicipioID().equals(Constantes.STRING_VACIO)){  
		      actualizaDireccionResponse.setCodigoRespuesta("3");
		      actualizaDireccionResponse.setMensajeRespuesta("El Municipio está vacío");
		      return false;
		  }
		  
		  if (!Utileria.esNumero(actualizaDireccionRequest.getMunicipioID())){  
		      actualizaDireccionResponse.setCodigoRespuesta("400");
		      actualizaDireccionResponse.setMensajeRespuesta("El Municipio es Inválido");
		      return false;
		  }
		  
		  return true;
		}
	
	public boolean isCalleValid(){
		  if ( actualizaDireccionRequest.getCalle().equals(Constantes.STRING_VACIO)){  
		      actualizaDireccionResponse.setCodigoRespuesta("4");
		      actualizaDireccionResponse.setMensajeRespuesta("La Calle está vacía");
		      return false;
		  }
		  
		  
		  
		  return true;
		}
	
	public boolean isNumeroCasaValid(){
		  if ( actualizaDireccionRequest.getNumeroCasa().equals(Constantes.STRING_VACIO)){  
		      actualizaDireccionResponse.setCodigoRespuesta("5");
		      actualizaDireccionResponse.setMensajeRespuesta("El Numero esta vacío");
		      return false;
		  }
		  return true;
		}
	
	public boolean isColoniaIDValid(){
		  if ( actualizaDireccionRequest.getColoniaID().equals(Constantes.STRING_VACIO)){  
		      actualizaDireccionResponse.setCodigoRespuesta("6");
		      actualizaDireccionResponse.setMensajeRespuesta("La Colonia está vacía");
		      return false;
		  }
		  
		  if (!Utileria.esNumero(actualizaDireccionRequest.getColoniaID())){  
		      actualizaDireccionResponse.setCodigoRespuesta("400");
		      actualizaDireccionResponse.setMensajeRespuesta("La Colonia es Inválida");
		      return false;
		  }
		  
		  
		  return true;
		}
	
	
	public boolean isLocalidadIDValid(){
		  if ( actualizaDireccionRequest.getLocalidadID().equals(Constantes.STRING_VACIO)){  
		      actualizaDireccionResponse.setCodigoRespuesta("8");
		      actualizaDireccionResponse.setMensajeRespuesta("La Localidad está vacía");
		      return false;
		  }
		  
		  if (!Utileria.esNumero(actualizaDireccionRequest.getLocalidadID())){  
		      actualizaDireccionResponse.setCodigoRespuesta("400");
		      actualizaDireccionResponse.setMensajeRespuesta("La Localidad es Inválida");
		      return false;
		  }
		  
		  return true;
		}
	
	
	
	public boolean isClienteIDValid(){
		  if ( actualizaDireccionRequest.getClienteID().equals(Constantes.STRING_VACIO)){  
		      actualizaDireccionResponse.setCodigoRespuesta("10");
		      actualizaDireccionResponse.setMensajeRespuesta("El Cliente está vacío");
		      return false;
		  }
		  
		  
		  if (!Utileria.esNumero(actualizaDireccionRequest.getClienteID())){  
		      actualizaDireccionResponse.setCodigoRespuesta("400");
		      actualizaDireccionResponse.setMensajeRespuesta("El Cliente es Inválido");
		      return false;
		  }
		  
		  return true;
		}

		public boolean isDireccionIDValid(){
		  if ( actualizaDireccionRequest.getDireccionID().equals(Constantes.STRING_VACIO)){  
		      actualizaDireccionResponse.setCodigoRespuesta("11");
		      actualizaDireccionResponse.setMensajeRespuesta("La Dirección está vacía");
		      return false;
		  }
		  
		  
		  if (!Utileria.esNumero(actualizaDireccionRequest.getDireccionID())){  
		      actualizaDireccionResponse.setCodigoRespuesta("400");
		      actualizaDireccionResponse.setMensajeRespuesta("La Dirección es Inválida");
		      return false;
		  }
		  
		  return true;
		}

		public boolean isTipoDireccionIDValid(){
		  if ( actualizaDireccionRequest.getTipoDireccionID().equals(Constantes.STRING_VACIO)){  
		      actualizaDireccionResponse.setCodigoRespuesta("12");
		      actualizaDireccionResponse.setMensajeRespuesta("El Tipo de Dirección está vacío");
		      return false;
		  }
		  
		  
		  if (!Utileria.esNumero(actualizaDireccionRequest.getTipoDireccionID())){  
		      actualizaDireccionResponse.setCodigoRespuesta("400");
		      actualizaDireccionResponse.setMensajeRespuesta("El Tipo de Dirección es Inválido");
		      return false;
		  }
		  
		  return true;
		}
		

		public boolean isOficialValid(){
		  if ( actualizaDireccionRequest.getOficial().equals(Constantes.STRING_VACIO)){  
		      actualizaDireccionResponse.setCodigoRespuesta("13");
		      actualizaDireccionResponse.setMensajeRespuesta("Indique si la Dirección es oficial");
		      return false;
		  }
		  
		  return true;
		}

		public boolean isFiscalValid(){
		  if ( actualizaDireccionRequest.getFiscal().equals(Constantes.STRING_VACIO)){  
		      actualizaDireccionResponse.setCodigoRespuesta("14");
		      actualizaDireccionResponse.setMensajeRespuesta("Indique si la Dirección es fiscal");
		      return false;
		  }
		  return true;
		}

		public boolean isUsuarioValid(){
		  if ( actualizaDireccionRequest.getUsuario().equals(Constantes.STRING_VACIO)){  
		      actualizaDireccionResponse.setCodigoRespuesta("901");
		      actualizaDireccionResponse.setMensajeRespuesta("Campo Usuario Auditoría vacío");
		      return false;
		  }
		  
		  if (!Utileria.esNumero(actualizaDireccionRequest.getUsuario())){  
		      actualizaDireccionResponse.setCodigoRespuesta("400");
		      actualizaDireccionResponse.setMensajeRespuesta("Campo Usuario Auditoría Inválido");
		      return false;
		  }
		  
		  return true;
		}

		public boolean isDireccionIPValid(){
		  if ( actualizaDireccionRequest.getDireccionIP().equals(Constantes.STRING_VACIO)){  
		      actualizaDireccionResponse.setCodigoRespuesta("902");
		      actualizaDireccionResponse.setMensajeRespuesta("Campo DireccionIP Auditoría vacío");
		      return false;
		  }
		  return true;
		}

		public boolean isProgramaIDValid(){
		  if ( actualizaDireccionRequest.getProgramaID().equals(Constantes.STRING_VACIO)){  
		      actualizaDireccionResponse.setCodigoRespuesta("903");
		      actualizaDireccionResponse.setMensajeRespuesta("Campo ProgramaID Auditoría vacío");
		      return false;
		  }
		  return true;
		}

		public boolean isSucursalValid(){
		  if ( actualizaDireccionRequest.getSucursal().equals(Constantes.STRING_VACIO)){  
		      actualizaDireccionResponse.setCodigoRespuesta("904");
		      actualizaDireccionResponse.setMensajeRespuesta("Campo Sucursal Auditoría vacío");
		      return false;
		  }
		  
		  
		  if ( !Utileria.esNumero(actualizaDireccionRequest.getSucursal())){  
		      actualizaDireccionResponse.setCodigoRespuesta("400");
		      actualizaDireccionResponse.setMensajeRespuesta("Campo Sucursal Auditoría Inválido");
		      return false;
		  }
		  
		  return true;
		}
		
		public ActualizaDireccionResponse isRequestValid(ActualizaDireccionRequest actualizaDireccionRequest){
			this.actualizaDireccionRequest = actualizaDireccionRequest;
			actualizaDireccionResponse = new ActualizaDireccionResponse();
			
			if( isClienteIDValid()  &
					isDireccionIDValid()  &
					isTipoDireccionIDValid()  &
					isEstadoIDValid()  &
					isMunicipioIDValid()  &
					isLocalidadIDValid()  &
					isColoniaIDValid()  &
					isCalleValid()  &
					isNumeroCasaValid()  &
					isOficialValid()  &
					isFiscalValid()  &
					isUsuarioValid()  &
					isDireccionIPValid()  &
					isProgramaIDValid()  &
					isSucursalValid()  
					){
				actualizaDireccionResponse.setCodigoRespuesta("0");
				actualizaDireccionResponse.setMensajeRespuesta("Request válido");
			}
			
			return actualizaDireccionResponse;
		}


	
}
