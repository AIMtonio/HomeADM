package operacionesCRCB.servicioweb;

import herramientas.Constantes;
import operacionesCRCB.beanWS.request.ActCuentaDestinoRequest;
import operacionesCRCB.beanWS.response.ActCuentaDestinoResponse;
import operacionesCRCB.beanWS.validacion.ActCuentaDestinoValidacion;
import operacionesCRCB.servicio.CuentasDestinoServicio;
import operacionesCRCB.servicio.CuentasDestinoServicio.Enum_Tra_CuentaDestino_WS;

import org.springframework.oxm.Marshaller;
import org.springframework.ws.server.endpoint.AbstractMarshallingPayloadEndpoint;

public class CrcbActCuentaDestinoWS extends AbstractMarshallingPayloadEndpoint {

	private CuentasDestinoServicio cuentasDestinoServicio = null;

	public CrcbActCuentaDestinoWS(Marshaller marshaller) {
		super(marshaller);
		// TODO Auto-generated constructor stub
	}
	
	@Override
	protected Object invokeInternal(Object arg0) throws Exception {
		ActCuentaDestinoRequest actCuentaDestinoRequest = (ActCuentaDestinoRequest) arg0;
		
		return actCuentaDestinoWS(actCuentaDestinoRequest);
	}
	
	private ActCuentaDestinoResponse actCuentaDestinoWS(ActCuentaDestinoRequest actCuentaDestinoRequest){
		
		ActCuentaDestinoResponse   actCuentaDestinoResponse   = new ActCuentaDestinoResponse();
		ActCuentaDestinoValidacion actCuentaDestinoValidacion = new ActCuentaDestinoValidacion();
		try{
			actCuentaDestinoResponse = actCuentaDestinoValidacion.isRequestValid(actCuentaDestinoRequest);	
			
			if(actCuentaDestinoResponse.getCodigoRespuesta().equals(Constantes.STRING_CERO)){
	
				actCuentaDestinoRequest.asignaParametrosAud(cuentasDestinoServicio.getCuentasDestinoDAO().getParametrosAuditoriaBean());

				actCuentaDestinoResponse= (ActCuentaDestinoResponse)cuentasDestinoServicio.grabaTransaccion(actCuentaDestinoRequest, Enum_Tra_CuentaDestino_WS.actCtaDestino);
			
				if((Integer.parseInt(actCuentaDestinoResponse.getCodigoRespuesta()) != 0 )){
					throw new Exception(actCuentaDestinoResponse.getMensajeRespuesta());
				}
			}
			
		}catch (Exception e) {
			e.printStackTrace();	
			if(actCuentaDestinoResponse.getCodigoRespuesta().equals(Constantes.STRING_CERO)){
				actCuentaDestinoResponse.setCodigoRespuesta("999");
				actCuentaDestinoResponse.setMensajeRespuesta("Estimado Usuario(a), Ha ocurrido una falla en el sistema, "
						+ "estamos trabajando para resolverla. Disculpe las molestias que esto le ocasiona. Ref: WS-ACTUALIZACUENTADESTINO");
			}			
		}
		return actCuentaDestinoResponse;
	}

	
	public CuentasDestinoServicio getCuentasDestinoServicio() {
		return cuentasDestinoServicio;
	}

	public void setCuentasDestinoServicio(
			CuentasDestinoServicio cuentasDestinoServicio) {
		this.cuentasDestinoServicio = cuentasDestinoServicio;
	}

	
}
