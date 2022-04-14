package operacionesCRCB.servicioweb;

import herramientas.Constantes;
import operacionesCRCB.beanWS.request.AltaCuentaDestinoRequest;
import operacionesCRCB.beanWS.response.AltaCuentaDestinoResponse;
import operacionesCRCB.beanWS.validacion.AltaCuentaDestinoValidacion;
import operacionesCRCB.servicio.CuentasDestinoServicio;
import operacionesCRCB.servicio.CuentasDestinoServicio.Enum_Tra_CuentaDestino_WS;

import org.springframework.oxm.Marshaller;
import org.springframework.ws.server.endpoint.AbstractMarshallingPayloadEndpoint;

public class CrcbAltaCuentaDestinoWS extends AbstractMarshallingPayloadEndpoint {

	private CuentasDestinoServicio cuentasDestinoServicio = null;

	public CrcbAltaCuentaDestinoWS(Marshaller marshaller) {
		super(marshaller);
		// TODO Auto-generated constructor stub
	}
	
	@Override
	protected Object invokeInternal(Object arg0) throws Exception {
		AltaCuentaDestinoRequest altaCuentaDestinoRequest = (AltaCuentaDestinoRequest) arg0;
		
		return CrcbAltaCuentaDestinoWS(altaCuentaDestinoRequest);
	}
	
	private AltaCuentaDestinoResponse CrcbAltaCuentaDestinoWS(AltaCuentaDestinoRequest altaCuentaDestinoRequest){
		
		AltaCuentaDestinoResponse   altaCuentaDestinoResponse   = new AltaCuentaDestinoResponse();
		AltaCuentaDestinoValidacion altaCuentaDestinoValidacion = new AltaCuentaDestinoValidacion();

		try{
		
			// Se realiza la validacion del request
			altaCuentaDestinoResponse = altaCuentaDestinoValidacion.isRequestValid(altaCuentaDestinoRequest);	
		
			if(altaCuentaDestinoResponse.getCodigoRespuesta().equals(Constantes.STRING_CERO)){
				
				// se asignan los valores de auditoria				
			
				altaCuentaDestinoRequest.asignaParametrosAud(cuentasDestinoServicio.getCuentasDestinoDAO().getParametrosAuditoriaBean());
				// alta de cuenta destino
				altaCuentaDestinoResponse = (AltaCuentaDestinoResponse)cuentasDestinoServicio.grabaTransaccion(altaCuentaDestinoRequest, Enum_Tra_CuentaDestino_WS.altaCtaDestino);
			
				if((Integer.parseInt(altaCuentaDestinoResponse.getCodigoRespuesta()) != 0 )){
					throw new Exception(altaCuentaDestinoResponse.getMensajeRespuesta());
				}
			}
			
		}catch (Exception e) {
			e.printStackTrace();	
			if(altaCuentaDestinoResponse.getCodigoRespuesta().equals(Constantes.STRING_CERO)){
				altaCuentaDestinoResponse.setCodigoRespuesta("999");
				altaCuentaDestinoResponse.setMensajeRespuesta("Estimado Usuario(a), Ha ocurrido una falla en el sistema, "
						+ "estamos trabajando para resolverla. Disculpe las molestias que esto le ocasiona. Ref: WS-ALTACUENTADESTINO");
			}			
		}
		
		return altaCuentaDestinoResponse;
	}
	
	
	public CuentasDestinoServicio getCuentasDestinoServicio() {
		return cuentasDestinoServicio;
	}

	public void setCuentasDestinoServicio(
			CuentasDestinoServicio cuentasDestinoServicio) {
		this.cuentasDestinoServicio = cuentasDestinoServicio;
	}
	
}
