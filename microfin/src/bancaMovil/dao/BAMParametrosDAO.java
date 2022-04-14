package bancaMovil.dao;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.Arrays;
import java.util.List;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;

import com.google.gson.Gson;

import psl.rest.ConsumidorRest;

import soporte.dao.ParamGeneralesDAO;

import bancaMovil.bean.BAMParametrosBean;
import bancaMovil.beanWS.request.ModificarParametrosSisRequest;
import bancaMovil.beanWS.response.ConsultaParametrosBancaResponse;
import bancaMovil.beanWS.response.ModificarParametrosSisResponse;
import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

public class BAMParametrosDAO extends BaseDAO{
	
	ParametrosSesionBean parametrosSesionBean;

	private ParamGeneralesDAO paramGeneralesDAO;
	
	public BAMParametrosDAO() {
		super();
	}
	/* Consuta de parametros generales para la aplicación de banca movil*/
	public BAMParametrosBean consultaPrincipal() {
		BAMParametrosBean parametrosBean = null;
				
		String URLBase = paramGeneralesDAO.consultaPrincipal(null, ParamGeneralesDAO.Enum_Con_ParamGenerales.RutaMicrofinWSBancas).getValorParametro();
		
		String urlServicio = URLBase + "/admon/bankingParams";
		String autentificacionCodificada = paramGeneralesDAO.consultaPrincipal(null, ParamGeneralesDAO.Enum_Con_ParamGenerales.AutentificacionWSBancas).getValorParametro();
		
		try{
			ConsumidorRest<ConsultaParametrosBancaResponse> consumidorRest =  new ConsumidorRest<ConsultaParametrosBancaResponse>();
			consumidorRest.addHeader("Autentificacion", autentificacionCodificada);
			
			loggerSAFI.info("Intentando realizar el consumo al WS de consulta de parametros de sistema");
			loggerSAFI.info("url:{" + urlServicio + "}");
			loggerSAFI.info("request : ");
			
			ConsultaParametrosBancaResponse consultaParametrosBancaResponse =  consumidorRest.consumeGet(urlServicio, ConsultaParametrosBancaResponse.class, null);
			
			if(!Constantes.STR_CODIGOEXITO[0].equals(consultaParametrosBancaResponse.getResponseCode())){
				loggerSAFI.info(this.getClass()+" - "+"Error al consultar el Web Service de consulta de parametros de sistema: " + consultaParametrosBancaResponse.getResponseCode() + " - " + consultaParametrosBancaResponse.getResponseMessage());
				throw new Exception(consultaParametrosBancaResponse.getResponseMessage());
			}
			
			if(Constantes.STR_CODIGOEXITO[0].equals(consultaParametrosBancaResponse.getResponseCode())){
				loggerSAFI.info(this.getClass()+" - "+"Respuesta del Web Service de consulta de parametros de sistema : " + consultaParametrosBancaResponse.getResponseCode() + " - " + consultaParametrosBancaResponse.getResponseMessage());
			}
			
			parametrosBean = new BAMParametrosBean();
			
			parametrosBean.setEmpresaID(consultaParametrosBancaResponse.getCompanyNumber());
			parametrosBean.setNombreCortoInsitucion(consultaParametrosBancaResponse.getInstitShortName());
			parametrosBean.setTextoActivacionSMS(consultaParametrosBancaResponse.getTextCodeSmsAct());
			parametrosBean.setIvaPagarSpei(consultaParametrosBancaResponse.getVatPaySpei());
			parametrosBean.setUsuarioSpei(consultaParametrosBancaResponse.getUserSpei());
			parametrosBean.setRutaArchivos(consultaParametrosBancaResponse.getPathfiles());
			parametrosBean.setTextoNotifNuevoUsuario(consultaParametrosBancaResponse.getSubjetNotiRegisBam());
			parametrosBean.setTextoNotifiCambioSeg(consultaParametrosBancaResponse.getSubjetNotiChangeBam());
			parametrosBean.setTextoNotifPagos(consultaParametrosBancaResponse.getSubjetNotiPayBam());
			parametrosBean.setTextoNotifSesion(consultaParametrosBancaResponse.getSubjectNotificationSession());
			parametrosBean.setTextoNotifTransferencias(consultaParametrosBancaResponse.getTransferNotificationIssue());
			parametrosBean.setTiempoValidoSMS(consultaParametrosBancaResponse.getTimeValidateSMS());
			parametrosBean.setRemitente(consultaParametrosBancaResponse.getRemitterBam());
			parametrosBean.setMinimoCaracteresPin(consultaParametrosBancaResponse.getMinCharactersPass());
			parametrosBean.setUrlFreja(consultaParametrosBancaResponse.getFrejaUrl());
			parametrosBean.setTituloTransaccion(consultaParametrosBancaResponse.getTransactionTitle());
			parametrosBean.setPeriodoValidacion(consultaParametrosBancaResponse.getValidityPeriod());
			parametrosBean.setTiempoMaxEspera(consultaParametrosBancaResponse.getMaxWaitTime());
			parametrosBean.setTiempoAprovisionamiento(consultaParametrosBancaResponse.getProvisionTime());
			
		}catch(Exception e){
			parametrosBean = null;
			loggerSAFI.info(this.getClass()+" - "+"Error en el proceso de envio a SGC :" + e.getMessage());
			e.printStackTrace();
		}
		
		return parametrosBean;
	}

	public MensajeTransaccionBean modificaParametros(final BAMParametrosBean  parametros) {
		MensajeTransaccionBean mensajeTransaccion = null;
	
		String URLBase = paramGeneralesDAO.consultaPrincipal(null, ParamGeneralesDAO.Enum_Con_ParamGenerales.RutaMicrofinWSBancas).getValorParametro();
		String urlServicio = URLBase + "/admon/modifyParameters";
		String autentificacionCodificada = paramGeneralesDAO.consultaPrincipal(null, ParamGeneralesDAO.Enum_Con_ParamGenerales.AutentificacionWSBancas).getValorParametro();
		
		ModificarParametrosSisRequest beanRequest = new ModificarParametrosSisRequest();
		
		beanRequest.setCompanyNumber(parametros.getEmpresaID());
		beanRequest.setShortNameInstitution(parametros.getNombreCortoInsitucion());
		beanRequest.setTextCodeActSMS(parametros.getTextoActivacionSMS());
		beanRequest.setVatPaySPEI(parametros.getIvaPagarSpei());
		beanRequest.setUserShippingSPEI(parametros.getUsuarioSpei());
		beanRequest.setPathfiles(parametros.getRutaArchivos());
		beanRequest.setSubjectNotifNewUser(parametros.getTextoNotifNuevoUsuario());
		beanRequest.setSubjectNotifChangeOptions(parametros.getTextoNotifiCambioSeg());
		beanRequest.setPaymentNotificationMatter(parametros.getTextoNotifSesion());
		beanRequest.setSubjectNotificationSession(parametros.getTextoNotifSesion());
		beanRequest.setTransferNotificationIssue(parametros.getTextoNotifTransferencias());
		beanRequest.setTimeValidateSMS(parametros.getTiempoValidoSMS());
		beanRequest.setBankSender(parametros.getRemitente());
		beanRequest.setMinCharactersPass(parametros.getMinimoCaracteresPin());
		beanRequest.setFrejaUrl(parametros.getUrlFreja());
		beanRequest.setTransactionTitle(parametros.getTituloTransaccion());
		beanRequest.setValidityPeriod(parametros.getPeriodoValidacion());
		beanRequest.setMaxWaitTime(parametros.getTiempoMaxEspera());
		beanRequest.setProvisionTime(parametros.getTiempoAprovisionamiento());
		
		
		try{
			ConsumidorRest<ModificarParametrosSisResponse> consumidorRest =  new ConsumidorRest<ModificarParametrosSisResponse>();
			consumidorRest.addHeader("Autentificacion", autentificacionCodificada);
			
			loggerSAFI.info("Intentado realizar el consumo al WS de modifica parametros de sistema de las bancas.");
			loggerSAFI.info("url:{" + urlServicio + "}");
			loggerSAFI.info("request : "+ new Gson().toJson(beanRequest));
			
			ModificarParametrosSisResponse modificarParametrosSisResponse =  consumidorRest.consumePost(urlServicio,beanRequest, ModificarParametrosSisResponse.class);
			
			mensajeTransaccion = new MensajeTransaccionBean();
			
			if(Constantes.STR_CODIGOEXITO[0].equals(modificarParametrosSisResponse.getResponseCode())){
				
				mensajeTransaccion.setNumero(Utileria.convierteEntero(modificarParametrosSisResponse.getResponseCode()));
				mensajeTransaccion.setDescripcion(modificarParametrosSisResponse.getResponseMessage());
				mensajeTransaccion.setNombreControl("empresaID");
				mensajeTransaccion.setConsecutivoString(modificarParametrosSisResponse.getConsecutive());
				
				loggerSAFI.info(this.getClass()+" - "+"Respuesta del Web Service de modifica parametros de sistema : " + modificarParametrosSisResponse.getResponseCode() + " - " + modificarParametrosSisResponse.getResponseMessage());
			}
			
			if(!Constantes.STR_CODIGOEXITO[0].equals(modificarParametrosSisResponse.getResponseCode())){
				
				mensajeTransaccion.setNumero(999);
				mensajeTransaccion.setDescripcion("Fallo. Ocurrio un error al modificar los parametros del sistema.");
				
				loggerSAFI.info(modificarParametrosSisResponse.getResponseMessage());
			}
			
		}catch(Exception e){
			if(mensajeTransaccion == null){
				mensajeTransaccion = new MensajeTransaccionBean();
				mensajeTransaccion.setNumero(999);
			}
			mensajeTransaccion.setDescripcion("Error en el proceso de envio a WS de modifica parametros de sistema: " + e.getMessage());
			loggerSAFI.info(this.getClass()+" - "+"Error en el proceso de envio a WS de modifica parametros de sistema:" + e.getMessage());
			e.printStackTrace();
		}
		
		return mensajeTransaccion;
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
