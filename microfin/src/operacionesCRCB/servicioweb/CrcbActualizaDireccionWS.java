package operacionesCRCB.servicioweb;

import herramientas.Constantes;
import operacionesCRCB.beanWS.request.ActualizaDireccionRequest;
import operacionesCRCB.beanWS.response.ActualizaDireccionResponse;
import operacionesCRCB.beanWS.validacion.ActualizaDireccionValidacion;
import operacionesCRCB.servicio.DireccionesWSServicio;

import org.springframework.oxm.Marshaller;
import org.springframework.ws.server.endpoint.AbstractMarshallingPayloadEndpoint;

public class CrcbActualizaDireccionWS extends
		AbstractMarshallingPayloadEndpoint {

	DireccionesWSServicio direccionesWSServicio = null;
	
	public CrcbActualizaDireccionWS(Marshaller marshaller) {
		super(marshaller);
		// TODO Auto-generated constructor stub
	}
	
	@Override
	protected Object invokeInternal(Object arg0) throws Exception {
		ActualizaDireccionRequest actualizaDireccionRequest = (ActualizaDireccionRequest) arg0;
		
		return CrcbActualizaDireccionWS(actualizaDireccionRequest);
	}
	
	private ActualizaDireccionResponse CrcbActualizaDireccionWS(ActualizaDireccionRequest actualizaDireccionRequest){
		
		ActualizaDireccionResponse   actualizaDireccionResponse   = new ActualizaDireccionResponse();
		ActualizaDireccionValidacion actualizaDireccionValidacion = new ActualizaDireccionValidacion();
		
		actualizaDireccionResponse = actualizaDireccionValidacion.isRequestValid(actualizaDireccionRequest);		
		if(actualizaDireccionResponse.getCodigoRespuesta().equals(Constantes.STRING_CERO)){
			
			actualizaDireccionRequest.asignaParametrosAud(direccionesWSServicio.getDireccionesWSDAO().getParametrosAuditoriaBean());
			
			actualizaDireccionResponse = direccionesWSServicio.grabaTransaccion(actualizaDireccionRequest, 
																				DireccionesWSServicio.Enum_Tran_Direcc.modifica);
						
		}
			
		
		return actualizaDireccionResponse;
	}

	public DireccionesWSServicio getDireccionesWSServicio() {
		return direccionesWSServicio;
	}

	public void setDireccionesWSServicio(DireccionesWSServicio direccionesWSServicio) {
		this.direccionesWSServicio = direccionesWSServicio;
	}
	
	

}
