package operacionesCRCB.servicioweb;

import herramientas.Constantes;
import operacionesCRCB.beanWS.request.ActualizaClienteRequest;
import operacionesCRCB.beanWS.response.ActualizaClienteResponse;
import operacionesCRCB.beanWS.validacion.ActualizaClienteValidacion;
import operacionesCRCB.servicio.ActualizaClienteServicio;
import operacionesCRCB.servicio.ActualizaClienteServicio.Enum_Tran_Cliente;

import org.springframework.oxm.Marshaller;
import org.springframework.ws.server.endpoint.AbstractMarshallingPayloadEndpoint;

public class CrcbActualizaClienteWS extends AbstractMarshallingPayloadEndpoint {

	ActualizaClienteServicio actualizaClienteServicio = null;

	
	public CrcbActualizaClienteWS(Marshaller marshaller) {
		super(marshaller);
		// TODO Auto-generated constructor stub
	}

	private ActualizaClienteResponse CrcbActualizaCuentaWS(ActualizaClienteRequest actualizaClienteRequest){
		
		ActualizaClienteResponse   actualizaClienteResponse   = new ActualizaClienteResponse();
		ActualizaClienteValidacion actualizaCuentaValidacion = new ActualizaClienteValidacion();			
		
		actualizaClienteResponse = actualizaCuentaValidacion.isRequestValid(actualizaClienteRequest);	
		
		if(actualizaClienteResponse.getCodigoRespuesta().equals(Constantes.STRING_CERO)){
			actualizaClienteRequest.asignaParametrosAud(actualizaClienteServicio.getActualizaClienteDAO().getParametrosAuditoriaBean());

			actualizaClienteResponse = actualizaClienteServicio.actualizaCliente(Enum_Tran_Cliente.actualizaCte,actualizaClienteRequest);
		}
		return actualizaClienteResponse;
	}
	
	@Override
	protected Object invokeInternal(Object arg0) throws Exception {
		ActualizaClienteRequest actualizaCuentaRequest = (ActualizaClienteRequest) arg0;
		
		return CrcbActualizaCuentaWS(actualizaCuentaRequest);
	}

	// ========== GETTER & SETTER ============

	public ActualizaClienteServicio getActualizaClienteServicio() {
		return actualizaClienteServicio;
	}

	public void setActualizaClienteServicio(
			ActualizaClienteServicio actualizaClienteServicio) {
		this.actualizaClienteServicio = actualizaClienteServicio;
	}

}
