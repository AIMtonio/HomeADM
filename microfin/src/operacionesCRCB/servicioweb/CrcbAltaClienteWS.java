package operacionesCRCB.servicioweb;

import herramientas.Constantes;
import operacionesCRCB.beanWS.request.AltaClienteRequest;
import operacionesCRCB.beanWS.response.AltaClienteResponse;
import operacionesCRCB.beanWS.validacion.AltaClienteValidacion;
import operacionesCRCB.servicio.AltaClienteServicio;

import org.springframework.oxm.Marshaller;
import org.springframework.ws.server.endpoint.AbstractMarshallingPayloadEndpoint;

public class CrcbAltaClienteWS extends AbstractMarshallingPayloadEndpoint {

	AltaClienteServicio altaClienteServicio = null;
	
	public CrcbAltaClienteWS(Marshaller marshaller) {
		super(marshaller);
		// TODO Auto-generated constructor stub
	}

	private AltaClienteResponse altaClienteWS(AltaClienteRequest altaClienteRequest){
		
		AltaClienteResponse   altaClienteResponse   = new AltaClienteResponse();
		AltaClienteValidacion altaClienteValidacion = new AltaClienteValidacion();
		
		altaClienteResponse = altaClienteValidacion.isRequestValid(altaClienteRequest);	
		
		if(altaClienteResponse.getCodigoRespuesta().equals(Constantes.STRING_CERO)){
			
			altaClienteRequest.asignaParametrosAud(altaClienteServicio.getAltaClienteDAO().getParametrosAuditoriaBean());
			
			altaClienteResponse = altaClienteServicio.altaCliente(altaClienteRequest);
		}
		return altaClienteResponse;
	}
	
	@Override
	protected Object invokeInternal(Object arg0) throws Exception {
		AltaClienteRequest altaClienteRequest = (AltaClienteRequest) arg0;
		
		return altaClienteWS(altaClienteRequest);
	}

	// ========== GETTER & SETTER ============

	public AltaClienteServicio getAltaClienteServicio() {
		return altaClienteServicio;
	}

	public void setAltaClienteServicio(AltaClienteServicio altaClienteServicio) {
		this.altaClienteServicio = altaClienteServicio;
	}
	
}
