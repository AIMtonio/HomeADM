package soporte.serviciosrest;

import herramientas.Constantes;
import herramientas.Utileria;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.SocketTimeoutException;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;

import org.apache.http.Header;
import org.apache.http.HttpResponse;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.log4j.Logger;
import org.springframework.http.HttpHeaders;


public class ConexionWSRest {

	protected final Logger loggerSAFI = Logger.getLogger("SAFI");
	protected final Logger loggerVent = Logger.getLogger("Vent");
	protected final Logger loggerISOTRX = Logger.getLogger("ISOTRX");

	private String urlServicio = null;
	private String userWS = "Authorization";
	private String passWS = null;
	private List<Header> headers;
	private HttpPost postRequest;
	private HttpGet getRequest;
	private Header header;
	private String paramRequest;
	private String mensaje;

	public static interface Enum_Exception {
		int SocketTimeoutException 	= 1;
		int ClientProtocolException	= 2;
		int IOException				= 3;
		int Exception				= 4;
	}
	
	public static interface Enum_MensajeError {
		String mensajeTimeOut 	= "Fallo de petición por Tiempo de Espera Prolongado.";
		String mensajeProtocolo = "Fallo de petición por Error en Protocolos.";
		String mensajeLectura 	= "Fallo de petición por Error en Información.";
	}
	
	public static interface Mensajes {
		String Inicio 			= "Iniciando Consumo de Web Service...";
		String Final  			= "Finalizando Consumo de Web Service...";
		String ErrorTimeOut		= "Web Service REST: Error de TimeOut, Servicio: ";
		String ErrorProtocolo 	= "Web Service REST: Error de Protocolo, Servicio: ";
		String ErrorLectura 	= "Web Service REST: Error de Lectura, Servicio: ";
		String ErrorServicio 	= "Web Service REST: Error de Servicio: ";
	}
	
	public ConexionWSRest(String urlServicio) {
		this.urlServicio = urlServicio;
		postRequest = new HttpPost(this.urlServicio);	
		getRequest = new HttpGet(this.urlServicio);	
	}
	
	
	public void addHeader(String headerName, String headerValue) {
		postRequest.addHeader(headerName, headerValue);
		getRequest.addHeader(headerName, headerValue);
	}
	
	public Object peticionPOST(Object parametros, Class tipoResponse, final String tiempoEspera, final int logImpresion){

		paramRequest = Utileria.imprimeObjeto(parametros);

		mensaje = "Petición POST ---> [ URL Servicio: " +this.urlServicio+ " ] "+ "Request: "+ Utileria.logJsonFormat(parametros);
		switch(logImpresion){
			case Constantes.logger.SAFI:
				loggerSAFI.info(mensaje);
				loggerSAFI.info(Mensajes.Inicio);
			break;
			case Constantes.logger.Vent:
				loggerVent.info(mensaje);
				loggerVent.info(Mensajes.Inicio);
			break;
			case Constantes.logger.ISOTRX:
				loggerISOTRX.info(mensaje);
				loggerISOTRX.info(Mensajes.Inicio);
			break;
			default:
				loggerSAFI.info(mensaje);
				loggerSAFI.info(Mensajes.Inicio);
			break;
		}

		String respuestaPost = "";

		try {
			
			CloseableHttpClient httpClient=null;			

			// Asignacion de Parametros formato json 
			StringEntity input = new StringEntity(paramRequest,"UTF-8");	
			input.setContentType("application/json");				
			postRequest.setEntity(input);	
			
			// Crear la llamada al servidor
			httpClient = HttpClients.custom().setDefaultRequestConfig(Utileria.requestConfiguration(tiempoEspera)).build();
			
			// Tratar respuesta del servidor
			HttpResponse response;	
			
			response = httpClient.execute(postRequest);
			
			if (response.getStatusLine().getStatusCode() != 200) {
				if(response.getStatusLine().getStatusCode() != 201){
					if(response.getStatusLine().getStatusCode() != 500){
						throw new RuntimeException("Error : Codigo de error HTTP : "+ response.getStatusLine().getStatusCode());
					}
				}
			}
			
			BufferedReader br = new BufferedReader( new InputStreamReader((response.getEntity().getContent())));
			String output;
			while ((output = br.readLine()) != null) {
				respuestaPost+=output;
			}
			
			httpClient.close();
			
			// Bloque de Error
			// Si la respuesta falla por un timeout, por protocolo erroneo, por error de datos(IOException) o fallo general
			// retorno la propiedad Exception con un Código la cual se evalua en la case que invoque la función peticionPOST
			// de ser requerido pueden agregarse mas excepciones con un codigo especifico
		} catch (SocketTimeoutException socketTimeoutException){
			socketTimeoutException.printStackTrace();
			respuestaPost = "{\"Exception\":\"1\"}";
			mensaje = Mensajes.ErrorTimeOut +"[ URL Servicio: " +this.urlServicio+ " ] "+ "Parámetros: "+ Utileria.logJsonFormat(parametros)+ " - " + socketTimeoutException;
			switch(logImpresion){
				case Constantes.logger.SAFI:
					loggerSAFI.info(mensaje);
				break;
				case Constantes.logger.Vent:
					loggerVent.info(mensaje);
				break;
				case Constantes.logger.ISOTRX:
					loggerISOTRX.info(mensaje);
				break;
				default:
					loggerSAFI.info(mensaje);
				break;
			}			
		}  catch (ClientProtocolException clientProtocolException) {
			clientProtocolException.printStackTrace();
			respuestaPost = "{\"Exception\":\"2\"}";
			mensaje = Mensajes.ErrorProtocolo +"[ URL Servicio: " +this.urlServicio+ " ] "+ "Parámetros: "+ Utileria.logJsonFormat(parametros)+ " - " + clientProtocolException;
			switch(logImpresion){
				case Constantes.logger.SAFI:
					loggerSAFI.info(mensaje);
				break;
				case Constantes.logger.Vent:
					loggerVent.info(mensaje);
				break;
				case Constantes.logger.ISOTRX:
					loggerISOTRX.info(mensaje);
				break;
				default:
					loggerSAFI.info(mensaje);
				break;
			}
		} catch (IOException iOException) {
			iOException.printStackTrace();
			respuestaPost = "{\"Exception\":\"3\"}";
			mensaje = Mensajes.ErrorLectura +"[ URL Servicio: " +this.urlServicio+ " ] "+ "Parámetros: "+ Utileria.logJsonFormat(parametros)+ " - " + iOException;
			switch(logImpresion){
				case Constantes.logger.SAFI:
					loggerSAFI.info(mensaje);
				break;
				case Constantes.logger.Vent:
					loggerVent.info(mensaje);
				break;
				case Constantes.logger.ISOTRX:
					loggerISOTRX.info(mensaje);
				break;
				default:
					loggerSAFI.info(mensaje);
				break;
			}
		}catch (Exception exception) {
			exception.printStackTrace();
			respuestaPost = "{\"Exception\":\"4\"}";
			mensaje = Mensajes.ErrorServicio +"[ URL Servicio: " +this.urlServicio+ " ] "+ "Parámetros: "+ Utileria.logJsonFormat(parametros)+ " - " + exception;
			switch(logImpresion){
				case Constantes.logger.SAFI:
					loggerSAFI.info(mensaje);
				break;
				case Constantes.logger.Vent:
					loggerVent.info(mensaje);
				break;
				case Constantes.logger.ISOTRX:
					loggerISOTRX.info(mensaje);
				break;
				default:
					loggerSAFI.info(mensaje);
				break;
			}
		}

		mensaje = "Petición POST ---> [ URL Servicio: " +this.urlServicio+ " ] "+ "Response: "+ Utileria.stringToJson(respuestaPost);
		
		switch(logImpresion){
			case Constantes.logger.SAFI:
				loggerSAFI.info(mensaje);
				loggerSAFI.info(Mensajes.Final);
			break;
			case Constantes.logger.Vent:
				loggerVent.info(mensaje);
				loggerVent.info(Mensajes.Final);
			break;
			case Constantes.logger.ISOTRX:
				loggerISOTRX.info(mensaje);
				loggerISOTRX.info(Mensajes.Final);
			break;
			default:
				loggerSAFI.info(mensaje);
				loggerSAFI.info(Mensajes.Final);
			break;
		}

		return Utileria.jsonToObject(respuestaPost, tipoResponse);		
	}
	
	
	public String peticionGET(Object parametros, Class tipoResponse, final String tiempoEspera, final int logImpresion){

		paramRequest = Utileria.imprimeObjeto(parametros);
		mensaje = "Petición GET ---> [ URL Servicio: " +this.urlServicio+ " ] "+ "Request: "+ Utileria.logJsonFormat(parametros);
		switch(logImpresion){
			case Constantes.logger.SAFI:
				loggerSAFI.info(mensaje);
				loggerSAFI.info(Mensajes.Inicio);
			break;
			case Constantes.logger.Vent:
				loggerVent.info(mensaje);
				loggerVent.info(Mensajes.Inicio);
			break;
			case Constantes.logger.ISOTRX:
				loggerISOTRX.info(mensaje);
				loggerISOTRX.info(Mensajes.Inicio);
			break;
			default:
				loggerSAFI.info(mensaje);
				loggerSAFI.info(Mensajes.Inicio);
			break;
		}
		String respuestaGet = "";
		try {
			CloseableHttpClient httpClient=null;			
			getRequest.setHeader("Content-Type", "application/x-www-form-urlencoded");			
			// Crear la llamada al servidor
			httpClient = HttpClients.custom().setDefaultRequestConfig(Utileria.requestConfiguration(tiempoEspera)).build();
			
			// Tratar respuesta del servidor
			HttpResponse response;	
			response = httpClient.execute(getRequest);
			
			if (response.getStatusLine().getStatusCode() != 200) {
				throw new RuntimeException("Error : Codigo de error HTTP : "+ response.getStatusLine().getStatusCode());
			}	
			
			BufferedReader br = new BufferedReader(
            new InputStreamReader((response.getEntity().getContent())));
			String output;
			while ((output = br.readLine()) != null) {
				respuestaGet+=output;
			}
									
			httpClient.close();
		
		} catch (SocketTimeoutException socketTimeoutException){
			socketTimeoutException.printStackTrace();
			respuestaGet = "{\"Exception\":\"1\"}";
			mensaje = Mensajes.ErrorTimeOut +"[ URL Servicio: " +this.urlServicio+ " ] "+ "Parámetros: "+ Utileria.logJsonFormat(parametros)+ " - " + socketTimeoutException;
			switch(logImpresion){
				case Constantes.logger.SAFI:
					loggerSAFI.info(mensaje);
				break;
				case Constantes.logger.Vent:
					loggerVent.info(mensaje);
				break;
				case Constantes.logger.ISOTRX:
					loggerISOTRX.info(mensaje);
				break;
				default:
					loggerSAFI.info(mensaje);
				break;
			}			
		} catch (ClientProtocolException clientProtocolException) {
			respuestaGet = "{\"Exception\":\"2\"}";
			clientProtocolException.printStackTrace();
			mensaje = Mensajes.ErrorProtocolo +"[ URL Servicio: " +this.urlServicio+ " ] "+ "Parámetros: "+ Utileria.logJsonFormat(parametros)+ " - " + clientProtocolException;
			switch(logImpresion){
				case Constantes.logger.SAFI:
					loggerSAFI.info(mensaje);
				break;
				case Constantes.logger.Vent:
					loggerVent.info(mensaje);
				break;
				case Constantes.logger.ISOTRX:
					loggerISOTRX.info(mensaje);
				break;
				default:
					loggerSAFI.info(mensaje);
				break;
			}
		} catch (IOException iOException) {
			iOException.printStackTrace();
			respuestaGet = "{\"Exception\":\"3\"}";
			mensaje = Mensajes.ErrorLectura +"[ URL Servicio: " +this.urlServicio+ " ] "+ "Parámetros: "+ Utileria.logJsonFormat(parametros)+ " - " + iOException;
			switch(logImpresion){
				case Constantes.logger.SAFI:
					loggerSAFI.info(mensaje);
				break;
				case Constantes.logger.Vent:
					loggerVent.info(mensaje);
				break;
				case Constantes.logger.ISOTRX:
					loggerISOTRX.info(mensaje);
				break;
				default:
					loggerSAFI.info(mensaje);
				break;
			}
		} catch (Exception exception) {
			exception.printStackTrace();
			respuestaGet = "{\"Exception\":\"4\"}";
			mensaje = Mensajes.ErrorServicio +"[ URL Servicio: " +this.urlServicio+ " ] "+ "Parámetros: "+ Utileria.logJsonFormat(parametros)+ " - " + exception;
			switch(logImpresion){
				case Constantes.logger.SAFI:
					loggerSAFI.info(mensaje);
				break;
				case Constantes.logger.Vent:
					loggerVent.info(mensaje);
				break;
				case Constantes.logger.ISOTRX:
					loggerISOTRX.info(mensaje);
				break;
				default:
					loggerSAFI.info(mensaje);
				break;
			}
		}

		mensaje = "Petición GET ---> [ URL Servicio: " +this.urlServicio+ " ] "+ "Response: "+ Utileria.logJsonFormat(respuestaGet);
		switch(logImpresion){
			case Constantes.logger.SAFI:
				loggerSAFI.info(mensaje);
				loggerSAFI.info(Mensajes.Final);
			break;
			case Constantes.logger.Vent:
				loggerVent.info(mensaje);
				loggerVent.info(Mensajes.Final);
			break;
			case Constantes.logger.ISOTRX:
				loggerISOTRX.info(mensaje);
				loggerISOTRX.info(Mensajes.Final);
			break;
			default:
				loggerSAFI.info(mensaje);
				loggerSAFI.info(Mensajes.Final);
			break;
		}
		
		return respuestaGet;
	}
	
	public String getUrlServicio() {
		return urlServicio;
	}


	public void setUrlServicio(String urlServicio) {
		this.urlServicio = urlServicio;
	}


	public String getUserWS() {
		return userWS;
	}


	public void setUserWS(String userWS) {
		this.userWS = userWS;
	}


	public String getPassWS() {
		return passWS;
	}


	public void setPassWS(String passWS) {
		this.passWS = passWS;
	}

}
