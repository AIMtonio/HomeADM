package bancaMovil.dao;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;

import psl.rest.ConsumidorRest;

import soporte.dao.ParamGeneralesDAO;

import com.google.gson.Gson;
import bancaMovil.bean.BAMOperacionBean;
import bancaMovil.bean.BAMUsuariosBean;

import bancaMovil.servicio.BAMBitacoraOperServicio.Enum_Tipo_Operaciones;
import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

import bancaMovil.beanWS.response.UserListResponse;
import bancaMovil.beanWS.request.RegisterUserRequest;
import bancaMovil.beanWS.response.ActualizarUsuarioStatusResponse;
import bancaMovil.beanWS.response.BanUsuarioRes;
import bancaMovil.beanWS.response.ModifyUserRequest;
import bancaMovil.beanWS.response.UserTransacctionResponse;
import bancaMovil.beanWS.request.ActualizarUsuarioStatusRequest;
import bancaMovil.beanWS.response.ChangePasswordBeanResponse;
import bancaMovil.beanWS.request.ChangePasswordBeanRequest;

public class BAMUsuariosDAO extends BaseDAO {

	private ParamGeneralesDAO paramGeneralesDAO;

	public BAMUsuariosDAO() {
		super();
	}

	BAMBitacoraOperDAO bitacoraDAO = null;
	ParametrosSesionBean parametrosSesionBean;
	private final static String salidaPantalla = "S";
	public static String MSG_CAMBIO_IMG_ANTIPHISHING = "CAMBIASTE TU IMAGEN ANTIPHISHING";
	public static String MSG_CAMBIO_FRASE = "CAMBIASTE TU FRASE DE SEGURIDAD";
	public static String MSG_CAMBIO_NIP = "CAMBIASTE TU NIP";
	public static String MSG_CAMBIO_PREG_SECR = "CAMBIASTE PREG. Y RSPTA SECRETA";
	public static String MSG_ACCESO_BM = "ACCESO BANCA MOVIL";

	// ------------------ Transacciones
	// ------------------------------------------
	/* Alta del BAMUsuarios */
		public MensajeTransaccionBean altaUsuarios(Object bean) {
		
		BAMUsuariosBean altaUsuarioBean = (BAMUsuariosBean) bean;
		
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		
		String URLBase = paramGeneralesDAO.consultaPrincipal(null, ParamGeneralesDAO.Enum_Con_ParamGenerales.RutaMicrofinWSBancas).getValorParametro();
		String urlServicio = URLBase + "/banking/registerUser";
		
		String autentificacionCodificada = paramGeneralesDAO.consultaPrincipal(null, ParamGeneralesDAO.Enum_Con_ParamGenerales.AutentificacionWSBancas).getValorParametro();
		Gson gson = new Gson();
		
		try{
			
			RegisterUserRequest userRequest = new RegisterUserRequest();
			userRequest.setCustomerNumber(altaUsuarioBean.getClienteID());
			userRequest.setPhone(altaUsuarioBean.getTelefono());
			userRequest.setEmail(altaUsuarioBean.getEmail());
			userRequest.setSecretQuestionAnswer(altaUsuarioBean.getRespuestaPregSecreta());
			userRequest.setProfileNumber(altaUsuarioBean.getPerfilID());
			userRequest.setSecretQuestionNumber(altaUsuarioBean.getPreguntaSecretaID());
			userRequest.setWelcomePhrase(altaUsuarioBean.getFraseBienvenida());
			userRequest.setKeyUser(altaUsuarioBean.getClave());
			userRequest.setPassword(altaUsuarioBean.getContrasenia());
			userRequest.setFirstName(altaUsuarioBean.getPrimerNombre());
			userRequest.setSecondName(altaUsuarioBean.getSegundoNombre());
			userRequest.setSurname(altaUsuarioBean.getApellidoPaterno());
			userRequest.setSecondSurname(altaUsuarioBean.getApellidoMaterno());
			userRequest.setFullName(altaUsuarioBean.getNombreCompleto());
			userRequest.setImagenAntiphi(altaUsuarioBean.getImagenPhishingID());
			userRequest.setImei(altaUsuarioBean.getImei());
			userRequest.setOrigin("C");
			userRequest.setMobileBankingServ(altaUsuarioBean.getServicioBancaMov());
			userRequest.setWebBankingServ(altaUsuarioBean.getServicioBancaWeb());
			ConsumidorRest<UserTransacctionResponse> consumidorRest =  new ConsumidorRest<UserTransacctionResponse>();
			consumidorRest.addHeader("Autentificacion", autentificacionCodificada);
			
			loggerSAFI.info("Intentado realizar el consumo al WS de registro de usuarios de las bancas.");
			loggerSAFI.info("url:{" + urlServicio + "}");
			loggerSAFI.info("request : " + gson.toJson(userRequest));
			
			UserTransacctionResponse userTransacctionResponse =  consumidorRest.consumePost(urlServicio, userRequest, UserTransacctionResponse.class);
			
			if(!Constantes.STR_CODIGOEXITO[0].equals(userTransacctionResponse.getResponseCode())){
				loggerSAFI.info(this.getClass()+" - "+"Error al consultar el Web Service: " + userTransacctionResponse.getResponseCode() + " - " + userTransacctionResponse.getResponseMessage());
				throw new Exception(userTransacctionResponse.getResponseMessage());
			}
			
			if(Constantes.STR_CODIGOEXITO[0].equals(userTransacctionResponse.getResponseCode())){
				loggerSAFI.info(this.getClass()+" - "+"Respuesta del Web Service : " + userTransacctionResponse.getResponseCode() + " - " + userTransacctionResponse.getResponseMessage());
			}
			
			mensaje = new MensajeTransaccionBean();
			
			mensaje.setDescripcion(userTransacctionResponse.getResponseMessage());
			mensaje.setNumero(Utileria.convierteEntero(userTransacctionResponse.getResponseCode()));
			mensaje.setConsecutivoInt(userTransacctionResponse.getUserNumber());
			
		}catch(Exception e){
			mensaje.setNumero(999);
			mensaje.setDescripcion("Error en el proceso de envio a WS : " + e.getMessage());
			loggerSAFI.info(this.getClass()+" - "+"Error en el proceso de envio :" + e.getMessage());
			e.printStackTrace();
		}
		
		return mensaje;
	}
	
	public MensajeTransaccionBean modificaUsuarios(Object bean) {

		BAMUsuariosBean modificarUsuarioBean = (BAMUsuariosBean) bean;
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		
		String URLBase = paramGeneralesDAO.consultaPrincipal(null, ParamGeneralesDAO.Enum_Con_ParamGenerales.RutaMicrofinWSBancas).getValorParametro();
		String urlServicio = URLBase + "/banking/modifyUser";
		String autentificacionCodificada = paramGeneralesDAO.consultaPrincipal(null, ParamGeneralesDAO.Enum_Con_ParamGenerales.AutentificacionWSBancas).getValorParametro();

		try{
			
			ModifyUserRequest modifyUserRequest = new ModifyUserRequest();
			modifyUserRequest.setUserNumer(modificarUsuarioBean.getUsuarioID());
			modifyUserRequest.setKeyUser(modificarUsuarioBean.getClave());
			modifyUserRequest.setCustomerNumber(modificarUsuarioBean.getClienteID());
			modifyUserRequest.setFirstName(modificarUsuarioBean.getPrimerNombre());
			modifyUserRequest.setSecondName(modificarUsuarioBean.getSegundoNombre());
			modifyUserRequest.setSurname(modificarUsuarioBean.getApellidoPaterno());
			modifyUserRequest.setSecondSurname(modificarUsuarioBean.getApellidoPaterno());
			modifyUserRequest.setFullName(modificarUsuarioBean.getNombreCompleto());
			modifyUserRequest.setProfile(modificarUsuarioBean.getPerfilID());
			modifyUserRequest.setStatus(modificarUsuarioBean.getEstatus());
			modifyUserRequest.setCreatedDate(modificarUsuarioBean.getFechaCreacion());
			modifyUserRequest.setEmail(modificarUsuarioBean.getEmail());
			modifyUserRequest.setPhone(modificarUsuarioBean.getTelefono());
			modifyUserRequest.setImagenAntiphi(modificarUsuarioBean.getImagenPhishingID());
			modifyUserRequest.setSecretQuestionNumber(modificarUsuarioBean.getPreguntaSecretaID());
			modifyUserRequest.setSecretQuestionAnswer(modificarUsuarioBean.getRespuestaPregSecreta());
			modifyUserRequest.setWelcomePhrase(modificarUsuarioBean.getFraseBienvenida());
			modifyUserRequest.setImei(modificarUsuarioBean.getImei());
			modifyUserRequest.setLastAccess(modificarUsuarioBean.getFechaUltimoAcceso());
			modifyUserRequest.setFailedsLogin(modificarUsuarioBean.getLoginsFallidos());
			modifyUserRequest.setStatusSession(modificarUsuarioBean.getEstatusSesion());
			modifyUserRequest.setCancelDate(modificarUsuarioBean.getFechaCancel());
			modifyUserRequest.setReasonCancel(modificarUsuarioBean.getMotivoCancel());
			modifyUserRequest.setBlockingDate(modificarUsuarioBean.getFechaBloqueo());
			modifyUserRequest.setBlockingReason(modificarUsuarioBean.getMotivoBloqueo());
			modifyUserRequest.setMobileBankingServ(modificarUsuarioBean.getServicioBancaMov());
			modifyUserRequest.setWebBankingServ(modificarUsuarioBean.getServicioBancaWeb());
			
			ConsumidorRest<UserTransacctionResponse> consumidorRest =  new ConsumidorRest<UserTransacctionResponse>();
			consumidorRest.addHeader("Autentificacion", autentificacionCodificada);
			
			loggerSAFI.info("Intentado realizar el consumo al WS de registro de usuarios de las bancas.");
			loggerSAFI.info("url:{" + urlServicio + "}");
			loggerSAFI.info("request : " + new Gson().toJson(modifyUserRequest));
			
			UserTransacctionResponse userTransacctionResponse =  consumidorRest.consumePost(urlServicio, modifyUserRequest, UserTransacctionResponse.class);
			
			if(!Constantes.STR_CODIGOEXITO[0].equals(userTransacctionResponse.getResponseCode())){
				loggerSAFI.info(this.getClass()+" - "+"Error al consultar el Web Service: " + userTransacctionResponse.getResponseCode() + " - " + userTransacctionResponse.getResponseMessage());
				throw new Exception(userTransacctionResponse.getResponseMessage());
			}
			
			if(Constantes.STR_CODIGOEXITO[0].equals(userTransacctionResponse.getResponseCode())){
				loggerSAFI.info(this.getClass()+" - "+"Respuesta del Web Service : " + userTransacctionResponse.getResponseCode() + " - " + userTransacctionResponse.getResponseMessage());
			}
			
			mensaje = new MensajeTransaccionBean();
			
			mensaje.setDescripcion(userTransacctionResponse.getResponseMessage());
			mensaje.setNumero(Utileria.convierteEntero(userTransacctionResponse.getResponseCode()));
			mensaje.setConsecutivoInt(userTransacctionResponse.getUserNumber());
			
		}catch(Exception e){
			mensaje.setNumero(999);
			mensaje.setDescripcion("Error en el proceso de envio a WS : " + e.getMessage());
			loggerSAFI.info(this.getClass()+" - "+"Error en el proceso de envio :" + e.getMessage());
			e.printStackTrace();
		}
		
		return mensaje;
	}

	public BAMUsuariosBean consultaPrincipal(int userNumber) {
		BAMUsuariosBean perfilBean = null;
		
		Map<String, String> parameters = new HashMap<String, String>();
		parameters.put("customerNumber", String.valueOf(userNumber));
		
		List<BAMUsuariosBean> lista = consumirListaUsuarios(parameters);
		
		if(lista.isEmpty()) {
			return null;
		}
		
		perfilBean = lista.get(0);
		
		return perfilBean;
	}
	
	public List<?> listaPrincipal(Object bean, int tipoLista) {
		
		BAMUsuariosBean banUsuario = (BAMUsuariosBean) bean;
		
		Map<String, String> parameters = new HashMap<String, String>();
		parameters.put("userNumber", banUsuario.getUsuarioID());
		parameters.put("customerNumber", banUsuario.getClienteID());
		if(banUsuario.getNombreCompleto() == null){
			parameters.put("fullName", Constantes.STRING_VACIO);
		}else{
			parameters.put("fullName", banUsuario.getNombreCompleto());
		}
		if(banUsuario.getNombreCompleto() == null){
			parameters.put("keyUser", Constantes.STRING_VACIO);
		}else{
			parameters.put("keyUser", banUsuario.getClave());
		}
		
		
		List<BAMUsuariosBean> lista = consumirListaUsuarios(parameters);
		
		return lista;
	}
	
	
	private List<BAMUsuariosBean> consumirListaUsuarios(Map<String, String> parameters) {
		List<BAMUsuariosBean> respuestaFinal = new ArrayList<BAMUsuariosBean>();
		
		String URLBase = paramGeneralesDAO.consultaPrincipal(null, ParamGeneralesDAO.Enum_Con_ParamGenerales.RutaMicrofinWSBancas).getValorParametro();
		String urlServicio = URLBase + "/banking/users";
		String autentificacionCodificada = paramGeneralesDAO.consultaPrincipal(null, ParamGeneralesDAO.Enum_Con_ParamGenerales.AutentificacionWSBancas).getValorParametro();
		
		try{
			ConsumidorRest<UserListResponse> consumidorRest =  new ConsumidorRest<UserListResponse>();
			consumidorRest.addHeader("Autentificacion", autentificacionCodificada);
			consumidorRest.addHeader("originType", "C");
			loggerSAFI.info("Intentado realizar el consumo al WS.");
			loggerSAFI.info("url:{" + urlServicio + "}");
			loggerSAFI.info("request : " + new Gson().toJson(parameters));
		
			
			UserListResponse userListResponse =  consumidorRest.consumeGet(urlServicio, UserListResponse.class, parameters);
			
			if(!Constantes.STR_CODIGOEXITO[0].equals(userListResponse.getResponseCode())){
				loggerSAFI.info(this.getClass()+" - "+"Error al consultar el Web Service: " + userListResponse.getResponseCode() + " - " + userListResponse.getResponseMessage());
				throw new Exception(userListResponse.getResponseMessage());
			}
			
			if(Constantes.STR_CODIGOEXITO[0].equals(userListResponse.getResponseCode())){
				loggerSAFI.info(this.getClass()+" - "+"Respuesta del Web Service : " + userListResponse.getResponseCode() + " - " + userListResponse.getResponseMessage());
			}
			
			BAMUsuariosBean banUsuario = null;
			for(BanUsuarioRes banUsuarioRes : userListResponse.getUsersList()) {
				
				banUsuario = new BAMUsuariosBean();
				
				banUsuario.setUsuarioID(banUsuarioRes.getUserNumber());
				banUsuario.setClave(banUsuarioRes.getKeyUser());
				banUsuario.setClienteID(banUsuarioRes.getCustomerNumber());
				banUsuario.setContrasenia(banUsuarioRes.getPassword());
				banUsuario.setPrimerNombre(banUsuarioRes.getFirstName());
				banUsuario.setSegundoNombre(banUsuarioRes.getSecondName());
				banUsuario.setApellidoPaterno(banUsuarioRes.getSurname());
				banUsuario.setApellidoMaterno(banUsuarioRes.getSecondSurname());
				banUsuario.setNombreCompleto(banUsuarioRes.getFullName());
				banUsuario.setPerfilID(banUsuarioRes.getProfile());
				banUsuario.setEstatus(banUsuarioRes.getStatus());
				banUsuario.setFechaCreacion(banUsuarioRes.getCreatedDate());
				banUsuario.setEmail(banUsuarioRes.getEmail());
				banUsuario.setTelefono(banUsuarioRes.getPhone());
				banUsuario.setImgCliente(banUsuarioRes.getImagenAntiphi());
				banUsuario.setPreguntaSecretaID(banUsuarioRes.getSecretQuestionNumber());
				banUsuario.setRespuestaPregSecreta(banUsuarioRes.getSecretQuestionAnswer());
				banUsuario.setFraseBienvenida(banUsuarioRes.getWelcomePhrase());
				banUsuario.setImei(banUsuarioRes.getImei());
				banUsuario.setFechaUltimoAcceso(banUsuarioRes.getLastAccess());
				banUsuario.setLoginsFallidos(banUsuarioRes.getFailedsLogin());
				banUsuario.setEstatusSesion(banUsuarioRes.getStatusSession());
				banUsuario.setFechaCancel(banUsuarioRes.getCancelDate());
				banUsuario.setMotivoCancel(banUsuarioRes.getReasonCancel());
				banUsuario.setFechaBloqueo(banUsuarioRes.getBlockingDate());
				banUsuario.setMotivoBloqueo(banUsuarioRes.getBlockingReason());
				banUsuario.setServicioBancaMov(banUsuarioRes.getMobileBankingServ());
				banUsuario.setServicioBancaWeb(banUsuarioRes.getWebBankingServ());
				
				respuestaFinal.add(banUsuario);	
			}
			
		}catch(Exception e){
			respuestaFinal = new ArrayList<BAMUsuariosBean>();
		/*	loggerSAFI.info(this.getClass()+" - "+"Error en el proceso de consumo :" + e.getMessage());*/
			e.printStackTrace();
		}
		return respuestaFinal;
	}
	
	public MensajeTransaccionBean actualizarStatus(final BAMUsuariosBean usuario,final int tipoActualizacion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		
		
		String URLBase = paramGeneralesDAO.consultaPrincipal(null, ParamGeneralesDAO.Enum_Con_ParamGenerales.RutaMicrofinWSBancas).getValorParametro();
		String urlServicio = URLBase + "/banking/updateUserStatus";
		String autentificacionCodificada = paramGeneralesDAO.consultaPrincipal(null, ParamGeneralesDAO.Enum_Con_ParamGenerales.AutentificacionWSBancas).getValorParametro();
		
		try{
			ConsumidorRest<ActualizarUsuarioStatusResponse> consumidorRest =  new ConsumidorRest<ActualizarUsuarioStatusResponse>();
			consumidorRest.addHeader("Autentificacion", autentificacionCodificada);
			consumidorRest.addHeader("originType", "C");
			
			ActualizarUsuarioStatusRequest parameters = new ActualizarUsuarioStatusRequest();
			parameters.setCustomerNumber(usuario.getClienteID());
			parameters.setTypeOperation(Integer.toString(tipoActualizacion));
			 
			String motivoBloqCancel = usuario.getMotivoBloqueo() == null ? usuario.getMotivoCancel() == null ? Constantes.STRING_VACIO : usuario.getMotivoCancel() : usuario.getMotivoBloqueo();
			parameters.setReason(motivoBloqCancel);
			
			
			
			loggerSAFI.info("Intentado realizar el consumo al WS de cambio de status.");
			loggerSAFI.info("url:{" + urlServicio + "}");
			loggerSAFI.info("request : " + new Gson().toJson(parameters));
			
			ActualizarUsuarioStatusResponse usuarioStatusResponse =  consumidorRest.consumePost(urlServicio, parameters, ActualizarUsuarioStatusResponse.class);
			
			if(!Constantes.STR_CODIGOEXITO[0].equals(usuarioStatusResponse.getResponseCode())){
				loggerSAFI.info(this.getClass()+" - "+"Error al consultar el Web Service: " + usuarioStatusResponse.getResponseCode() + " - " + usuarioStatusResponse.getResponseMessage());
				throw new Exception(usuarioStatusResponse.getResponseMessage());
			}
			
			if(Constantes.STR_CODIGOEXITO[0].equals(usuarioStatusResponse.getResponseCode())){
				loggerSAFI.info(this.getClass()+" - "+"Respuesta del Web Service de lista de perfiles de usuarios de las bancas : " + usuarioStatusResponse.getResponseCode() + " - " + usuarioStatusResponse.getResponseMessage());
			}
			
			mensaje = new MensajeTransaccionBean();
			mensaje.setNumero(Utileria.convierteEntero(usuarioStatusResponse.getResponseCode()));
			mensaje.setDescripcion(usuarioStatusResponse.getResponseMessage());
			mensaje.setConsecutivoString(usuarioStatusResponse.getCustomerNumber());
			
		}catch(Exception e){
			mensaje = new MensajeTransaccionBean();
			mensaje.setDescripcion(e.getMessage());
			mensaje.setNumero(999);
			
			loggerSAFI.info(this.getClass()+" - "+"Error en el proceso de consumo :" + e.getMessage());
			e.printStackTrace();
		}
		
		return mensaje;
	}

	public MensajeTransaccionBean cambiarContrasenia(final BAMUsuariosBean usuario) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		
		String URLBase = paramGeneralesDAO.consultaPrincipal(null, ParamGeneralesDAO.Enum_Con_ParamGenerales.RutaMicrofinWSBancas).getValorParametro();
		String urlServicio = URLBase + "/banking/changePassword";
		String autentificacionCodificada = paramGeneralesDAO.consultaPrincipal(null, ParamGeneralesDAO.Enum_Con_ParamGenerales.AutentificacionWSBancas).getValorParametro();
		Gson gson = new Gson();
		
		try{
			ConsumidorRest<ChangePasswordBeanResponse> consumidorRest =  new ConsumidorRest<ChangePasswordBeanResponse>();
			consumidorRest.addHeader("Autentificacion", autentificacionCodificada);
			consumidorRest.addHeader("originType", "C");
			
			ChangePasswordBeanRequest request = new ChangePasswordBeanRequest();
			request.setCustomerNumber(usuario.getClienteID());
			request.setPreviousPassword(usuario.getContraseniaAnterior());
			request.setNewPassword(usuario.getNewPassword());
			
			loggerSAFI.info("Intentado realizar el consumo al WS de cambio de contrasenia.");
			loggerSAFI.info("url:{" + urlServicio + "}");
			loggerSAFI.info("request : " + gson.toJson(request));
			
			ChangePasswordBeanResponse changePasswordBeanResponse =  consumidorRest.consumePost(urlServicio, request, ChangePasswordBeanResponse.class);
			
			if(!Constantes.STR_CODIGOEXITO[0].equals(changePasswordBeanResponse.getResponseCode())){
				loggerSAFI.info(this.getClass()+" - "+"Error al consultar el Web Service: " + changePasswordBeanResponse.getResponseCode() + " - " + changePasswordBeanResponse.getResponseMessage());
				throw new Exception(changePasswordBeanResponse.getResponseMessage());
			}
			
			if(Constantes.STR_CODIGOEXITO[0].equals(changePasswordBeanResponse.getResponseCode())){
				loggerSAFI.info(this.getClass()+" - "+"Respuesta del Web Service de cambio de contrasenia : " + changePasswordBeanResponse.getResponseCode() + " - " + changePasswordBeanResponse.getResponseMessage());
			}
			
			mensaje = new MensajeTransaccionBean();
			mensaje.setNumero(Utileria.convierteEntero(changePasswordBeanResponse.getResponseCode()));
			mensaje.setDescripcion(changePasswordBeanResponse.getResponseMessage());
			mensaje.setConsecutivoString(changePasswordBeanResponse.getFolio());
			
		}catch(Exception e){
			mensaje = new MensajeTransaccionBean();
			mensaje.setDescripcion(e.getMessage());
			mensaje.setNumero(999);
			
			loggerSAFI.info(this.getClass()+" - "+"Error en el proceso de consumo :" + e.getMessage());
			e.printStackTrace();
		}
		
		return mensaje;
	}

	public ParametrosSesionBean getParametrosSesionBean() {
		return parametrosSesionBean;
	}

	public void setParametrosSesionBean(
			ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}

	public BAMBitacoraOperDAO getBitacoraDAO() {
		return bitacoraDAO;
	}

	public void setBitacoraDAO(BAMBitacoraOperDAO bitacoraDAO) {
		this.bitacoraDAO = bitacoraDAO;
	}

	public ParamGeneralesDAO getParamGeneralesDAO() {
		return paramGeneralesDAO;
	}

	public void setParamGeneralesDAO(ParamGeneralesDAO paramGeneralesDAO) {
		this.paramGeneralesDAO = paramGeneralesDAO;
	}
	
	
	
}
