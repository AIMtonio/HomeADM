package bancaMovil.dao;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.google.gson.Gson;

import bancaMovil.bean.BAMPerfilBean;
import bancaMovil.beanWS.request.ModifyProfileRequest;
import bancaMovil.beanWS.request.RegisterProfileRequest;
import bancaMovil.beanWS.response.ModifyProfileResponse;
import bancaMovil.beanWS.response.Perfil;
import bancaMovil.beanWS.response.ProfilesResponse;
import bancaMovil.beanWS.response.RegisterProfileResponse;
import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;
import psl.rest.ConsumidorRest;
import soporte.dao.ParamGeneralesDAO;

public class BAMPerfilDAO extends BaseDAO{

	private ParamGeneralesDAO paramGeneralesDAO;
	
	public BAMPerfilDAO() {
		super();
	}

	ParametrosSesionBean parametrosSesionBean;

	/**
	 * Metodo que realiza el consumo de WS de registro de perfiles de usuarios de las bancaas.
	 * @param perfil
	 * @return
	 */
	public MensajeTransaccionBean altaPerfil(final BAMPerfilBean perfil) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		
		String URLBase = paramGeneralesDAO.consultaPrincipal(null, ParamGeneralesDAO.Enum_Con_ParamGenerales.RutaMicrofinWSBancas).getValorParametro();
		String urlServicio = URLBase + "/banking/registerProfile";
		String autentificacionCodificada = paramGeneralesDAO.consultaPrincipal(null, ParamGeneralesDAO.Enum_Con_ParamGenerales.AutentificacionWSBancas).getValorParametro();
		
		try{
			ConsumidorRest<RegisterProfileResponse> consumidorRest =  new ConsumidorRest<RegisterProfileResponse>();
			consumidorRest.addHeader("Autentificacion", autentificacionCodificada);
			
			RegisterProfileRequest parameters = new RegisterProfileRequest();
			parameters.setDescription(perfil.getDescripcion());
			parameters.setRolName(perfil.getNombrePerfil());
			
			loggerSAFI.info("Intentado realizar el consumo al WS de registro de perfiles de usuarios de las bancas.");
			loggerSAFI.info("url:{" + urlServicio + "}");
			loggerSAFI.info("request : " + new Gson().toJson(parameters));
			
			RegisterProfileResponse registerProfileResponse =  consumidorRest.consumePost(urlServicio, parameters, RegisterProfileResponse.class);
			
			if(!Constantes.STR_CODIGOEXITO[0].equals(registerProfileResponse.getResponseCode())){
				loggerSAFI.info(this.getClass()+" - "+"Error al consultar el Web Service de registro de perfiles: " + registerProfileResponse.getResponseCode() + " - " + registerProfileResponse.getResponseMessage());
				throw new Exception(registerProfileResponse.getResponseMessage());
			}
			
			if(Constantes.STR_CODIGOEXITO[0].equals(registerProfileResponse.getResponseCode())){
				loggerSAFI.info(this.getClass()+" - "+"Respuesta del Web Service de lista de perfiles de usuarios de las bancas : " + registerProfileResponse.getResponseCode() + " - " + registerProfileResponse.getResponseMessage());
			}
			
			mensaje = new MensajeTransaccionBean();
			mensaje.setNumero(Utileria.convierteEntero(registerProfileResponse.getResponseCode()));
			mensaje.setDescripcion(registerProfileResponse.getResponseMessage());
			mensaje.setConsecutivoInt(registerProfileResponse.getProfileNumber());
			mensaje.setConsecutivoString(registerProfileResponse.getProfileNumber());
			
		}catch(Exception e){
			mensaje = new MensajeTransaccionBean();
			mensaje.setDescripcion(e.getMessage());
			mensaje.setNumero(999);
			
			loggerSAFI.info(this.getClass()+" - "+"Error en el proceso de consumo :" + e.getMessage());
			e.printStackTrace();
		}
		return mensaje;
	}


	/**
	 * Metodo que realiza el consumo de WS de modificar los perfiles de usuarios de las bancas.
	 * @param perfil
	 * @return
	 */
	public MensajeTransaccionBean modificaPerfil(final BAMPerfilBean perfil) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		
		String URLBase = paramGeneralesDAO.consultaPrincipal(null, ParamGeneralesDAO.Enum_Con_ParamGenerales.RutaMicrofinWSBancas).getValorParametro();
		String urlServicio = URLBase + "/banking/modifyProfile";
		String autentificacionCodificada = paramGeneralesDAO.consultaPrincipal(null, ParamGeneralesDAO.Enum_Con_ParamGenerales.AutentificacionWSBancas).getValorParametro();
		
		try{
			ConsumidorRest<ModifyProfileResponse> consumidorRest =  new ConsumidorRest<ModifyProfileResponse>();
			consumidorRest.addHeader("Autentificacion", autentificacionCodificada);
			
			ModifyProfileRequest parameters = new ModifyProfileRequest();
			
			parameters.setProfileNumber(perfil.getPerfilID());
			parameters.setDescription(perfil.getDescripcion());
			parameters.setRolName(perfil.getNombrePerfil());
			
			loggerSAFI.info("Intentado realizar el consumo al WS de registro de perfiles de usuarios de las bancas.");
			loggerSAFI.info("url:{" + urlServicio + "}");
			loggerSAFI.info("request : " + new Gson().toJson(parameters));
			
			ModifyProfileResponse modifyProfileResponse =  consumidorRest.consumePost(urlServicio, parameters, ModifyProfileResponse.class);
			
			if(!Constantes.STR_CODIGOEXITO[0].equals(modifyProfileResponse.getResponseCode())){
				loggerSAFI.info(this.getClass()+" - "+"Error al consultar el Web Service de registro de perfiles: " + modifyProfileResponse.getResponseCode() + " - " + modifyProfileResponse.getResponseMessage());
				throw new Exception(modifyProfileResponse.getResponseMessage());
			}
			
			if(Constantes.STR_CODIGOEXITO[0].equals(modifyProfileResponse.getResponseCode())){
				loggerSAFI.info(this.getClass()+" - "+"Respuesta del Web Service de lista de perfiles de usuarios de las bancas : " + modifyProfileResponse.getResponseCode() + " - " + modifyProfileResponse.getResponseMessage());
			}
			
			mensaje = new MensajeTransaccionBean();
			mensaje.setNumero(Utileria.convierteEntero(modifyProfileResponse.getResponseCode()));
			mensaje.setDescripcion(modifyProfileResponse.getResponseMessage());
			mensaje.setConsecutivoInt(modifyProfileResponse.getProfileNumber());
			mensaje.setConsecutivoString(modifyProfileResponse.getProfileNumber());
			
		}catch(Exception e){
			mensaje = new MensajeTransaccionBean();
			mensaje.setDescripcion(e.getMessage());
			mensaje.setNumero(999);
			
			loggerSAFI.info(this.getClass()+" - "+"Error en el proceso de consumo :" + e.getMessage());
			e.printStackTrace();
		}
		return mensaje;
	}

	/**
	 * Metodo que retorna la lista de perfiles de usuarios.
	 * @param perfilBean -> {@link BAMPerfilBean}
	 * @return {@link List}
	 */
	public List<BAMPerfilBean> listaPrincipal(BAMPerfilBean perfilBean) {

		Map<String, String> parameters = new HashMap<String, String>();
		parameters.put("description", perfilBean.getPerfilID());
		
		List<BAMPerfilBean> lista = consumirListaPerfiles(parameters);
		
		return lista;
	}


	/**
	 * Metodo que realiza el consumo de WS de lista de perfiles de usuarios de las bancas y que retorna un uno registro simulando una consulta.
	 * @param perfilID -> int
	 * @return {@link BAMPerfilBean}
	 */
	public BAMPerfilBean consultaPrincipal(int perfilID) {
		BAMPerfilBean perfilBean = null;
		
		Map<String, String> parameters = new HashMap<String, String>();
		parameters.put("profileNumber", String.valueOf(perfilID));
		
		List<BAMPerfilBean> lista = consumirListaPerfiles(parameters);
		
		if(lista.isEmpty()) {
			return null;
		}
		
		perfilBean = lista.get(0);
		
		return perfilBean;
	}	

	public ParametrosSesionBean getParametrosSesionBean() {
		return parametrosSesionBean;
	}

	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}
	
	
	/**
	 * Metodo que realiza el consumo de ws de lista de perfiles de usuarios de las bancas.
	 * @param parameters
	 * @return
	 */
	private List<BAMPerfilBean> consumirListaPerfiles(Map<String, String> parameters) {
		List<BAMPerfilBean> respuestaFinal = new ArrayList<BAMPerfilBean>();
		
		String URLBase = paramGeneralesDAO.consultaPrincipal(null, ParamGeneralesDAO.Enum_Con_ParamGenerales.RutaMicrofinWSBancas).getValorParametro();
		String urlServicio = URLBase + "/banking/profiles";
		String autentificacionCodificada = paramGeneralesDAO.consultaPrincipal(null, ParamGeneralesDAO.Enum_Con_ParamGenerales.AutentificacionWSBancas).getValorParametro();
		
		try{
			ConsumidorRest<ProfilesResponse> consumidorRest =  new ConsumidorRest<ProfilesResponse>();
			consumidorRest.addHeader("Autentificacion", autentificacionCodificada);
			
			loggerSAFI.info("Intentado realizar el consumo al WS de lista de perfiles de usuarios de las bancas.");
			loggerSAFI.info("url:{" + urlServicio + "}");
			loggerSAFI.info("request : " + new Gson().toJson(parameters));
			
			ProfilesResponse profilesResponse =  consumidorRest.consumeGet(urlServicio, ProfilesResponse.class, parameters);
			
			if(!Constantes.STR_CODIGOEXITO[0].equals(profilesResponse.getResponseCode())){
				loggerSAFI.info(this.getClass()+" - "+"Error al consultar el Web Service de lista de perfiles: " + profilesResponse.getResponseCode() + " - " + profilesResponse.getResponseMessage());
				throw new Exception(profilesResponse.getResponseMessage());
			}
			
			if(Constantes.STR_CODIGOEXITO[0].equals(profilesResponse.getResponseCode())){
				loggerSAFI.info(this.getClass()+" - "+"Respuesta del Web Service de lista de perfiles de usuarios de las bancas : " + profilesResponse.getResponseCode() + " - " + profilesResponse.getResponseMessage());
			}
			
			BAMPerfilBean bamPerfilBean = null;
			for(Perfil perfil : profilesResponse.getListProfiles()) {
				
				bamPerfilBean = new BAMPerfilBean();
				
				bamPerfilBean.setPerfilID(perfil.getProfileNumber());
				bamPerfilBean.setDescripcion(perfil.getDescription());
				bamPerfilBean.setNombrePerfil(perfil.getRoleName());
				
				respuestaFinal.add(bamPerfilBean);	
			}
			
		}catch(Exception e){
			respuestaFinal = new ArrayList<BAMPerfilBean>();
			loggerSAFI.info(this.getClass()+" - "+"Error en el proceso de consumo :" + e.getMessage());
			e.printStackTrace();
		}
		return respuestaFinal;
	}


	public ParamGeneralesDAO getParamGeneralesDAO() {
		return paramGeneralesDAO;
	}


	public void setParamGeneralesDAO(ParamGeneralesDAO paramGeneralesDAO) {
		this.paramGeneralesDAO = paramGeneralesDAO;
	}
	
	


}
