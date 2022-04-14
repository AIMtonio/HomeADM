package bancaMovil.dao;


import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.google.gson.Gson;

import bancaMovil.bean.BAMPregutaSecretaBean;
import bancaMovil.beanWS.request.ModifySecretQuestionRequest;
import bancaMovil.beanWS.request.RegisterSecretQuestionRequest;
import bancaMovil.beanWS.response.ModifySecretQuestionResponse;
import bancaMovil.beanWS.response.RegisterSecretQuestionResponse;
import bancaMovil.beanWS.response.SecretQuestion;
import bancaMovil.beanWS.response.SecretQuestionsResponse;
import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;
import psl.rest.ConsumidorRest;
import soporte.dao.ParamGeneralesDAO;

public class BAMPreguntaSecretaDAO extends BaseDAO{

	ParametrosSesionBean parametrosSesionBean;
	private ParamGeneralesDAO paramGeneralesDAO;

	public BAMPreguntaSecretaDAO() {
		super();
	}

	/* Alta del pregunta */
	
	public MensajeTransaccionBean altaPregunta(final BAMPregutaSecretaBean pregunta){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		
		String URLBase = paramGeneralesDAO.consultaPrincipal(null, ParamGeneralesDAO.Enum_Con_ParamGenerales.RutaMicrofinWSBancas).getValorParametro();
		String urlServicio = URLBase + "/support/registerSecretQuestion";
		String autentificacionCodificada = paramGeneralesDAO.consultaPrincipal(null, ParamGeneralesDAO.Enum_Con_ParamGenerales.AutentificacionWSBancas).getValorParametro();
		
		try{
			ConsumidorRest<RegisterSecretQuestionResponse> consumidorRest =  new ConsumidorRest<RegisterSecretQuestionResponse>();
			consumidorRest.addHeader("Autentificacion", autentificacionCodificada);
			consumidorRest.addHeader("originType", "C");
			
			RegisterSecretQuestionRequest parameters = new RegisterSecretQuestionRequest();
			parameters.setDrafting(pregunta.getRedaccion());
			
			loggerSAFI.info("Intentado realizar el consumo al WS de registro de pregunta secreta de usuarios de las bancas.");
			loggerSAFI.info("url:{" + urlServicio + "}");
			loggerSAFI.info("request : " + new Gson().toJson(parameters));
			
			RegisterSecretQuestionResponse registerSecretQuestionResponse =  consumidorRest.consumePost(urlServicio, parameters, RegisterSecretQuestionResponse.class);
			
			if(!Constantes.STR_CODIGOEXITO[0].equals(registerSecretQuestionResponse.getResponseCode())){
				loggerSAFI.info(this.getClass()+" - "+"Error al consultar el Web Service de registro de pregunta secreta: " + registerSecretQuestionResponse.getResponseCode() + " - " + registerSecretQuestionResponse.getResponseMessage());
				throw new Exception(registerSecretQuestionResponse.getResponseMessage());
			}
			
			if(Constantes.STR_CODIGOEXITO[0].equals(registerSecretQuestionResponse.getResponseCode())){
				loggerSAFI.info(this.getClass()+" - "+"Respuesta del Web Service de Registro pregunta secreta de las bancas : " + registerSecretQuestionResponse.getResponseCode() + " - " + registerSecretQuestionResponse.getResponseMessage());
			}
			
			mensaje = new MensajeTransaccionBean();
			mensaje.setNumero(Utileria.convierteEntero(registerSecretQuestionResponse.getResponseCode()));
			mensaje.setDescripcion(registerSecretQuestionResponse.getResponseMessage());
			mensaje.setConsecutivoString(registerSecretQuestionResponse.getNumberSecretQuestion());
			
		}catch(Exception e){
			mensaje = new MensajeTransaccionBean();
			mensaje.setDescripcion(e.getMessage());
			mensaje.setNumero(999);
			
			loggerSAFI.info(this.getClass()+" - "+"Error en el proceso de consumo :" + e.getMessage());
			e.printStackTrace();
		}
		return mensaje;
	}
	
	public MensajeTransaccionBean modificaPregunta(final BAMPregutaSecretaBean pregunta){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		
		String URLBase = paramGeneralesDAO.consultaPrincipal(null, ParamGeneralesDAO.Enum_Con_ParamGenerales.RutaMicrofinWSBancas).getValorParametro();
		String urlServicio = URLBase + "/support/modifySecretQuestion";
		String autentificacionCodificada = paramGeneralesDAO.consultaPrincipal(null, ParamGeneralesDAO.Enum_Con_ParamGenerales.AutentificacionWSBancas).getValorParametro();
		
		try{
			ConsumidorRest<ModifySecretQuestionResponse> consumidorRest =  new ConsumidorRest<ModifySecretQuestionResponse>();
			consumidorRest.addHeader("Autentificacion", autentificacionCodificada);
			consumidorRest.addHeader("originType", "C");
			ModifySecretQuestionRequest parameters = new ModifySecretQuestionRequest();
			parameters.setSecretQuestionNumber(pregunta.getPreguntaSecretaID());
			parameters.setDrafting(pregunta.getRedaccion());
			
			loggerSAFI.info("Intentado realizar el consumo al WS de modificar pregunta secreta  de usuarios de las bancas.");
			loggerSAFI.info("url:{" + urlServicio + "}");
			loggerSAFI.info("request : " + new Gson().toJson(parameters));
			
			ModifySecretQuestionResponse modifySecretQuestionResponse =  consumidorRest.consumePost(urlServicio, parameters, ModifySecretQuestionResponse.class);
			
			if(!Constantes.STR_CODIGOEXITO[0].equals(modifySecretQuestionResponse.getResponseCode())){
				loggerSAFI.info(this.getClass()+" - "+"Error al consultar el Web Service de modificar pregunta secreta: " + modifySecretQuestionResponse.getResponseCode() + " - " + modifySecretQuestionResponse.getResponseMessage());
				throw new Exception(modifySecretQuestionResponse.getResponseMessage());
			}
			
			if(Constantes.STR_CODIGOEXITO[0].equals(modifySecretQuestionResponse.getResponseCode())){
				loggerSAFI.info(this.getClass()+" - "+"Respuesta del Web Service de lista de perfiles de usuarios de las bancas : " + modifySecretQuestionResponse.getResponseCode() + " - " + modifySecretQuestionResponse.getResponseMessage());
			}
			
			mensaje = new MensajeTransaccionBean();
			mensaje.setNumero(Utileria.convierteEntero(modifySecretQuestionResponse.getResponseCode()));
			mensaje.setDescripcion(modifySecretQuestionResponse.getResponseMessage());
			mensaje.setConsecutivoString(modifySecretQuestionResponse.getNumberSecretQuestion());
			
		}catch(Exception e){
			mensaje = new MensajeTransaccionBean();
			mensaje.setDescripcion(e.getMessage());
			mensaje.setNumero(999);
			
			loggerSAFI.info(this.getClass()+" - "+"Error en el proceso de consumo :" + e.getMessage());
			e.printStackTrace();
		}
		return mensaje;
	}
	public List<BAMPregutaSecretaBean> listaPrincipal(BAMPregutaSecretaBean preguntaSecretaBean) {

		Map<String, String> parameters = new HashMap<String, String>();
		parameters.put("drafting", preguntaSecretaBean.getRedaccion());
		
		List<BAMPregutaSecretaBean> lista = consumirListaPregSecreta(parameters);
		
		return lista;
	}

	public BAMPregutaSecretaBean consultaPrincipal(int perfilID) {
		BAMPregutaSecretaBean preguntaSecretaBean = null;
		
		Map<String, String> parameters = new HashMap<String, String>();
		parameters.put("secretQuestionNumber", String.valueOf(perfilID));
		
		List<BAMPregutaSecretaBean> lista = consumirListaPregSecreta(parameters);
		
		if(lista.isEmpty()) {
			return null;
		}
		
		preguntaSecretaBean = lista.get(0);
		
		return preguntaSecretaBean;
	}

	private List<BAMPregutaSecretaBean> consumirListaPregSecreta(Map<String, String> parameters) {
		List<BAMPregutaSecretaBean> respuestaFinal = new ArrayList<BAMPregutaSecretaBean>();
		
		String URLBase = paramGeneralesDAO.consultaPrincipal(null, ParamGeneralesDAO.Enum_Con_ParamGenerales.RutaMicrofinWSBancas).getValorParametro();
		String urlServicio = URLBase + "/support/secretQuestions";

		String autentificacionCodificada = paramGeneralesDAO.consultaPrincipal(null, ParamGeneralesDAO.Enum_Con_ParamGenerales.AutentificacionWSBancas).getValorParametro();
		
		try{
			ConsumidorRest<SecretQuestionsResponse> consumidorRest =  new ConsumidorRest<SecretQuestionsResponse>();
			consumidorRest.addHeader("Autentificacion", autentificacionCodificada);
			consumidorRest.addHeader("originType", "C");
			
			loggerSAFI.info("Intentado realizar el consumo al WS de lista de pregunta secreta de usuarios de las bancas.");
			loggerSAFI.info("url:{" + urlServicio + "}");
			loggerSAFI.info("request : " + new Gson().toJson(parameters));
			
			SecretQuestionsResponse secretQuestionsResponse =  consumidorRest.consumeGet(urlServicio, SecretQuestionsResponse.class, parameters);
			
			if(!Constantes.STR_CODIGOEXITO[0].equals(secretQuestionsResponse.getResponseCode())){
				loggerSAFI.info(this.getClass()+" - "+"Error al consultar el Web Service de lista de pregunta secreta: " + secretQuestionsResponse.getResponseCode() + " - " + secretQuestionsResponse.getResponseMessage());
				throw new Exception(secretQuestionsResponse.getResponseMessage());
			}
			
			if(Constantes.STR_CODIGOEXITO[0].equals(secretQuestionsResponse.getResponseCode())){
				loggerSAFI.info(this.getClass()+" - "+"Respuesta del Web Service de lista de pregunta secreta de las bancas : " + secretQuestionsResponse.getResponseCode() + " - " + secretQuestionsResponse.getResponseMessage());
			}
			
			BAMPregutaSecretaBean bamPregutaSecreta = null;
			for(SecretQuestion pregunta : secretQuestionsResponse.getListSecretQuestions()) {
				
				bamPregutaSecreta = new BAMPregutaSecretaBean();
				
				bamPregutaSecreta.setPreguntaSecretaID(pregunta.getSecretQuestionNumber());
				bamPregutaSecreta.setRedaccion(pregunta.getDrafting());
				
				respuestaFinal.add(bamPregutaSecreta);	
			}
			
		}catch(Exception e){
			respuestaFinal = new ArrayList<BAMPregutaSecretaBean>();
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

