package operacionesCRCB.servicioweb;

import herramientas.Constantes;
import operacionesCRCB.beanWS.request.AltaGrupoRequest;
import operacionesCRCB.beanWS.response.AltaGrupoResponse;
import operacionesCRCB.beanWS.validacion.AltaGrupoValidacion;
import operacionesCRCB.servicio.AltaGrupoServicio;

import org.springframework.oxm.Marshaller;
import org.springframework.ws.server.endpoint.AbstractMarshallingPayloadEndpoint;

public class CrcbAltaGrupoWS extends AbstractMarshallingPayloadEndpoint {
	
	AltaGrupoServicio altaGrupoServicio = null;
	
		
	public CrcbAltaGrupoWS(Marshaller marshaller) { 
		super(marshaller);
		// TODO Auto-generated constructor stub
	}
	
	private AltaGrupoResponse crcbAltaGrupoWS(AltaGrupoRequest altaGrupoRequest){
		AltaGrupoResponse   altaGrupoResponse   = new AltaGrupoResponse();
		AltaGrupoValidacion altaGrupoValidacion = new AltaGrupoValidacion();
						
		altaGrupoRequest.setCicloActual(altaGrupoRequest.getCicloActual().replace("?", Constantes.STRING_VACIO));
		altaGrupoResponse = altaGrupoValidacion.isRequestValid(altaGrupoRequest);
			
		if(altaGrupoResponse.getCodigoRespuesta().equals(Constantes.STRING_CERO)){	
			
			altaGrupoRequest.asignaParametrosAud(altaGrupoServicio.getAltaGrupoDAO().getParametrosAuditoriaBean());
			altaGrupoResponse = altaGrupoServicio.altaGrupo(altaGrupoRequest);
		}
		return altaGrupoResponse;
	}
	
	@Override
	protected Object invokeInternal(Object arg0) throws Exception {
		AltaGrupoRequest altaGrupoRequest = (AltaGrupoRequest) arg0;
		
		return crcbAltaGrupoWS(altaGrupoRequest);
	}

	// ========== GETTER & SETTER ============

	public AltaGrupoServicio getAltaGrupoServicio() {
		return altaGrupoServicio;
	}

	public void setAltaGrupoServicio(AltaGrupoServicio altaGrupoServicio) {
		this.altaGrupoServicio = altaGrupoServicio;
	}

}
