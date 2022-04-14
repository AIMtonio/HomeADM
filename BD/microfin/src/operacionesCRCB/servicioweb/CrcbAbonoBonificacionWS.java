package operacionesCRCB.servicioweb;

import herramientas.Constantes;
import herramientas.Utileria;
import operacionesCRCB.beanWS.request.AbonoBonificacionRequest;
import operacionesCRCB.beanWS.response.AbonoBonificacionResponse;
import operacionesCRCB.beanWS.validacion.AbonoBonificacionValidacion;
import operacionesCRCB.servicio.AbonoBonificacionServicio;

import org.apache.log4j.Logger;
import org.springframework.oxm.Marshaller;
import org.springframework.ws.server.endpoint.AbstractMarshallingPayloadEndpoint;


public class CrcbAbonoBonificacionWS extends AbstractMarshallingPayloadEndpoint{
	private AbonoBonificacionServicio abonoBonificacionServicio = null;
	protected final Logger loggerSAFI = Logger.getLogger("SAFI");

	public CrcbAbonoBonificacionWS(Marshaller marshaller){
		super(marshaller);
	}


	@Override
	protected Object invokeInternal(Object arg0) throws Exception {
		AbonoBonificacionRequest abonoBonificacionRequest = (AbonoBonificacionRequest) arg0;

		return abonoBonificacionWS(abonoBonificacionRequest);
	}


	private AbonoBonificacionResponse abonoBonificacionWS(AbonoBonificacionRequest abonoBonificacionRequest){
		AbonoBonificacionValidacion abonoBonificacionValidacion = new AbonoBonificacionValidacion();
		AbonoBonificacionResponse abonoBonificacionResponse = new AbonoBonificacionResponse();

		try{
			//CLASE VALIDACION
			abonoBonificacionResponse = abonoBonificacionValidacion.isRequestValid(abonoBonificacionRequest);

			loggerSAFI.info("REQUEST: " +  Utileria.logJsonFormat(abonoBonificacionRequest));

			if(abonoBonificacionResponse.getCodigoRespuesta().equals(Constantes.STRING_CERO)){
				//PARAMETROS DE AUDITORIA
				abonoBonificacionRequest.asignaParametrosAud(abonoBonificacionServicio.getAbonoBonificacionDAO().getParametrosAuditoriaBean());

				//ABONO POR BONIFICACION
				abonoBonificacionResponse = abonoBonificacionServicio.abonoPorBonificacionWS(abonoBonificacionRequest);

				loggerSAFI.info("RESPONSE: " +  Utileria.logJsonFormat(abonoBonificacionResponse));

				if((Integer.parseInt(abonoBonificacionResponse.getCodigoRespuesta()) != 0 )){
					throw new Exception(abonoBonificacionResponse.getMensajeRespuesta());
				}
			}
		}catch(Exception e){
			e.printStackTrace();
			if(abonoBonificacionResponse.getCodigoRespuesta().equals(Constantes.STRING_CERO)){
				abonoBonificacionResponse.setCodigoRespuesta("999");
				abonoBonificacionResponse.setMensajeRespuesta("El SAFI ha tenido un problema al concretar la operacion. " +
										       				"Disculpe las molestias que esto le ocasiona. Ref: WS-ABONOBONIFICACION");
			}
		}
			

		return abonoBonificacionResponse;
	}



	public AbonoBonificacionServicio getAbonoBonificacionServicio() {
		return abonoBonificacionServicio;
	}

	public void setAbonoBonificacionServicio(AbonoBonificacionServicio abonoBonificacionServicio) {
		this.abonoBonificacionServicio = abonoBonificacionServicio;
	}
}