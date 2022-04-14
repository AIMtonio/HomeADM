package operacionesCRCB.servicioweb;

import herramientas.Constantes;
import operacionesCRCB.beanWS.request.AltaCuentaAutorizadaRequest;
import operacionesCRCB.beanWS.response.AltaCuentaAutorizadaResponse;
import operacionesCRCB.beanWS.validacion.AltaCuentaAutorizadaValidacion;
import operacionesCRCB.servicio.CuentaAutorizadaServicio;

import org.springframework.oxm.Marshaller;
import org.springframework.ws.server.endpoint.AbstractMarshallingPayloadEndpoint;

public class CrcbAltaCuentaAutorizadaWS extends
		AbstractMarshallingPayloadEndpoint {

	CuentaAutorizadaServicio cuentaAutorizadaServicio = null;
	
	public CrcbAltaCuentaAutorizadaWS(Marshaller marshaller) {
		super(marshaller);
		// TODO Auto-generated constructor stub
	}
	
	@Override
	protected Object invokeInternal(Object arg0) throws Exception {
		AltaCuentaAutorizadaRequest altaCuentaAutorizadaRequest = (AltaCuentaAutorizadaRequest) arg0;
		
		return CrcbAltaCuentaAutorizadaWS(altaCuentaAutorizadaRequest);
	}
	
	private AltaCuentaAutorizadaResponse CrcbAltaCuentaAutorizadaWS(AltaCuentaAutorizadaRequest altaCuentaAutorizadaRequest){
		
		AltaCuentaAutorizadaResponse   altaCuentaAutorizadaResponse   = new AltaCuentaAutorizadaResponse();
		AltaCuentaAutorizadaValidacion altaCuentaAutorizadaValidacion = new AltaCuentaAutorizadaValidacion();
		
		altaCuentaAutorizadaResponse = altaCuentaAutorizadaValidacion.isRequestValid(altaCuentaAutorizadaRequest);		
		if(altaCuentaAutorizadaResponse.getCodigoRespuesta().equals(Constantes.STRING_CERO)){
			
			altaCuentaAutorizadaRequest.asignaParametrosAud(cuentaAutorizadaServicio.getCuentaAutorizadaDAO().getParametrosAuditoriaBean());
			
			altaCuentaAutorizadaResponse = cuentaAutorizadaServicio.grabaTransaccion(altaCuentaAutorizadaRequest, 
																					CuentaAutorizadaServicio.Enum_Tran_Cuenta.alta);
			
				
		}
			
		
		return altaCuentaAutorizadaResponse;
	}

	public CuentaAutorizadaServicio getCuentaAutorizadaServicio() {
		return cuentaAutorizadaServicio;
	}

	public void setCuentaAutorizadaServicio(
			CuentaAutorizadaServicio cuentaAutorizadaServicio) {
		this.cuentaAutorizadaServicio = cuentaAutorizadaServicio;
	}
	
	
	

}
