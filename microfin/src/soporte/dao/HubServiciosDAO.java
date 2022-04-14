package soporte.dao;

import general.dao.BaseDAO;
import soporte.beanWS.request.TimbradoEdoCtaRequest;
import soporte.beanWS.response.TimbradoEdoCtaResponse;
import soporte.consumo.rest.ConsumidorRest;

public class HubServiciosDAO extends BaseDAO {
	/**
	 * Consume ws para timbrado por rest
	 * @param timbradoEdoCtaRequest
	 * @param urlServicio
	 * @param autentificacionCodif
	 * @return
	 */
	public TimbradoEdoCtaResponse timbrarSWRest(final TimbradoEdoCtaRequest timbradoEdoCtaRequest, String urlServicio, String autentificacionCodif)  {
		TimbradoEdoCtaResponse timbradoEdoCtaResponse = null;
		
		try {
			ConsumidorRest<TimbradoEdoCtaResponse> consumidorRest = new ConsumidorRest<TimbradoEdoCtaResponse>();
			consumidorRest.addHeader("Autentificacion", autentificacionCodif);
			loggerSAFI.info("Intentado realizar el consumo al WS de Hub de Servicios para Timbrado CFDI.");
			loggerSAFI.info("URL:{" + urlServicio + "}");
			loggerSAFI.info("CadenaTimbrado:" + timbradoEdoCtaRequest.getCadenaTimbrado());
			loggerSAFI.info("IdentificadorBus:" + timbradoEdoCtaRequest.getIdentificadorBus());
			loggerSAFI.info("Auth:" + autentificacionCodif);
			
			timbradoEdoCtaResponse = consumidorRest.consumePost(urlServicio, timbradoEdoCtaRequest, TimbradoEdoCtaResponse.class);
			loggerSAFI.info("Respuesta de HubServicios:" + timbradoEdoCtaResponse.getCodigoRespuesta() + "-" + timbradoEdoCtaResponse.getMensajeRespuesta());
		}catch(org.springframework.web.client.ResourceAccessException e){
			
			timbradoEdoCtaResponse = new TimbradoEdoCtaResponse();
			timbradoEdoCtaResponse.setCodigoRespuesta("408");
			timbradoEdoCtaResponse.setMensajeRespuesta("No fue posible conectarse: El servidor se encuentra inactivo o la dirección no es correcta, revise las configuraciones.");
			loggerSAFI.info(this.getClass()+" - "+"No fue posible conectarse al servidor o se encuentra inactivo, revise las configuraciones:" + e.getMessage());
			e.printStackTrace();
		}
		catch (Exception e) {
			loggerSAFI.info(this.getClass()+" - "+"Error en el proceso de consumidor post para timbrado :" + e.getMessage());
			e.printStackTrace();
		}
		return timbradoEdoCtaResponse; 
	}
}
