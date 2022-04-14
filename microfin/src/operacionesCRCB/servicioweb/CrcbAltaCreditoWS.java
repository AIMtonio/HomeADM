package operacionesCRCB.servicioweb;

import herramientas.Constantes;
import operacionesCRCB.beanWS.request.AltaCreditoRequest;
import operacionesCRCB.beanWS.response.AltaCreditoResponse;
import operacionesCRCB.beanWS.validacion.AltaCreditoValidacion;
import operacionesCRCB.servicio.AltaCreditoServicio;

import org.springframework.oxm.Marshaller;
import org.springframework.ws.server.endpoint.AbstractMarshallingPayloadEndpoint;

public class CrcbAltaCreditoWS extends AbstractMarshallingPayloadEndpoint {

	AltaCreditoServicio altaCreditoServicio = null;
	
	
	public CrcbAltaCreditoWS(Marshaller marshaller) {
		super(marshaller);
		// TODO Auto-generated constructor stub
	}
	
	private AltaCreditoResponse crcbAltaCreditoWS(AltaCreditoRequest altaCreditoRequest){
		
		AltaCreditoResponse   altaCreditoResponse   = new AltaCreditoResponse();
		AltaCreditoValidacion altaCreditoValidacion = new AltaCreditoValidacion();
		
		altaCreditoResponse = altaCreditoValidacion.isRequestValid(altaCreditoRequest);
		
		if(altaCreditoResponse.getCodigoRespuesta().equals(Constantes.STRING_CERO)){
			
			altaCreditoRequest.asignaParametrosAud(altaCreditoServicio.getAltaCreditoDAO().getParametrosAuditoriaBean());
			
			altaCreditoResponse = altaCreditoServicio.altaCredito(altaCreditoRequest);
		}
		
		return altaCreditoResponse;
	}
	
	@Override
	protected Object invokeInternal(Object arg0) throws Exception {
		AltaCreditoRequest altaCreditoRequest = (AltaCreditoRequest) arg0;
		
		return crcbAltaCreditoWS(altaCreditoRequest);
	}

	// ========== GETTER & SETTER ============
	public AltaCreditoServicio getAltaCreditoServicio() {
		return altaCreditoServicio;
	}

	public void setAltaCreditoServicio(AltaCreditoServicio altaCreditoServicio) {
		this.altaCreditoServicio = altaCreditoServicio;
	}
}