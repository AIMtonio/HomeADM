package operacionesCRCB.beanWS.validacion;

import operacionesCRCB.beanWS.request.ConsultaCedesRequest;
import operacionesCRCB.beanWS.response.ConsultaCedesResponse;
import herramientas.Constantes;
import herramientas.Utileria;

public class ConsultaCedesValidacion {

	private ConsultaCedesResponse consultaCedesResponse = null;
	private ConsultaCedesRequest consultaCedesRequest = null;
  
    public boolean isClienteIDValid(){
      if(consultaCedesRequest.getCedeID().equals(Constantes.STRING_VACIO) || consultaCedesRequest.getCedeID().equals("?")){  

          consultaCedesResponse.setCodigoRespuesta("1");
          consultaCedesResponse.setMensajeRespuesta("El Numero de CEDE está vacío.");
          return false;
      }
      if (!Utileria.esNumero(consultaCedesRequest.getCedeID())){
    	  consultaCedesResponse.setCodigoRespuesta("2");
    	  consultaCedesResponse.setMensajeRespuesta("El Número de CEDE es Incorrecto.");
			
			return false;
		}
      return true;
    }

    
    public boolean isUsuarioValid(){
    if(consultaCedesRequest.getUsuario().equals(Constantes.STRING_VACIO) || consultaCedesRequest.getUsuario().equals("?")){  

        consultaCedesResponse.setCodigoRespuesta("901");
        consultaCedesResponse.setMensajeRespuesta("Campo Usuario Auditoría vacío");
        return false;
      }
    if (!Utileria.esNumero(consultaCedesRequest.getUsuario())){
    	consultaCedesResponse.setCodigoRespuesta("901");
    	consultaCedesResponse.setMensajeRespuesta("Campo Usuario Auditoría Incorrecto.");
		return false;
	}
      return true;
    }

    public boolean isDireccionIPValid(){
      if(consultaCedesRequest.getDireccionIP().equals(Constantes.STRING_VACIO) || consultaCedesRequest.getDireccionIP().equals("?")){ 

        consultaCedesResponse.setCodigoRespuesta("902");
        consultaCedesResponse.setMensajeRespuesta("Campo DireccionIP Auditoría vacío");
        return false;
        }
      return true;
    }

    public boolean isProgramaIDValid(){
      if(consultaCedesRequest.getProgramaID().equals(Constantes.STRING_VACIO) || consultaCedesRequest.getProgramaID().equals("?")){ 

        consultaCedesResponse.setCodigoRespuesta("903");
        consultaCedesResponse.setMensajeRespuesta("Campo ProgramaID Auditoría vacío");
        return false;
      }
      return true;
    }
    
    public boolean isSucursalValid(){
      if(consultaCedesRequest.getSucursal().equals(Constantes.STRING_VACIO) || consultaCedesRequest.getSucursal().equals("?")){  
        
        consultaCedesResponse.setCodigoRespuesta("904");
        consultaCedesResponse.setMensajeRespuesta("Campo Sucursal Auditoría vacío");
        return false;
      }
      if (!Utileria.esNumero(consultaCedesRequest.getSucursal())){
		  consultaCedesResponse.setCodigoRespuesta("904");
		  consultaCedesResponse.setMensajeRespuesta("Campo Sucursal Auditoría Incorrecto.");
		  return false;
      }
      return true;
    }


    public ConsultaCedesResponse isRequestValid(ConsultaCedesRequest consultaRequest){
    this.consultaCedesRequest = consultaRequest;
    consultaCedesResponse = new ConsultaCedesResponse();

      if(isClienteIDValid()  &
        isUsuarioValid()  &
        isDireccionIPValid()  &
        isProgramaIDValid()  &
        isSucursalValid()   
        ){
        consultaCedesResponse.setCodigoRespuesta("0");
        consultaCedesResponse.setMensajeRespuesta("Request valido");
      }

      return consultaCedesResponse;
      }

}
