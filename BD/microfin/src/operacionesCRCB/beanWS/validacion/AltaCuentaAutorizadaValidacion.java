package operacionesCRCB.beanWS.validacion;

import herramientas.Constantes;
import herramientas.Utileria;
import operacionesCRCB.beanWS.request.AltaCuentaAutorizadaRequest;
import operacionesCRCB.beanWS.response.AltaCuentaAutorizadaResponse;

public class AltaCuentaAutorizadaValidacion {
    
    private AltaCuentaAutorizadaRequest altaCuentaAutorizadaRequest = null;
    private AltaCuentaAutorizadaResponse altaCuentaAutorizadaResponse = null;
    
    public boolean isSucursalIDValid(){
          if ( altaCuentaAutorizadaRequest.getSucursalID().equals(Constantes.STRING_VACIO)){  
              altaCuentaAutorizadaResponse.setCodigoRespuesta("2");
              altaCuentaAutorizadaResponse.setMensajeRespuesta("El numero de Sucursal está vacío.");
              return false;
          }
          
          if (! Utileria.esNumero(altaCuentaAutorizadaRequest.getSucursalID()) ){
        	  altaCuentaAutorizadaResponse.setCodigoRespuesta("400");
              altaCuentaAutorizadaResponse.setMensajeRespuesta("El numero de Sucursal es inválido.");
              return false;
          }
          
          return true;
        }

        public boolean isClienteIDValid(){
          if ( altaCuentaAutorizadaRequest.getClienteID().equals(Constantes.STRING_VACIO)){  
              altaCuentaAutorizadaResponse.setCodigoRespuesta("3");
              altaCuentaAutorizadaResponse.setMensajeRespuesta("El número de Cliente está vacío");
              return false;
          }
          
          if (! Utileria.esNumero(altaCuentaAutorizadaRequest.getClienteID()) ){
        	  altaCuentaAutorizadaResponse.setCodigoRespuesta("400");
              altaCuentaAutorizadaResponse.setMensajeRespuesta("El número de Cliente es inválido.");
              return false;
          }
          
          return true;
        }

        public boolean isTipoCuentaIDValid(){
          if ( altaCuentaAutorizadaRequest.getTipoCuentaID().equals(Constantes.STRING_VACIO)){  
              altaCuentaAutorizadaResponse.setCodigoRespuesta("4");
              altaCuentaAutorizadaResponse.setMensajeRespuesta("El Tipo de Cuenta está vacío");
              return false;
          }
          
          if (! Utileria.esNumero(altaCuentaAutorizadaRequest.getTipoCuentaID()) ){
        	  altaCuentaAutorizadaResponse.setCodigoRespuesta("400");
              altaCuentaAutorizadaResponse.setMensajeRespuesta("El Tipo de Cuenta es inválido.");
              return false;
          }
          
         
          
          return true;
        }

        public boolean isEsPrincipalValid(){
          if ( altaCuentaAutorizadaRequest.getEsPrincipal().equals(Constantes.STRING_VACIO)){  
              altaCuentaAutorizadaResponse.setCodigoRespuesta("11");
              altaCuentaAutorizadaResponse.setMensajeRespuesta("Especifique si es Cuenta Principal");
              return false;
          }
          
        
          return true;
        }

        public boolean isUsuarioValid(){
              if ( altaCuentaAutorizadaRequest.getUsuario().equals(Constantes.STRING_VACIO)){  
                  altaCuentaAutorizadaResponse.setCodigoRespuesta("901");
                  altaCuentaAutorizadaResponse.setMensajeRespuesta("Campo Usuario de auditoria vacío");
                  return false;
              }
              
              if (! Utileria.esNumero(altaCuentaAutorizadaRequest.getUsuario()) ){
            	  altaCuentaAutorizadaResponse.setCodigoRespuesta("400");
                  altaCuentaAutorizadaResponse.setMensajeRespuesta("Campo Usuario de auditoria inválido.");
                  return false;
              }
              
              return true;
            }

            public boolean isDireccionIPValid(){
              if ( altaCuentaAutorizadaRequest.getDireccionIP().equals(Constantes.STRING_VACIO)){  
                  altaCuentaAutorizadaResponse.setCodigoRespuesta("902");
                  altaCuentaAutorizadaResponse.setMensajeRespuesta("Campo Dirección IP de auditoria vacío");
                  return false;
              }
              return true;
            }

            public boolean isProgramaIDValid(){
              if ( altaCuentaAutorizadaRequest.getProgramaID().equals(Constantes.STRING_VACIO)){  
                  altaCuentaAutorizadaResponse.setCodigoRespuesta("903");
                  altaCuentaAutorizadaResponse.setMensajeRespuesta("Campo Programa de auditoría vacío");
                  return false;
              }
              return true;
            }

            public boolean isSucursalValid(){
              if ( altaCuentaAutorizadaRequest.getSucursal().equals(Constantes.STRING_VACIO)){  
                  altaCuentaAutorizadaResponse.setCodigoRespuesta("904");
                  altaCuentaAutorizadaResponse.setMensajeRespuesta("Campo Sucursal de auditoría vacío");
                  return false;
              }
              
              if (! Utileria.esNumero(altaCuentaAutorizadaRequest.getSucursal()) ){
            	  altaCuentaAutorizadaResponse.setCodigoRespuesta("400");
                  altaCuentaAutorizadaResponse.setMensajeRespuesta("Campo Sucursal de auditoria inválido.");
                  return false;
              }
              
              return true;
            }

        public boolean isFechaContratacionValid(){
        	altaCuentaAutorizadaRequest.setFechaContratacion(altaCuentaAutorizadaRequest.getFechaContratacion().replace("?", Constantes.FECHA_VACIA));
        	if(altaCuentaAutorizadaRequest.getFechaContratacion().equals(Constantes.FECHA_VACIA)){
        		altaCuentaAutorizadaResponse.setCodigoRespuesta("18");
                altaCuentaAutorizadaResponse.setMensajeRespuesta("La Fecha esta Vacia.");
                return false;
        	}
        	return true;
        }
        public AltaCuentaAutorizadaResponse isRequestValid(AltaCuentaAutorizadaRequest altaCuentaAutorizadaRequest){
            this.altaCuentaAutorizadaRequest = altaCuentaAutorizadaRequest;
            altaCuentaAutorizadaResponse = new AltaCuentaAutorizadaResponse();
            altaCuentaAutorizadaResponse.setCuentaAhoID("0");
            
            if( isSucursalIDValid()  &
                isClienteIDValid()  &
                isTipoCuentaIDValid()  &
                isEsPrincipalValid()  &
                isUsuarioValid()  &
                isDireccionIPValid()  &
                isProgramaIDValid()  &
                isSucursalValid()  &
                isFechaContratacionValid()
                    ){
                altaCuentaAutorizadaResponse.setCodigoRespuesta("0");
                altaCuentaAutorizadaResponse.setMensajeRespuesta("Request valido");
            }
            
            return altaCuentaAutorizadaResponse;
        }

}
