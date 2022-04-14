package bancaMovil.dao;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.google.gson.Gson;

import bancaMovil.bean.BAMOperacionBean;
import bancaMovil.bean.TiposOperacionesBean;
import bancaMovil.beanWS.response.BanBitacoraOper;
import bancaMovil.beanWS.response.ConsultaBitacoraOperResponse;
import bancaMovil.beanWS.response.TiposOperaciones;
import bancaMovil.beanWS.response.TiposOperacionesResponse;
import general.bean.ParametrosSesionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import psl.rest.ConsumidorRest;
import soporte.dao.ParamGeneralesDAO;

public class BAMBitacoraOperDAO extends BaseDAO{
	
	private ParamGeneralesDAO paramGeneralesDAO;
	
	public BAMBitacoraOperDAO() {
		super();
	}
	
	ParametrosSesionBean parametrosSesionBean;

	private List<BAMOperacionBean> consumirListaBitacoras(Map<String, String> parameters) {
		List<BAMOperacionBean> respuestaFinal = new ArrayList<BAMOperacionBean>();
		
		String URLBase = paramGeneralesDAO.consultaPrincipal(null, ParamGeneralesDAO.Enum_Con_ParamGenerales.RutaMicrofinWSBancas).getValorParametro();
		String urlServicio = URLBase + "/banking/operationsLog";
		String autentificacionCodificada = paramGeneralesDAO.consultaPrincipal(null, ParamGeneralesDAO.Enum_Con_ParamGenerales.AutentificacionWSBancas).getValorParametro();
		
		try{
			ConsumidorRest<ConsultaBitacoraOperResponse> consumidorRest =  new ConsumidorRest<ConsultaBitacoraOperResponse>();
			consumidorRest.addHeader("Autentificacion", autentificacionCodificada);
			
			loggerSAFI.info("Intentado realizar el consumo al WS.");
			loggerSAFI.info("url:{" + urlServicio + "}");
			loggerSAFI.info("request : " + new Gson().toJson(parameters));
			
			ConsultaBitacoraOperResponse consultaBitacoraOperResponse =  consumidorRest.consumeGet(urlServicio, ConsultaBitacoraOperResponse.class, parameters);
			
			if(!Constantes.STR_CODIGOEXITO[0].equals(consultaBitacoraOperResponse.getResponseCode())){
				loggerSAFI.info(this.getClass()+" - "+"Error al consultar el Web Service: " + consultaBitacoraOperResponse.getResponseCode() + " - " + consultaBitacoraOperResponse.getResponseMessage());
				throw new Exception(consultaBitacoraOperResponse.getResponseMessage());
			}
			
			if(Constantes.STR_CODIGOEXITO[0].equals(consultaBitacoraOperResponse.getResponseCode())){
				loggerSAFI.info(this.getClass()+" - "+"Respuesta del Web Service : " + consultaBitacoraOperResponse.getResponseCode() + " - " + consultaBitacoraOperResponse.getResponseMessage());
			}
			
			BAMOperacionBean operacionBean = null;
			for(BanBitacoraOper banBitacoraOper : consultaBitacoraOperResponse.getListOperationsLog()) {
				
				operacionBean = new BAMOperacionBean();			
				operacionBean.setClienteID(banBitacoraOper.getCustomerNumber());
				operacionBean.setTipoOperacion(banBitacoraOper.getTypeOperationNumber());
				operacionBean.setOperationDate(banBitacoraOper.getOperationDate());
				operacionBean.setAmount(banBitacoraOper.getAmount());
				operacionBean.setDescription(banBitacoraOper.getDescription());
				operacionBean.setReference(banBitacoraOper.getReference());
				operacionBean.setFolio(banBitacoraOper.getFolio());
				operacionBean.setIp(banBitacoraOper.getIp());
				operacionBean.setDevice(banBitacoraOper.getDevice());
				operacionBean.setOrigin(banBitacoraOper.getOrigin());
				
				respuestaFinal.add(operacionBean);	
			}
			
		}catch(Exception e){
			respuestaFinal = new ArrayList<BAMOperacionBean>();
			loggerSAFI.info(this.getClass()+" - "+"Error en el proceso de consumo :" + e.getMessage());
			e.printStackTrace();
		}
		return respuestaFinal;
	}
	
	
	/**
	 * Lista de bitacora de operaciones.
	 * @param operacionBean
	 * @param fechaInicio
	 * @param fechaFin
	 * @return
	 */
	public List<?> listaPrincipal(BAMOperacionBean operacionBean,String  fechaInicio,String fechaFin) {
		
		Map<String, String> parameters = new HashMap<String, String>();
		
		parameters.put("customerNumber", operacionBean.getClienteID());
		parameters.put("startDate", fechaInicio);
		parameters.put("endDate", fechaFin);
		parameters.put("typeOperation", operacionBean.getTipoOperacion());
		
		List<BAMOperacionBean> operacionBeans = consumirListaBitacoras(parameters);

		return operacionBeans;
	}
	
	public List<?> listaTiposOperaciones() {
		
		Map<String, String> parameters = new HashMap<String, String>();
		
		parameters.put("origin", "C");
		
		List<TiposOperacionesBean> operacionBeans = consumirListaTiposOperacion(parameters);
		
		return operacionBeans;
	}
	private List<TiposOperacionesBean> consumirListaTiposOperacion(Map<String, String> parameters) {
		List<TiposOperacionesBean> respuestaFinal = new ArrayList<TiposOperacionesBean>();
		
		String URLBase = paramGeneralesDAO.consultaPrincipal(null, ParamGeneralesDAO.Enum_Con_ParamGenerales.RutaMicrofinWSBancas).getValorParametro();
		String urlServicio = URLBase + "/support/operationsTypesLogBanking";
		String autentificacionCodificada = paramGeneralesDAO.consultaPrincipal(null, ParamGeneralesDAO.Enum_Con_ParamGenerales.AutentificacionWSBancas).getValorParametro();
		
		try{
			ConsumidorRest<TiposOperacionesResponse> consumidorRest =  new ConsumidorRest<TiposOperacionesResponse>();
			consumidorRest.addHeader("Autentificacion", autentificacionCodificada);
			
			loggerSAFI.info("Intentado realizar el consumo al WS.");
			loggerSAFI.info("url:{" + urlServicio + "}");
			loggerSAFI.info("request : " + new Gson().toJson(parameters));
			
			TiposOperacionesResponse consultaBitacoraOperResponse =  consumidorRest.consumeGet(urlServicio, TiposOperacionesResponse.class, parameters);
			
			if(!Constantes.STR_CODIGOEXITO[0].equals(consultaBitacoraOperResponse.getResponseCode())){
				loggerSAFI.info(this.getClass()+" - "+"Error al consultar el Web Service: " + consultaBitacoraOperResponse.getResponseCode() + " - " + consultaBitacoraOperResponse.getResponseMessage());
				throw new Exception(consultaBitacoraOperResponse.getResponseMessage());
			}
			
			if(Constantes.STR_CODIGOEXITO[0].equals(consultaBitacoraOperResponse.getResponseCode())){
				loggerSAFI.info(this.getClass()+" - "+"Respuesta del Web Service : " + consultaBitacoraOperResponse.getResponseCode() + " - " + consultaBitacoraOperResponse.getResponseMessage());
			}
			
			TiposOperacionesBean operacionBean = null;
			for(TiposOperaciones banBitacoraOper : consultaBitacoraOperResponse.getListOperationsTypes()) {
				
				operacionBean = new TiposOperacionesBean();			
				operacionBean.setDescripcion(banBitacoraOper.getDescription());
				operacionBean.setTipoOperacionID(banBitacoraOper.getOperationTypeNumber());
				
				respuestaFinal.add(operacionBean);	
			}
			
		}catch(Exception e){
			respuestaFinal = new ArrayList<TiposOperacionesBean>();
			loggerSAFI.info(this.getClass()+" - "+"Error en el proceso de consumo :" + e.getMessage());
			e.printStackTrace();
		}
		return respuestaFinal;
	}
	

	
	public ParametrosSesionBean getParametrosSesionBean() {
		return parametrosSesionBean;
	}

	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}


	public ParamGeneralesDAO getParamGeneralesDAO() {
		return paramGeneralesDAO;
	}


	public void setParamGeneralesDAO(ParamGeneralesDAO paramGeneralesDAO) {
		this.paramGeneralesDAO = paramGeneralesDAO;
	}

	

}
