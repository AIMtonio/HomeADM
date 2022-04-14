package operacionesCRCB.beanWS.validacion;

import herramientas.Constantes;
import herramientas.Utileria;
import operacionesCRCB.beanWS.request.AltaGrupoRequest;
import operacionesCRCB.beanWS.response.AltaGrupoResponse;

public class AltaGrupoValidacion {
  
  private AltaGrupoRequest altaGrupoRequest = null;
  private AltaGrupoResponse altaGrupoResponse = null;
  
  	public boolean isNombreGrupoValid(){
  	  altaGrupoRequest.setNombreGrupo(altaGrupoRequest.getNombreGrupo().replace("?", Constantes.STRING_VACIO));
	  if ( altaGrupoRequest.getNombreGrupo().equals(Constantes.STRING_VACIO)){  
	      altaGrupoResponse.setCodigoRespuesta("1");
	      altaGrupoResponse.setMensajeRespuesta("El Nombre del Grupo está Vacío.");
	      return false;
	  }
	  return true;
	}

    public boolean isSucursalIDValid(){
      altaGrupoRequest.setSucursalID(altaGrupoRequest.getSucursalID().replace("?", Constantes.STRING_VACIO));
      if ( altaGrupoRequest.getSucursalID().equals(Constantes.STRING_VACIO)){  
          altaGrupoResponse.setCodigoRespuesta("2");
          altaGrupoResponse.setMensajeRespuesta("La Sucursal está Vacía.");
          return false;
      }
      if (! Utileria.esNumero(altaGrupoRequest.getSucursalID()) ){
    	  altaGrupoResponse.setCodigoRespuesta("400"); 
    	  altaGrupoResponse.setMensajeRespuesta("El Formato Sucursal es Inválido."); 
		  return false; 
	  }
      return true;
    }


    public boolean isUsuarioValid(){
      altaGrupoRequest.setUsuario(altaGrupoRequest.getUsuario().replace("?", Constantes.STRING_VACIO));
      if ( altaGrupoRequest.getUsuario().equals(Constantes.STRING_VACIO)){  
          altaGrupoResponse.setCodigoRespuesta("901");
          altaGrupoResponse.setMensajeRespuesta("Campo Usuario Auditoría Vacío.");
          return false;
      }
      if (! Utileria.esNumero(altaGrupoRequest.getUsuario()) ){
    	  altaGrupoResponse.setCodigoRespuesta("400"); 
    	  altaGrupoResponse.setMensajeRespuesta("El Formato Usuario de Auditoría es Inválido."); 
		  return false; 
	  }
      return true;
    }

    public boolean isDireccionIPValid(){
    altaGrupoRequest.setDireccionIP(altaGrupoRequest.getDireccionIP().replace("?", Constantes.STRING_VACIO));
      if ( altaGrupoRequest.getDireccionIP().equals(Constantes.STRING_VACIO)){  
          altaGrupoResponse.setCodigoRespuesta("902");
          altaGrupoResponse.setMensajeRespuesta("Campo DireccionIP Auditoría Vacío.");
          return false;
      }
      return true;
    }

    public boolean isProgramaIDValid(){
    altaGrupoRequest.setProgramaID(altaGrupoRequest.getProgramaID().replace("?", Constantes.STRING_VACIO));
      if ( altaGrupoRequest.getProgramaID().equals(Constantes.STRING_VACIO)){  
          altaGrupoResponse.setCodigoRespuesta("903");
          altaGrupoResponse.setMensajeRespuesta("Campo ProgramaID Auditoría Vacío.");
          return false;
      }
      return true;
    }

    public boolean isSucursalValid(){
    altaGrupoRequest.setSucursal(altaGrupoRequest.getSucursal().replace("?", Constantes.STRING_VACIO));
      if ( altaGrupoRequest.getSucursal().equals(Constantes.STRING_VACIO)){  
          altaGrupoResponse.setCodigoRespuesta("904");
          altaGrupoResponse.setMensajeRespuesta("Campo Sucursal Auditoría Vacío.");
          return false;
      }
      if (! Utileria.esNumero(altaGrupoRequest.getSucursal()) ){
    	  altaGrupoResponse.setCodigoRespuesta("400"); 
    	  altaGrupoResponse.setMensajeRespuesta("El Formato Sucursal de Auditoría es Inválido."); 
		  return false; 
	  }
      return true;
    }

  
  public AltaGrupoResponse isRequestValid(AltaGrupoRequest altaGrupoRequest){
    this.altaGrupoRequest = altaGrupoRequest;
    altaGrupoResponse = new AltaGrupoResponse();
    altaGrupoResponse.setGrupoID("0");
    
    if( isNombreGrupoValid()  &
        isSucursalIDValid()  &
        isUsuarioValid()  &
        isDireccionIPValid()  &
        isProgramaIDValid()  &
        isSucursalValid()  
        ){
      altaGrupoResponse.setCodigoRespuesta("0");
      altaGrupoResponse.setMensajeRespuesta("Request valido");
    }
    
    return altaGrupoResponse;
  }
  
}
