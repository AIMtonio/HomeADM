package operacionesCRCB.beanWS.validacion;

import java.util.regex.Pattern;

import herramientas.Constantes;
import herramientas.Utileria;
import operacionesCRCB.beanWS.request.AltaInversionRequest;
import operacionesCRCB.beanWS.response.AltaInversionResponse;

public class AltaInversionValidacion {

  private AltaInversionResponse altaInversionResponse = null;
  private AltaInversionRequest altaInversionRequest = null;
  
    public boolean isClienteIDValid(){
      if(altaInversionRequest.getClienteID().equals(Constantes.STRING_VACIO) || altaInversionRequest.getClienteID().equals("?")){  

          altaInversionResponse.setCodigoRespuesta("20");
          altaInversionResponse.setMensajeRespuesta("El Numero de Cliente está vacío'");
          return false;
      }
      if (!Utileria.esNumero(altaInversionRequest.getClienteID())){
    	  altaInversionResponse.setCodigoRespuesta("4");
    	  altaInversionResponse.setMensajeRespuesta("El Número de Cliente es Incorrecto.");
			
			return false;
		}
      return true;
    }

    public boolean isCuentaAhoIDValid(){
      if(altaInversionRequest.getCuentaAhoID().equals(Constantes.STRING_VACIO) || altaInversionRequest.getCuentaAhoID().equals("?")){

        altaInversionResponse.setCodigoRespuesta("2");
        altaInversionResponse.setMensajeRespuesta("El Numero Cuenta está vacío");
        return false;
      }
      if (!Utileria.esLong(altaInversionRequest.getCuentaAhoID())){
			altaInversionResponse.setCodigoRespuesta("400");
			altaInversionResponse.setMensajeRespuesta("El Número de Cuenta es Incorrecto.");
			return false;
		}
      return true;
    }

    public boolean isTipoInversionIDValid(){
      if(altaInversionRequest.getTipoInversionID().equals(Constantes.STRING_VACIO) || altaInversionRequest.getTipoInversionID().equals("?")){  

        altaInversionResponse.setCodigoRespuesta("21");
        altaInversionResponse.setMensajeRespuesta("El Tipo de Inversión está vacío");
        return false;
      }
      return true;
    }

    public boolean isMontoValid(){
      if(altaInversionRequest.getMonto().equals(Constantes.STRING_VACIO) || altaInversionRequest.getMonto().equals("?")){  

        altaInversionResponse.setCodigoRespuesta("22");
        altaInversionResponse.setMensajeRespuesta("El Monto de la Inversión está vacía");
        return false;
      }
      if (!Utileria.esDouble(altaInversionRequest.getMonto())){
    	  altaInversionResponse.setCodigoRespuesta("400");
    	  altaInversionResponse.setMensajeRespuesta("Monto Incorrecto.");
			return false;
		}
      return true;
    }

    public boolean isPlazoValid(){
      if(altaInversionRequest.getPlazo().equals(Constantes.STRING_VACIO) || altaInversionRequest.getPlazo().equals("?")){

        altaInversionResponse.setCodigoRespuesta("23");
        altaInversionResponse.setMensajeRespuesta("El Plazo de la Inversión está vacía");
        return false;
      }
      return true;
    }

    public boolean isTasaValid(){
      if(altaInversionRequest.getTasa().equals(Constantes.STRING_VACIO) || altaInversionRequest.getTasa().equals("?")){  

        altaInversionResponse.setCodigoRespuesta("24");
        altaInversionResponse.setMensajeRespuesta("La Tasa de la Inversión está vacía");
        return false;
      }
      return true;
    }

    public boolean isUsuarioValid(){
    if(altaInversionRequest.getUsuario().equals(Constantes.STRING_VACIO) || altaInversionRequest.getUsuario().equals("?")){  

        altaInversionResponse.setCodigoRespuesta("901");
        altaInversionResponse.setMensajeRespuesta("Campo Usuario Auditoría vacío");
        return false;
      }
    if (!Utileria.esNumero(altaInversionRequest.getUsuario())){
    	altaInversionResponse.setCodigoRespuesta("901");
    	altaInversionResponse.setMensajeRespuesta("Campo Usuario Auditoría Incorrecto.");
		return false;
	}
      return true;
    }

    public boolean isDireccionIPValid(){
      if(altaInversionRequest.getDireccionIP().equals(Constantes.STRING_VACIO) || altaInversionRequest.getDireccionIP().equals("?")){ 

        altaInversionResponse.setCodigoRespuesta("902");
        altaInversionResponse.setMensajeRespuesta("Campo DireccionIP Auditoría vacío");
        return false;
        }
      return true;
    }

    public boolean isProgramaIDValid(){
      if(altaInversionRequest.getProgramaID().equals(Constantes.STRING_VACIO) || altaInversionRequest.getProgramaID().equals("?")){ 

        altaInversionResponse.setCodigoRespuesta("903");
        altaInversionResponse.setMensajeRespuesta("Campo ProgramaID Auditoría vacío");
        return false;
      }
      return true;
    }
    
    public boolean isSucursalValid(){
      if(altaInversionRequest.getSucursal().equals(Constantes.STRING_VACIO) || altaInversionRequest.getSucursal().equals("?")){  
        
        altaInversionResponse.setCodigoRespuesta("904");
        altaInversionResponse.setMensajeRespuesta("Campo Sucursal Auditoría vacío");
        return false;
      }
      if (!Utileria.esNumero(altaInversionRequest.getSucursal())){
		  altaInversionResponse.setCodigoRespuesta("904");
		  altaInversionResponse.setMensajeRespuesta("Campo Sucursal Auditoría Incorrecto.");
		  return false;
      }
      return true;
    }


    public AltaInversionResponse isRequestValid(AltaInversionRequest altaInversionRequest){
    this.altaInversionRequest = altaInversionRequest;
    altaInversionResponse = new AltaInversionResponse();
    altaInversionResponse.setInversionID("0");

      if(     isClienteIDValid()  &
        isCuentaAhoIDValid()  &
        isTipoInversionIDValid()  &
        isMontoValid()  &
        isPlazoValid()  &
        isTasaValid()  &
        isUsuarioValid()  &
        isDireccionIPValid()  &
        isProgramaIDValid()  &
        isSucursalValid()   
        ){
        altaInversionResponse.setCodigoRespuesta("0");
        altaInversionResponse.setMensajeRespuesta("Request valido");
      }

      return altaInversionResponse;
      }

}
