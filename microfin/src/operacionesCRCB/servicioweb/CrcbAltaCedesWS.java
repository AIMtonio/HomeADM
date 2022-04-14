package operacionesCRCB.servicioweb;

import general.dao.TransaccionDAO;
import herramientas.Constantes;
import herramientas.Utileria;
import operacionesCRCB.beanWS.request.AltaCedesRequest;
import operacionesCRCB.beanWS.response.AltaCedesResponse;
import operacionesCRCB.beanWS.validacion.AltaCedesValidacion;
import operacionesCRCB.servicio.AltaCedesServicio;
import operacionesCRCB.servicio.AltaCedesServicio.Enum_Tra_Cedes_WS;

import org.apache.log4j.Logger;
import org.springframework.oxm.Marshaller;
import org.springframework.ws.server.endpoint.AbstractMarshallingPayloadEndpoint;

public class CrcbAltaCedesWS extends AbstractMarshallingPayloadEndpoint{

	private AltaCedesServicio altaCedesServicio= null;
	private TransaccionDAO transaccionDAO 	= null;
	protected final Logger loggerSAFI = Logger.getLogger("SAFI");

	
	public CrcbAltaCedesWS(Marshaller marshaller) {
		super(marshaller);
		// TODO Auto-generated constructor stub
	}

	
	@Override
	protected Object invokeInternal(Object arg0) throws Exception {
		AltaCedesRequest altaCedesRequest = (AltaCedesRequest) arg0;
		
		return CrcbAltaInversionWS(altaCedesRequest);
	}
	
	
	private AltaCedesResponse CrcbAltaInversionWS(AltaCedesRequest altaCedesRequest){
		
		AltaCedesResponse   altaCedesResponse   = new AltaCedesResponse();
		AltaCedesValidacion altaCedesValidacion = new AltaCedesValidacion();
		
		try{
			altaCedesResponse = altaCedesValidacion.isRequestValid(altaCedesRequest);	
			
			if(altaCedesResponse.getCodigoRespuesta().equals(Constantes.STRING_CERO)){
				
				altaCedesRequest.asignaParametrosAud(altaCedesServicio.getAltaCedesDAO().getParametrosAuditoriaBean());
				
				// alta cede
				loggerSAFI.info("REQUEST: " +  Utileria.logJsonFormat(altaCedesRequest));
				altaCedesResponse = (AltaCedesResponse)altaCedesServicio.grabaTransaccion(altaCedesRequest, Enum_Tra_Cedes_WS.altaCede);
				loggerSAFI.info("RESPONSE: " +  Utileria.logJsonFormat(altaCedesResponse));
			
				if((Integer.parseInt(altaCedesResponse.getCodigoRespuesta()) != 0 )){
					throw new Exception(altaCedesResponse.getMensajeRespuesta());
				} 
			}
			
		}catch (Exception e) {
		e.printStackTrace();	
		if(altaCedesResponse.getCodigoRespuesta().equals(Constantes.STRING_CERO)){
			altaCedesResponse.setCodigoRespuesta("999");
			altaCedesResponse.setMensajeRespuesta("Estimado Usuario(a), Ha ocurrido una falla en el sistema, "
					+ "estamos trabajando para resolverla. Disculpe las molestias que esto le ocasiona. Ref: WS-ALTACEDES");
			}			
		}	
		return altaCedesResponse;
	}


	public AltaCedesServicio getAltaCedesServicio() {
		return altaCedesServicio;
	}


	public void setAltaCedesServicio(AltaCedesServicio altaCedesServicio) {
		this.altaCedesServicio = altaCedesServicio;
	}


	public TransaccionDAO getTransaccionDAO() {
		return transaccionDAO;
	}


	public void setTransaccionDAO(TransaccionDAO transaccionDAO) {
		this.transaccionDAO = transaccionDAO;
	}
	
	
	
}
