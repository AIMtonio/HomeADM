package operacionesCRCB.servicioweb;

import herramientas.Constantes;
import herramientas.Utileria;
import operacionesCRCB.beanWS.request.RompimientoGrupoRequest;
import operacionesCRCB.beanWS.response.RompimientoGrupoResponse;
import operacionesCRCB.beanWS.validacion.RompimientoGrupoValidacion;
import operacionesCRCB.servicio.RompimientoGrupoWSServicio;

import org.apache.log4j.Logger;
import org.springframework.oxm.Marshaller;
import org.springframework.ws.server.endpoint.AbstractMarshallingPayloadEndpoint;

public class CrcbRompimientoGrupoWS extends AbstractMarshallingPayloadEndpoint {

	private RompimientoGrupoWSServicio rompimientoGrupoWSServicio = null;
	protected final Logger loggerSAFI = Logger.getLogger("SAFI");

	public CrcbRompimientoGrupoWS(Marshaller marshaller){
		super(marshaller);
	}

	@Override
	protected Object invokeInternal(Object arg0) throws Exception {
		RompimientoGrupoRequest rompimientoGrupoRequest = (RompimientoGrupoRequest) arg0;

		return rompimientoGrupoWS(rompimientoGrupoRequest);
	}
	
	private RompimientoGrupoResponse rompimientoGrupoWS(RompimientoGrupoRequest rompimientoGrupoRequest) {
		RompimientoGrupoValidacion rompimientoGrupoValidacion = new RompimientoGrupoValidacion();
		RompimientoGrupoResponse rompimientoGrupoResponse = new RompimientoGrupoResponse();

		try{
			
			//Sección de validación
			rompimientoGrupoResponse = rompimientoGrupoValidacion.isRequestValid(rompimientoGrupoRequest);

			loggerSAFI.info("REQUEST: " +  Utileria.logJsonFormat(rompimientoGrupoRequest));

			if( rompimientoGrupoResponse.getCodigoRespuesta().equals(Constantes.STRING_CERO)) {
				
				// Asignación de parámetros de Auditoria
				rompimientoGrupoRequest.asignaParametrosAud(rompimientoGrupoWSServicio.getRompimientoGrupoWSDAO().getParametrosAuditoriaBean());

				// Proceso de Rompimiento de Grupo
				rompimientoGrupoResponse = rompimientoGrupoWSServicio.rompimientoGrupoWS(rompimientoGrupoRequest);

				loggerSAFI.info("RESPONSE: " +  Utileria.logJsonFormat(rompimientoGrupoResponse));

				if((Integer.parseInt(rompimientoGrupoResponse.getCodigoRespuesta()) != 0 )){
					throw new Exception(rompimientoGrupoResponse.getMensajeRespuesta());
				}
			}
		}catch(Exception e){
			e.printStackTrace();
			if(rompimientoGrupoResponse.getCodigoRespuesta().equals(Constantes.STRING_CERO)){
				rompimientoGrupoResponse.setCodigoRespuesta("999");
				rompimientoGrupoResponse.setMensajeRespuesta("El SAFI ha tenido un problema al concretar la operacion. " +
										       				 "Disculpe las molestias que esto le ocasiona. Ref: WS-ROMPIMIENTOGRUPO");
			}
		}
			
		return rompimientoGrupoResponse;
	}

	public RompimientoGrupoWSServicio getRompimientoGrupoWSServicio() {
		return rompimientoGrupoWSServicio;
	}

	public void setRompimientoGrupoWSServicio(
			RompimientoGrupoWSServicio rompimientoGrupoWSServicio) {
		this.rompimientoGrupoWSServicio = rompimientoGrupoWSServicio;
	}

}
