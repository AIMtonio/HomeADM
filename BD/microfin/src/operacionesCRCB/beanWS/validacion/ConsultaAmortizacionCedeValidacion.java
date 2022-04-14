package operacionesCRCB.beanWS.validacion;

import herramientas.Constantes;
import herramientas.Utileria;
import operacionesCRCB.beanWS.request.ConsultaAmortizacionCedeRequest;
import operacionesCRCB.beanWS.response.ConsultaAmortizacionCedeResponse;

public class ConsultaAmortizacionCedeValidacion {

		private ConsultaAmortizacionCedeResponse consultaAmoCedesResponse = null;
		private ConsultaAmortizacionCedeRequest consultaAmoCedesRequest = null;
	  
	    public boolean isCedeIDValid(){
	    	
	      if(consultaAmoCedesRequest.getCedeID().equals(Constantes.STRING_VACIO) || consultaAmoCedesRequest.getCedeID().equals("?")){  

	          consultaAmoCedesResponse.setCodigoRespuesta("1");
	          consultaAmoCedesResponse.setMensajeRespuesta("El Numero de CEDE está vacío'");
	          return false;
	      }
	      if (!Utileria.esNumero(consultaAmoCedesRequest.getCedeID())){
	    	  consultaAmoCedesResponse.setCodigoRespuesta("2");
	    	  consultaAmoCedesResponse.setMensajeRespuesta("El Número de CEDE es Incorrecto.");
				
				return false;
			}
	      return true;
	    }


        public ConsultaAmortizacionCedeResponse isRequestValid(ConsultaAmortizacionCedeRequest consultaRequest){
        this.consultaAmoCedesRequest = consultaRequest;
        consultaAmoCedesResponse = new ConsultaAmortizacionCedeResponse();

          if(isCedeIDValid()   
            ){
            consultaAmoCedesResponse.setCodigoRespuesta("0");
            consultaAmoCedesResponse.setMensajeRespuesta("Request valido");
          }

          return consultaAmoCedesResponse;
          }

}
