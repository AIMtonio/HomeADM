package operacionesCRCB.beanWS.validacion;


import herramientas.Constantes;
import herramientas.Utileria;
import operacionesCRCB.beanWS.request.AltaCedesRequest;
import operacionesCRCB.beanWS.response.AltaCedesResponse;

public class AltaCedesValidacion {

  private AltaCedesResponse altaCedesResponse = null;
  private AltaCedesRequest altaCedesRequest = null;
  
    public boolean isClienteIDValid(){
      if(altaCedesRequest.getClienteID().equals(Constantes.STRING_VACIO) || altaCedesRequest.getClienteID().equals("?")){  

          altaCedesResponse.setCodigoRespuesta("20");
          altaCedesResponse.setMensajeRespuesta("El Numero de Cliente está vacío'");
          return false;
      }
      if (!Utileria.esNumero(altaCedesRequest.getClienteID())){
    	  altaCedesResponse.setCodigoRespuesta("4");
    	  altaCedesResponse.setMensajeRespuesta("El Número de Cliente es Incorrecto.");
			
			return false;
		}
      return true;
    }

    public boolean isCuentaAhoIDValid(){
      if(altaCedesRequest.getCuentaAhoID().equals(Constantes.STRING_VACIO) || altaCedesRequest.getCuentaAhoID().equals("?")){

        altaCedesResponse.setCodigoRespuesta("2");
        altaCedesResponse.setMensajeRespuesta("El Numero Cuenta está vacío");
        return false;
      }
      if (!Utileria.esLong(altaCedesRequest.getCuentaAhoID())){
			altaCedesResponse.setCodigoRespuesta("400");
			altaCedesResponse.setMensajeRespuesta("El Número de Cuenta es Incorrecto.");
			return false;
		}
      return true;
    }

    public boolean isTipoInversionIDValid(){
      if(altaCedesRequest.getTipoCedeID().equals(Constantes.STRING_VACIO) || altaCedesRequest.getTipoCedeID().equals("?")){  

        altaCedesResponse.setCodigoRespuesta("21");
        altaCedesResponse.setMensajeRespuesta("El Tipo de CEDE está vacío");
        return false;
      }
      if (!Utileria.esNumero(altaCedesRequest.getTipoCedeID())){
    	  altaCedesResponse.setCodigoRespuesta("4");
    	  altaCedesResponse.setMensajeRespuesta("El Tipo de CEDE es Incorrecto.");
			
			return false;
		}
      return true;
    }
    
    public boolean isTipoPagoValid(){
    	if(altaCedesRequest.getTipoPago().equals(Constantes.STRING_VACIO) || altaCedesRequest.getTipoPago().equals("?")){  
	
	      altaCedesResponse.setCodigoRespuesta("22");
	      altaCedesResponse.setMensajeRespuesta("El Tipo de Pago está vacío");
	      return false;
	    }
    	if(altaCedesRequest.getTipoPago().length()>2){  
    		
  	      altaCedesResponse.setCodigoRespuesta("22");
  	      altaCedesResponse.setMensajeRespuesta("El Tipo de Pago es Incorrecto");
  	      return false;
  	    }
	    return true;
	  }
    
    public boolean isDiasPeriodoValid(){
        if(altaCedesRequest.getDiasPeriodo().equals("?")){  

          altaCedesResponse.setCodigoRespuesta("23");
          altaCedesResponse.setMensajeRespuesta("El Valor Días Periodo está vacío");
          return false;
        }
        return true;
      }

    public boolean isMontoValid(){
      if(altaCedesRequest.getMonto().equals(Constantes.STRING_VACIO) || altaCedesRequest.getMonto().equals("?")){  

        altaCedesResponse.setCodigoRespuesta("24");
        altaCedesResponse.setMensajeRespuesta("El Monto del CEDE está vacía");
        return false;
      }
      if (!Utileria.esDouble(altaCedesRequest.getMonto())){
    	  altaCedesResponse.setCodigoRespuesta("400");
    	  altaCedesResponse.setMensajeRespuesta("Monto Incorrecto.");
			return false;
		}
      return true;
    }

    public boolean isPlazoValid(){
      if(altaCedesRequest.getPlazo().equals(Constantes.STRING_VACIO) || altaCedesRequest.getPlazo().equals("?")){

        altaCedesResponse.setCodigoRespuesta("25");
        altaCedesResponse.setMensajeRespuesta("El Plazo del CEDE está vacío");
        return false;
      }
      
      if (!Utileria.esNumero(altaCedesRequest.getPlazo())){
      	altaCedesResponse.setCodigoRespuesta("25");
      	altaCedesResponse.setMensajeRespuesta("El Campo Plazo es Incorrecto.");
  		return false;
  	  }
      return true;
      
      
    }

    public boolean isTasaValid(){
      if(altaCedesRequest.getTasa().equals(Constantes.STRING_VACIO) || altaCedesRequest.getTasa().equals("?")){  

        altaCedesResponse.setCodigoRespuesta("26");
        altaCedesResponse.setMensajeRespuesta("La Tasa está vacía");
        return false;
      }
      
      if (!Utileria.esDouble(altaCedesRequest.getTasa())){
    	  altaCedesResponse.setCodigoRespuesta("26");
    	  altaCedesResponse.setMensajeRespuesta("Tasa Incorrecta.");
			return false;
		}
      return true;
    }
    
    public boolean isReinvertirValid(){
        if(altaCedesRequest.getReinvertir().equals("?")){  

          altaCedesResponse.setCodigoRespuesta("27");
          altaCedesResponse.setMensajeRespuesta("El Valor Reinvertir está vacío");
          return false;
        }
        if(altaCedesRequest.getReinvertir().length()>2){  
    		
    	      altaCedesResponse.setCodigoRespuesta("27");
    	      altaCedesResponse.setMensajeRespuesta("El Valor Reinvertir es Incorrecto");
    	      return false;
    	    }
        return true;
      }
    
    public boolean isTipoReinversion(){
        if(altaCedesRequest.getTipoReinversion().equals("?")){  

          altaCedesResponse.setCodigoRespuesta("28");
          altaCedesResponse.setMensajeRespuesta("El Tipo de Reinversión está vacío");
          return false;
        }
        if(altaCedesRequest.getTipoReinversion().length()>2){  
    		
  	      altaCedesResponse.setCodigoRespuesta("28");
  	      altaCedesResponse.setMensajeRespuesta("El Tipo de Reinversión es Incorrecto");
  	      return false;
  	    }
        return true;
      }

    public boolean isUsuarioValid(){
    if(altaCedesRequest.getUsuario().equals(Constantes.STRING_VACIO) || altaCedesRequest.getUsuario().equals("?")){  

        altaCedesResponse.setCodigoRespuesta("901");
        altaCedesResponse.setMensajeRespuesta("Campo Usuario Auditoría vacío");
        return false;
      }
    if (!Utileria.esNumero(altaCedesRequest.getUsuario())){
    	altaCedesResponse.setCodigoRespuesta("901");
    	altaCedesResponse.setMensajeRespuesta("Campo Usuario Auditoría Incorrecto.");
		return false;
	}
      return true;
    }

    public boolean isDireccionIPValid(){
      if(altaCedesRequest.getDireccionIP().equals(Constantes.STRING_VACIO) || altaCedesRequest.getDireccionIP().equals("?")){ 

        altaCedesResponse.setCodigoRespuesta("902");
        altaCedesResponse.setMensajeRespuesta("Campo DireccionIP Auditoría vacío");
        return false;
        }
      return true;
    }

    public boolean isProgramaIDValid(){
      if(altaCedesRequest.getProgramaID().equals(Constantes.STRING_VACIO) || altaCedesRequest.getProgramaID().equals("?")){ 

        altaCedesResponse.setCodigoRespuesta("903");
        altaCedesResponse.setMensajeRespuesta("Campo ProgramaID Auditoría vacío");
        return false;
      }
      return true;
    }
    
    public boolean isSucursalValid(){
      if(altaCedesRequest.getSucursal().equals(Constantes.STRING_VACIO) || altaCedesRequest.getSucursal().equals("?")){  
        
        altaCedesResponse.setCodigoRespuesta("904");
        altaCedesResponse.setMensajeRespuesta("Campo Sucursal Auditoría vacío");
        return false;
      }
      if (!Utileria.esNumero(altaCedesRequest.getSucursal())){
		  altaCedesResponse.setCodigoRespuesta("904");
		  altaCedesResponse.setMensajeRespuesta("Campo Sucursal Auditoría Incorrecto.");
		  return false;
      }
      return true;
    }


    public AltaCedesResponse isRequestValid(AltaCedesRequest altaRequest){
    this.altaCedesRequest = altaRequest;
    altaCedesResponse = new AltaCedesResponse();
    altaCedesResponse.setCEDEID("0");

      if(isClienteIDValid()  &
        isCuentaAhoIDValid()  &
        isTipoInversionIDValid()  &
        isTipoPagoValid () &
        isDiasPeriodoValid () &
        isMontoValid()  &
        isPlazoValid()  &
        isTasaValid()  &
        isReinvertirValid() &
        isTipoReinversion() &
        isUsuarioValid()  &
        isDireccionIPValid()  &
        isProgramaIDValid()  &
        isSucursalValid()   
        ){
        altaCedesResponse.setCodigoRespuesta("0");
        altaCedesResponse.setMensajeRespuesta("Request valido");
      }

      return altaCedesResponse;
      }

}
