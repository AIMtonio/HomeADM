package operacionesCRCB.servicioweb;

import herramientas.Constantes;
import herramientas.Utileria;
import operacionesCRCB.beanWS.request.RetiroCuentaRequest;
import operacionesCRCB.beanWS.response.RetiroCuentaResponse;
import operacionesCRCB.beanWS.validacion.RetiroCuentaValidacion;
import operacionesCRCB.servicio.CargoAbonoCuentaServicio;
import operacionesCRCB.servicio.CargoAbonoCuentaServicio.Enum_Tra_CargoAbonoCta_WS;

import org.apache.log4j.Logger;
import org.springframework.oxm.Marshaller;
import org.springframework.ws.server.endpoint.AbstractMarshallingPayloadEndpoint;

public class CrcbRetiroCuentaWS extends AbstractMarshallingPayloadEndpoint {

	private CargoAbonoCuentaServicio cargoAbonoCuentaServicio = null;
	protected final Logger loggerSAFI = Logger.getLogger("SAFI");

	public CrcbRetiroCuentaWS(Marshaller marshaller) {
		super(marshaller);
		// TODO Auto-generated constructor stub
	}
	
	@Override
	protected Object invokeInternal(Object arg0) throws Exception {
		RetiroCuentaRequest retiroCuentaRequest = (RetiroCuentaRequest) arg0;
		
		return CrcbRetiroCuentaWS(retiroCuentaRequest);
	}
	
	private RetiroCuentaResponse CrcbRetiroCuentaWS(RetiroCuentaRequest retiroCuentaRequest){
		
		RetiroCuentaResponse   retiroCuentaResponse   = new RetiroCuentaResponse();
		RetiroCuentaValidacion retiroCuentaValidacion = new RetiroCuentaValidacion();
		
		try{
			retiroCuentaResponse = retiroCuentaValidacion.isRequestValid(retiroCuentaRequest);	
			
			if(retiroCuentaResponse.getCodigoRespuesta().equals(Constantes.STRING_CERO)){
				
				retiroCuentaRequest.asignaParametrosAud(cargoAbonoCuentaServicio.getCargoAbonoCuentaDAO().getParametrosAuditoriaBean());

				// abono a cuenta
				loggerSAFI.info("REQUEST: " +  Utileria.logJsonFormat(retiroCuentaRequest));
				retiroCuentaResponse = (RetiroCuentaResponse)cargoAbonoCuentaServicio.grabaTransaccion(retiroCuentaRequest, Enum_Tra_CargoAbonoCta_WS.cargoCuenta);
				loggerSAFI.info("RESPONSE: " +  Utileria.logJsonFormat(retiroCuentaResponse));
			
				if((Integer.parseInt(retiroCuentaResponse.getCodigoRespuesta()) != 0 )){
					throw new Exception(retiroCuentaResponse.getMensajeRespuesta());
				} else {
				
					retiroCuentaResponse.setCodigoRespuesta(retiroCuentaResponse.getCodigoRespuesta());
					retiroCuentaResponse.setMensajeRespuesta(retiroCuentaResponse.getMensajeRespuesta());
				}
			}
			
		}catch (Exception e) {
		e.printStackTrace();	
		if(retiroCuentaResponse.getCodigoRespuesta().equals(Constantes.STRING_CERO)){
			retiroCuentaResponse.setCodigoRespuesta("999");
			retiroCuentaResponse.setMensajeRespuesta("Estimado Usuario(a), Ha ocurrido una falla en el sistema, "
					+ "estamos trabajando para resolverla. Disculpe las molestias que esto le ocasiona. Ref: WS-RETIROCUENTA");
			}			
		}
		
		return retiroCuentaResponse;
	}

	
	public CargoAbonoCuentaServicio getCargoAbonoCuentaServicio() {
		return cargoAbonoCuentaServicio;
	}

	public void setCargoAbonoCuentaServicio(
			CargoAbonoCuentaServicio cargoAbonoCuentaServicio) {
		this.cargoAbonoCuentaServicio = cargoAbonoCuentaServicio;
	}

	
}
