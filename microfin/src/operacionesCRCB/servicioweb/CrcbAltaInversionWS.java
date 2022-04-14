package operacionesCRCB.servicioweb;

import herramientas.Constantes;
import herramientas.Utileria;
import operacionesCRCB.beanWS.request.AltaInversionRequest;
import operacionesCRCB.beanWS.response.AltaInversionResponse;
import operacionesCRCB.beanWS.validacion.AltaInversionValidacion;
import operacionesCRCB.servicio.AltaInversionesServicio;
import operacionesCRCB.servicio.AltaInversionesServicio.Enum_Tra_Inversiones_WS;

import org.apache.log4j.Logger;
import org.springframework.oxm.Marshaller;
import org.springframework.ws.server.endpoint.AbstractMarshallingPayloadEndpoint;

public class CrcbAltaInversionWS extends AbstractMarshallingPayloadEndpoint {

	private AltaInversionesServicio altaInversionesServicio= null;
	protected final Logger loggerSAFI = Logger.getLogger("SAFI");

	public CrcbAltaInversionWS(Marshaller marshaller) {
		super(marshaller);
		// TODO Auto-generated constructor stub
	}
	
	@Override
	protected Object invokeInternal(Object arg0) throws Exception {
		AltaInversionRequest altaInversionRequest = (AltaInversionRequest) arg0;
		
		return CrcbAltaInversionWS(altaInversionRequest);
	}
	
	private AltaInversionResponse CrcbAltaInversionWS(AltaInversionRequest altaInversionRequest){
		
		AltaInversionResponse   altaInversionResponse   = new AltaInversionResponse();
		AltaInversionValidacion altaInversionValidacion = new AltaInversionValidacion();
		
		try{
			altaInversionResponse = altaInversionValidacion.isRequestValid(altaInversionRequest);
			
			if(altaInversionResponse.getCodigoRespuesta().equals(Constantes.STRING_CERO)){
				
				altaInversionRequest.asignaParametrosAud(altaInversionesServicio.getAltaInversionesDAO().getParametrosAuditoriaBean());
				
				// alta inversion	
				loggerSAFI.info("REQUEST: " +  Utileria.logJsonFormat(altaInversionRequest));
				altaInversionResponse = (AltaInversionResponse)altaInversionesServicio.grabaTransaccion(altaInversionRequest, Enum_Tra_Inversiones_WS.altaInversion);
				loggerSAFI.info("RESPONSE: " +  Utileria.logJsonFormat(altaInversionResponse));
			
				if((Integer.parseInt(altaInversionResponse.getCodigoRespuesta()) != 0 )){
					throw new Exception(altaInversionResponse.getMensajeRespuesta());
				} 
			}
			
		}catch (Exception e) {
		e.printStackTrace();	
		if(altaInversionResponse.getCodigoRespuesta().equals(Constantes.STRING_CERO)){
			altaInversionResponse.setCodigoRespuesta("999");
			altaInversionResponse.setMensajeRespuesta("Estimado Usuario(a), Ha ocurrido una falla en el sistema, "
					+ "estamos trabajando para resolverla. Disculpe las molestias que esto le ocasiona. Ref: WS-INVERSIONES");
			}			
		}	
		return altaInversionResponse;
	}

	public AltaInversionesServicio getAltaInversionesServicio() {
		return altaInversionesServicio;
	}

	public void setAltaInversionesServicio(
			AltaInversionesServicio altaInversionesServicio) {
		this.altaInversionesServicio = altaInversionesServicio;
	}

	
}
