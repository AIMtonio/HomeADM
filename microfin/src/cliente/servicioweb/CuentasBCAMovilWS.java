package cliente.servicioweb;

import general.bean.MensajeTransaccionBean;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.UnsupportedEncodingException;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.SocketTimeoutException;
import java.net.URL;
import java.net.URLEncoder;

import org.apache.log4j.Logger;

public class CuentasBCAMovilWS {
	
	protected final Logger loggerPDM = Logger.getLogger("PDM");
	
	private URL url;
	private int timeOut;
	String data;
	
	public CuentasBCAMovilWS(String url, int timeOut) throws MalformedURLException{
		this.url = new URL(url);
		this.timeOut = timeOut;
		data="";
	}

	public void add (String propiedad, String valor) throws UnsupportedEncodingException{
		//codificamos cada uno de los valores
		if (data.length()>0){
			data+= "&"+ URLEncoder.encode(propiedad, "UTF-8")+ "=" +URLEncoder.encode(valor, "UTF-8");
		}else{
			data+= URLEncoder.encode(propiedad, "UTF-8")+ "=" +URLEncoder.encode(valor, "UTF-8");
		}
	}
	
	public MensajeTransaccionBean getRespueta(){
		int  timeout = 1500;
		String respuesta = "";
		MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
		try {		
			
			//abrimos la conexion
			HttpURLConnection conn = (HttpURLConnection) url.openConnection();
			//especificamos que vamos a escribir		
			conn.setUseCaches(false);		
			conn.setDoOutput(true);
			conn.setRequestProperty("Content-Type", "application/json");
			conn.setRequestProperty("Accept", "application/json");
			conn.setRequestMethod("POST");			
			
			//configuramos el tiempo maximo para el timeout
			conn.setConnectTimeout(timeOut);
			//no descomentar esta linea ya que define el tiempo maximo de letura del response
			//conn.setReadTimeout(timeout);
			//obtenemos el flujo de escritura
			System.out.println("Peticion==>"+url.toString()+"?"+data);
			loggerPDM.info("Peticion==>"+url.toString()+"?"+data);
			OutputStreamWriter wr = new OutputStreamWriter(conn.getOutputStream());			
			//escribimos
			wr.write(data);		
			//cerramos la conexion
			wr.close();			
			
			if (conn.getResponseCode() != 200) {
				throw new RuntimeException(
						"Error : Código de error HTTP : "
								+ conn.getResponseCode());
			}	
			
			//obtenemos el flujo de lectura
			BufferedReader rd = new BufferedReader(new InputStreamReader(conn.getInputStream()));
		    String linea;
		    //procesamos al salida
		    while ((linea = rd.readLine()) != null) {
		        respuesta+= linea;
		    }
		    
		    rd.close();
		    conn.disconnect();
		    
		    mensajeBean.setNumero(0);
		    mensajeBean.setDescripcion(respuesta);
			
		}catch (SocketTimeoutException e) {
			// TODO Auto-generated catch block			
			e.printStackTrace();			
			if(mensajeBean.getNumero() == 0){				
				mensajeBean.setNumero(999);
				mensajeBean.setDescripcion("Estimado Usuario(a), Ha ocurrido una falla en el sistema, "
						+ "Por el Momento los Servicios de PADEMOBILE No se encuentran Disponibles. Ref: WS-CuentasBCAMovilWS");
			}
			
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			if(mensajeBean.getNumero() == 0){				
				mensajeBean.setNumero(999);
			}
			mensajeBean.setDescripcion(e.getMessage());
		}	
		
		return mensajeBean;
	}


}
