package bancaMovil.dao;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

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

import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;

import com.google.gson.Gson;

import psl.rest.ConsumidorRest;

import soporte.dao.ParamGeneralesDAO;

import bancaMovil.bean.BAMImagenAntiphishingBean;

import bancaMovil.beanWS.response.AntiphishingImage;
import bancaMovil.beanWS.response.UpdateAntiphishingImagesResponse;
import bancaMovil.beanWS.request.UpdateAntiphishingImagesRequest;
import bancaMovil.beanWS.response.AntiphishingImagesResponse;
import bancaMovil.beanWS.response.RegisterAntiphishingImagesResponse;
import bancaMovil.beanWS.response.RegisterSecretQuestionResponse;
import bancaMovil.beanWS.request.RegisterAntiphishingImagesRequest;

public class BAMImagenAntiphishingDAO extends BaseDAO{
	
	ParametrosSesionBean parametrosSesionBean;
	private ParamGeneralesDAO paramGeneralesDAO;
	private final static String salidaPantalla = "S";
	
	public BAMImagenAntiphishingDAO() {
		super();
		// TODO Auto-generated constructor stub
	}

	public MensajeTransaccionBean altaImagenes(final BAMImagenAntiphishingBean imagen){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		
		String URLBase = paramGeneralesDAO.consultaPrincipal(null, ParamGeneralesDAO.Enum_Con_ParamGenerales.RutaMicrofinWSBancas).getValorParametro();
		String urlServicio = URLBase + "/support/registerAntiphishingImages";
		String autentificacionCodificada = paramGeneralesDAO.consultaPrincipal(null, ParamGeneralesDAO.Enum_Con_ParamGenerales.AutentificacionWSBancas).getValorParametro();
		
		try{
			ConsumidorRest<RegisterAntiphishingImagesResponse> consumidorRest =  new ConsumidorRest<RegisterAntiphishingImagesResponse>();
			consumidorRest.addHeader("Autentificacion", autentificacionCodificada);
			
			RegisterAntiphishingImagesRequest parameters = new RegisterAntiphishingImagesRequest();
			parameters.setOrigin("C");
			parameters.setBinaryImage(imagen.getImagenBinaria());
			parameters.setDescription(imagen.getDescripcion());
			parameters.setStatus(imagen.getEstatus());
			loggerSAFI.info("Intentado realizar el consumo al WS de registro de Imagen Antiphishing  de las bancas.");
			loggerSAFI.info("url:{" + urlServicio + "}");
			loggerSAFI.info("request : " + new Gson().toJson(parameters));
			
			RegisterAntiphishingImagesResponse registerAntiphishingImagesResponse =  consumidorRest.consumePost(urlServicio, parameters, RegisterAntiphishingImagesResponse.class);
			
			if(!Constantes.STR_CODIGOEXITO[0].equals(registerAntiphishingImagesResponse.getResponseCode())){
				loggerSAFI.info(this.getClass()+" - "+"Error al consultar el Web Service de registro de Imagen Antiphishing " + registerAntiphishingImagesResponse.getResponseCode() + " - " + registerAntiphishingImagesResponse.getResponseMessage());
				throw new Exception(registerAntiphishingImagesResponse.getResponseMessage());
			}
			
			if(Constantes.STR_CODIGOEXITO[0].equals(registerAntiphishingImagesResponse.getResponseCode())){
				loggerSAFI.info(this.getClass()+" - "+"Respuesta del Web Service de Registro de Imagen Antiphishing de las bancas : " + registerAntiphishingImagesResponse.getResponseCode() + " - " + registerAntiphishingImagesResponse.getResponseMessage());
			}
			
			mensaje = new MensajeTransaccionBean();
			mensaje.setNumero(Utileria.convierteEntero(registerAntiphishingImagesResponse.getResponseCode()));
			mensaje.setDescripcion(registerAntiphishingImagesResponse.getResponseMessage());
			
		}catch(Exception e){
			mensaje = new MensajeTransaccionBean();
			mensaje.setDescripcion(e.getMessage());
			mensaje.setNumero(999);
			
			loggerSAFI.info(this.getClass()+" - "+"Error en el proceso de consumo :" + e.getMessage());
			e.printStackTrace();
		}
		return mensaje;
	}
	
	
	public MensajeTransaccionBean bajaImagenes(final int imagenID){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		
		String URLBase = paramGeneralesDAO.consultaPrincipal(null, ParamGeneralesDAO.Enum_Con_ParamGenerales.RutaMicrofinWSBancas).getValorParametro();
		String urlServicio = URLBase + "/support/updateAntiphishingImages";
		
		String autentificacionCodificada = paramGeneralesDAO.consultaPrincipal(null, ParamGeneralesDAO.Enum_Con_ParamGenerales.AutentificacionWSBancas).getValorParametro();
		
		try{
			ConsumidorRest<UpdateAntiphishingImagesResponse> consumidorRest =  new ConsumidorRest<UpdateAntiphishingImagesResponse>();
			consumidorRest.addHeader("Autentificacion", autentificacionCodificada);
			
			UpdateAntiphishingImagesRequest parameters = new UpdateAntiphishingImagesRequest();
			parameters.setOrigin("C");
			parameters.setAntiphishingImageNumber(String.valueOf(imagenID));
			
			loggerSAFI.info("Intentado realizar el consumo al WS de baja de Imagen Antiphishing  de las bancas.");
			loggerSAFI.info("url:{" + urlServicio + "}");
			loggerSAFI.info("request : " + new Gson().toJson(parameters));
			
			UpdateAntiphishingImagesResponse updateAntiphishingImagesResponse =  consumidorRest.consumePost(urlServicio, parameters, UpdateAntiphishingImagesResponse.class);
			
			if(!Constantes.STR_CODIGOEXITO[0].equals(updateAntiphishingImagesResponse.getResponseCode())){
				loggerSAFI.info(this.getClass()+" - "+"Error al consultar el Web Service de baja de Imagen Antiphishing " + updateAntiphishingImagesResponse.getResponseCode() + " - " + updateAntiphishingImagesResponse.getResponseMessage());
				throw new Exception(updateAntiphishingImagesResponse.getResponseMessage());
			}
			
			if(Constantes.STR_CODIGOEXITO[0].equals(updateAntiphishingImagesResponse.getResponseCode())){
				loggerSAFI.info(this.getClass()+" - "+"Respuesta del Web Service de baja de Imagen Antiphishing de las bancas : " + updateAntiphishingImagesResponse.getResponseCode() + " - " + updateAntiphishingImagesResponse.getResponseMessage());
			}
			
			mensaje = new MensajeTransaccionBean();
			mensaje.setNumero(Utileria.convierteEntero(updateAntiphishingImagesResponse.getResponseCode()));
			mensaje.setDescripcion(updateAntiphishingImagesResponse.getResponseMessage());
			
		}catch(Exception e){
			mensaje = new MensajeTransaccionBean();
			mensaje.setDescripcion(e.getMessage());
			mensaje.setNumero(999);
			
			loggerSAFI.info(this.getClass()+" - "+"Error en el proceso de consumo :" + e.getMessage());
			e.printStackTrace();
		}
		return mensaje;
	}
	
	public List<?> listaPrincipal(BAMImagenAntiphishingBean imagenBean, int tipoLista) {

		Map<String, String> parameters = new HashMap<String, String>();
		parameters.put("origin", "C");
		List<BAMImagenAntiphishingBean> antiphishingBeans = consumirListaImagenes(parameters);

		return antiphishingBeans;
	}
	
	
	private List<BAMImagenAntiphishingBean> consumirListaImagenes(Map<String, String> parameters) {
		List<BAMImagenAntiphishingBean> respuestaFinal = new ArrayList<BAMImagenAntiphishingBean>();
		
		String URLBase = paramGeneralesDAO.consultaPrincipal(null, ParamGeneralesDAO.Enum_Con_ParamGenerales.RutaMicrofinWSBancas).getValorParametro();
		String urlServicio = URLBase + "/support/antiphishingImages";
		String autentificacionCodificada = paramGeneralesDAO.consultaPrincipal(null, ParamGeneralesDAO.Enum_Con_ParamGenerales.AutentificacionWSBancas).getValorParametro();
		
		try{
			ConsumidorRest<AntiphishingImagesResponse> consumidorRest =  new ConsumidorRest<AntiphishingImagesResponse>();
			consumidorRest.addHeader("Autentificacion", autentificacionCodificada);
			consumidorRest.addHeader("originType", "C");
			loggerSAFI.info("Intentado realizar el consumo al WS.");
			loggerSAFI.info("url:{" + urlServicio + "}");
			loggerSAFI.info("request : " + new Gson().toJson(parameters));
			
			AntiphishingImagesResponse antiphishingImagesResponse =  consumidorRest.consumeGet(urlServicio, AntiphishingImagesResponse.class, parameters);
			
			if(!Constantes.STR_CODIGOEXITO[0].equals(antiphishingImagesResponse.getResponseCode())){
				loggerSAFI.info(this.getClass()+" - "+"Error al consultar el Web Service: " + antiphishingImagesResponse.getResponseCode() + " - " + antiphishingImagesResponse.getResponseMessage());
				throw new Exception(antiphishingImagesResponse.getResponseMessage());
			}
			
			if(Constantes.STR_CODIGOEXITO[0].equals(antiphishingImagesResponse.getResponseCode())){
				loggerSAFI.info(this.getClass()+" - "+"Respuesta del Web Service : " + antiphishingImagesResponse.getResponseCode() + " - " + antiphishingImagesResponse.getResponseMessage());
			}
			
			BAMImagenAntiphishingBean bamImagenAntiphishingBean = null;
			for(AntiphishingImage antiphishingImage : antiphishingImagesResponse.getListAntiphishingImage()) {
				
				bamImagenAntiphishingBean= new BAMImagenAntiphishingBean();			
				bamImagenAntiphishingBean.setDescripcion(antiphishingImage.getDescription());
				bamImagenAntiphishingBean.setEstatus(antiphishingImage.getStatus());
				bamImagenAntiphishingBean.setImagenBinaria(antiphishingImage.getBinaryImage());
				bamImagenAntiphishingBean.setImagenAntiphishingID(antiphishingImage.getAntiphishingImageNumber());
				
				respuestaFinal.add(bamImagenAntiphishingBean);	
			}
			
		}catch(Exception e){
			respuestaFinal = new ArrayList<BAMImagenAntiphishingBean>();
			loggerSAFI.info(this.getClass()+" - "+"Error en el proceso de consumo :" + e.getMessage());
			e.printStackTrace();
		}
		return respuestaFinal;
	}
	

	/* Consuta Imagen por Llave Principal*/
	public BAMImagenAntiphishingBean consultaPrincipal(int imagenID, int tipoConsulta) {
		BAMImagenAntiphishingBean imagenAntiphishingBean = null;
		
		Map<String, String> parameters = new HashMap<String, String>();
		parameters.put("origin", "C");
		parameters.put("antiphishingImageNumber", String.valueOf(imagenID));
		
		List<BAMImagenAntiphishingBean> lista = consumirListaImagenes(parameters);
		
		if(lista.isEmpty()) {
			return null;
		}
		
		for (int i = 0; i < lista.size(); i++) {
			if(lista.get(i).getImagenAntiphishingID().equals(String.valueOf(imagenID))){
				return imagenAntiphishingBean = lista.get(i);
			}
			imagenAntiphishingBean = lista.get(0);
		}
		
		
		return imagenAntiphishingBean;
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
