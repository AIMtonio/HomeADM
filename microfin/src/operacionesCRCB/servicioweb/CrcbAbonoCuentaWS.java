package operacionesCRCB.servicioweb;

import herramientas.Constantes;
import herramientas.Utileria;
import operacionesCRCB.beanWS.request.AbonoCuentaRequest;
import operacionesCRCB.beanWS.response.AbonoCuentaResponse;
import operacionesCRCB.beanWS.validacion.AbonoCuentaValidacion;
import operacionesCRCB.servicio.CargoAbonoCuentaServicio;
import operacionesCRCB.servicio.CargoAbonoCuentaServicio.Enum_Tra_CargoAbonoCta_WS;

import org.apache.log4j.Logger;
import org.springframework.oxm.Marshaller;
import org.springframework.ws.server.endpoint.AbstractMarshallingPayloadEndpoint;

public class CrcbAbonoCuentaWS extends AbstractMarshallingPayloadEndpoint {

	private CargoAbonoCuentaServicio cargoAbonoCuentaServicio = null;
	protected final Logger loggerSAFI = Logger.getLogger("SAFI");
	
	public CrcbAbonoCuentaWS(Marshaller marshaller) {
		super(marshaller);
		// TODO Auto-generated constructor stub
	}
	
	@Override
	protected Object invokeInternal(Object arg0) throws Exception {
		AbonoCuentaRequest abonoCuentaRequest = (AbonoCuentaRequest) arg0;
		
		return CrcbAbonoCuentaWS(abonoCuentaRequest);
	}
	
	private AbonoCuentaResponse CrcbAbonoCuentaWS(AbonoCuentaRequest abonoCuentaRequest){
		
		AbonoCuentaResponse   abonoCuentaResponse   = new AbonoCuentaResponse();
		AbonoCuentaValidacion abonoCuentaValidacion = new AbonoCuentaValidacion();
		try{

			abonoCuentaResponse = abonoCuentaValidacion.isRequestValid(abonoCuentaRequest);	
			
			if(abonoCuentaResponse.getCodigoRespuesta().equals(Constantes.STRING_CERO)){
				
				abonoCuentaRequest.asignaParametrosAud(cargoAbonoCuentaServicio.getCargoAbonoCuentaDAO().getParametrosAuditoriaBean());
				
				// abono a cuenta
				loggerSAFI.info("REQUEST: \n" +  Utileria.logJsonFormat(abonoCuentaRequest));
				abonoCuentaResponse = (AbonoCuentaResponse)cargoAbonoCuentaServicio.grabaTransaccion(abonoCuentaRequest, Enum_Tra_CargoAbonoCta_WS.abonoCuenta);
				loggerSAFI.info("RESPONSE: \n" +  Utileria.logJsonFormat(abonoCuentaResponse));
			
				if((Integer.parseInt(abonoCuentaResponse.getCodigoRespuesta()) != 0 )){
					throw new Exception(abonoCuentaResponse.getMensajeRespuesta());
				}
			}
			
		}catch (Exception e) {
		e.printStackTrace();	
		if(abonoCuentaResponse.getCodigoRespuesta().equals(Constantes.STRING_CERO)){
			abonoCuentaResponse.setCodigoRespuesta("999");
			abonoCuentaResponse.setMensajeRespuesta("Estimado Usuario(a), Ha ocurrido una falla en el sistema, "
					+ "estamos trabajando para resolverla. Disculpe las molestias que esto le ocasiona. Ref: WS-ABONOCUENTA");
			}			
		}	
		return abonoCuentaResponse;
	}

	public CargoAbonoCuentaServicio getCargoAbonoCuentaServicio() {
		return cargoAbonoCuentaServicio;
	}

	public void setCargoAbonoCuentaServicio(
			CargoAbonoCuentaServicio cargoAbonoCuentaServicio) {
		this.cargoAbonoCuentaServicio = cargoAbonoCuentaServicio;
	}
	
	

}
