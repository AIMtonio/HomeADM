package operacionesCRCB.servicioweb;

import herramientas.Constantes;
import operacionesCRCB.beanWS.request.ConsultaCedesRequest;
import operacionesCRCB.beanWS.response.ConsultaCedesResponse;
import operacionesCRCB.beanWS.validacion.ConsultaCedesValidacion;
import operacionesCRCB.servicio.ConsultaCedesServicio;
import operacionesCRCB.servicio.ConsultaCedesServicio.Enum_Con_Cedes_WS;

import org.springframework.oxm.Marshaller;
import org.springframework.ws.server.endpoint.AbstractMarshallingPayloadEndpoint;

public class CrcbConsultaCedesWS extends AbstractMarshallingPayloadEndpoint {

	private ConsultaCedesServicio consultaCedesServicio = null;

	public CrcbConsultaCedesWS(Marshaller marshaller) {
		super(marshaller);
		// TODO Auto-generated constructor stub
	}
	
	@Override
	protected Object invokeInternal(Object arg0) throws Exception {
		ConsultaCedesRequest cedesRequest = (ConsultaCedesRequest) arg0;
		
		return consultaCedeWS(cedesRequest);
	}

	
	private ConsultaCedesResponse consultaCedeWS(ConsultaCedesRequest consultaCedesRequest){
		
		ConsultaCedesResponse   consultaCedesResponse   = new ConsultaCedesResponse();
		ConsultaCedesValidacion cedesValidacion = new ConsultaCedesValidacion();
		
		try{
			consultaCedesResponse = cedesValidacion.isRequestValid(consultaCedesRequest);	
			
			if(consultaCedesResponse.getCodigoRespuesta().equals(Constantes.STRING_CERO)){
				
				consultaCedesRequest.asignaParametrosAud(consultaCedesServicio.getConsultaCedesDAO().getParametrosAuditoriaBean());
				
				// Consulta cedes
				consultaCedesResponse = (ConsultaCedesResponse)consultaCedesServicio.lista(consultaCedesRequest, Enum_Con_Cedes_WS.consultaCede);
								
				if((Integer.parseInt(consultaCedesResponse.getCodigoRespuesta()) != 0 )){
					throw new Exception(consultaCedesResponse.getMensajeRespuesta());
				} else{
				consultaCedesResponse.setMensajeRespuesta("Consulta Realizada Exitosamente.");
				}
			}
			
		}catch (Exception e) {
		e.printStackTrace();	
		if(consultaCedesResponse.getCodigoRespuesta().equals(Constantes.STRING_CERO)){
			consultaCedesResponse.setCodigoRespuesta("999");
			consultaCedesResponse.setMensajeRespuesta("Estimado Usuario(a), Ha ocurrido una falla en el sistema, "
					+ "estamos trabajando para resolverla. Disculpe las molestias que esto le ocasiona. Ref: WS-CONSULTACEDES");
			}			
		}	
		return consultaCedesResponse;
	}

	public ConsultaCedesServicio getConsultaCedesServicio() {
		return consultaCedesServicio;
	}

	public void setConsultaCedesServicio(ConsultaCedesServicio consultaCedesServicio) {
		this.consultaCedesServicio = consultaCedesServicio;
	}
	
	
}
