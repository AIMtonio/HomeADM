package operacionesCRCB.servicioweb;

import herramientas.Constantes;
import herramientas.Utileria;
import operacionesCRCB.beanWS.request.DesembolsoCreditoRequest;
import operacionesCRCB.beanWS.response.DesembolsoCreditoResponse;
import operacionesCRCB.beanWS.validacion.DesembolsoCreditoValidacion;
import operacionesCRCB.servicio.DesembolsoCreditoServicio;
import operacionesCRCB.servicio.DesembolsoCreditoServicio.Enum_Tra_Desembolso_WS;

import org.apache.log4j.Logger;
import org.springframework.oxm.Marshaller;
import org.springframework.ws.server.endpoint.AbstractMarshallingPayloadEndpoint;

public class CrcbDesembolsoCreditoWS extends AbstractMarshallingPayloadEndpoint {

	private DesembolsoCreditoServicio desembolsoCreditoServicio = null;
	protected final Logger loggerSAFI = Logger.getLogger("SAFI");
	
	public CrcbDesembolsoCreditoWS(Marshaller marshaller) {
		super(marshaller);
		// TODO Auto-generated constructor stub
	}
	
	@Override
	protected Object invokeInternal(Object arg0) throws Exception {
		DesembolsoCreditoRequest desembolsoCreditoRequest = (DesembolsoCreditoRequest) arg0;
		
		return CrcbDesembolsoCreditoWS(desembolsoCreditoRequest);
	}
	
	private DesembolsoCreditoResponse CrcbDesembolsoCreditoWS(DesembolsoCreditoRequest desembolsoCreditoRequest){
		
		DesembolsoCreditoResponse   desembolsoCreditoResponse   = new DesembolsoCreditoResponse();
		DesembolsoCreditoValidacion desembolsoCreditoValidacion = new DesembolsoCreditoValidacion();
		
		try{
			desembolsoCreditoResponse = desembolsoCreditoValidacion.isRequestValid(desembolsoCreditoRequest);
			
			if(desembolsoCreditoResponse.getCodigoRespuesta().equals(Constantes.STRING_CERO)){
				
				desembolsoCreditoRequest.asignaParametrosAud(desembolsoCreditoServicio.getDesembolsoCreditoDAO().getParametrosAuditoriaBean());
	
				// desembolso
				loggerSAFI.info("REQUEST: " +  Utileria.logJsonFormat(desembolsoCreditoRequest));
				desembolsoCreditoResponse = (DesembolsoCreditoResponse)desembolsoCreditoServicio.grabaTransaccion(desembolsoCreditoRequest, Enum_Tra_Desembolso_WS.desembolso);
				loggerSAFI.info("RESPONSE: " +  Utileria.logJsonFormat(desembolsoCreditoResponse));
			
				if((Integer.parseInt(desembolsoCreditoResponse.getCodigoRespuesta()) != 0 )){
					throw new Exception(desembolsoCreditoResponse.getMensajeRespuesta());
				} else {
					desembolsoCreditoResponse.setCodigoRespuesta(desembolsoCreditoResponse.getCodigoRespuesta());
					desembolsoCreditoResponse.setMensajeRespuesta(desembolsoCreditoResponse.getMensajeRespuesta());
				}
			}
			
		}catch (Exception e) {
		e.printStackTrace();	
		if(desembolsoCreditoResponse.getCodigoRespuesta().equals(Constantes.STRING_CERO)){
			desembolsoCreditoResponse.setCodigoRespuesta("999");
			desembolsoCreditoResponse.setMensajeRespuesta("Estimado Usuario(a), Ha ocurrido una falla en el sistema, "
					+ "estamos trabajando para resolverla. Disculpe las molestias que esto le ocasiona. Ref: WS-DESEMBOLSOCREDITO");
			}			
		}	
		
		return desembolsoCreditoResponse;
	}

	public DesembolsoCreditoServicio getDesembolsoCreditoServicio() {
		return desembolsoCreditoServicio;
	}

	public void setDesembolsoCreditoServicio(
			DesembolsoCreditoServicio desembolsoCreditoServicio) {
		this.desembolsoCreditoServicio = desembolsoCreditoServicio;
	}
	
	

}
