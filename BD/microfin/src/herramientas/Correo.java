package herramientas;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.HashMap;
import java.util.Map;

import org.apache.commons.mail.ByteArrayDataSource;
import org.apache.commons.mail.EmailAttachment;
import org.apache.commons.mail.EmailException;
import org.apache.commons.mail.HtmlEmail;

public class Correo {
	
	private HtmlEmail email = null;
	
	private boolean configuracionRealizada = false;
	
	private String smtpServer;
	private int puertoSmtp;
	private String correoOrigen;
	private String contraseniaCorreoOrigen;
	
	private SecureConexion secureConexion;
	private boolean requiereAutentificacion;
	private static final HashMap<String, String> MIMETYPE = new HashMap<String, String>(); 
	 static {
		 MIMETYPE.put("ZIP", "application/zip");
		 MIMETYPE.put("PDF", "application/pdf");
		 MIMETYPE.put("CSV", "text/csv");
		 MIMETYPE.put("DOC", "application/msword");
		 MIMETYPE.put("JPG", "image/jpeg");
		 MIMETYPE.put("RAR", "application/x-rar-compressed");
		 MIMETYPE.put("XLS", "application/vnd.ms-excel");
		 MIMETYPE.put("XML", "application/xml");
		 MIMETYPE.put("XLSX", "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
		 MIMETYPE.put("DOCX", "application/vnd.openxmlformats-officedocument.wordprocessingml.document");
	    }
	 
	 public enum SecureConexion{
		 SSL,NINGUNA
	 }
	 /*public static interface secureConexion{
		 int NINGUNA = 0;
		 int SSL = 1;
		 
	 }*/
	

	 private HashMap<String, String> CIDS = null;
	
	
	
	
	


	/**
	 * @Autor:			Miguel A.R.S.
	 * @Fecha:			18/05/2018
	 * @Descripcion:	metodo privado para inicializar el objeto email, cada vez que se acaba de enviar un correo
	 * 					listo para enviar otro correo
	 *
	 */
	private void inicializar(){
		String[] resultado = new String[2];
		CIDS = null;
		resultado= configuracion(this.smtpServer,this.puertoSmtp,this.correoOrigen,this.contraseniaCorreoOrigen,this.secureConexion,this.requiereAutentificacion,true);
		if(!resultado[0].equals("000000")){
			 new Exception("ERROR AL REINICAR LA CONFIGURACION["+resultado[1]+"]");
		}
		
	}
	
	
	/**
	 * @Autor:			Miguel A.R.S.
	 * @Fecha:			18/05/2018
	 * @Descripcion:	Metodo que servira para configurar el objeto email, en el cual se establecen la configuracion necesaria, para enviar
	 * 					correos
	 *
	 * @param smtpServer  				parametro de tipo String para especificar el servidor smpt ejemplo: mail.cardinal-bi.com.mx
	 * @param puertoSmtp  				parametro de tipo entero para especificar el puerto del servidor smtp 
	 * @param correoOrigen				parametro de tipo string para especificar la cuenta de correo de donde salddran los correos.
	 * @param contraseniaCorreoOrigen	parametro de tipo string para especificar la contraseña del correo de donde sales los mails
	 * @param reconfigurar				parametro de tipo booleano, siempre debe ser true.
	 * @return							Este metodo devolvera un arreglo de Sting de 2 pocisiones, en donde en la primera posicion tendra un codigo
	 * 									en la segunda posicion un mensaje de acuerdo al codigo devuelsto. los codigos que devuekve son:
	 * 									000000->Configuracion correcta
	 * 									000001->Es necesario que se especifique el parametro smtpServer
	 * 									000002->Es necesario que se especifique el parametro puertoSmtp
	 * 									000003->Es necesario que se especifique la cuenta de  correo de donde saldran los correos
	 * 									000004->Es necesario que se especifique la contraseña de la cuenta de  correo de donde saldran los correos
	 * 									000005->Ocurrio un error al configurar el envio de correos
	 * 
	 */
	public String[] configuracion(String smtpServer, int puertoSmtp, String correoOrigen, String contraseniaCorreoOrigen, SecureConexion secureConexion,boolean requiereAutentificacion , boolean reconfigurar){
		this.smtpServer =  smtpServer;
		this.puertoSmtp = puertoSmtp;
		this.correoOrigen = correoOrigen;
		this.contraseniaCorreoOrigen = contraseniaCorreoOrigen;
		this.secureConexion = secureConexion;
		this.requiereAutentificacion = requiereAutentificacion;
		
		String[] resultado = new String[2];
		resultado[0]="000000";
		resultado[1]= "Configuracion correcta";
		
		if(reconfigurar){
			email= null;
			configuracionRealizada = false;
		}
		
		if(configuracionRealizada == false){
			try {
			if(smtpServer == null){
				resultado[0]="000001";
				resultado[1]= "Es necesario que se especifique el parametro smtpServer";
				return resultado;
			}
			if(puertoSmtp == 0){
				resultado[0]="000002";
				resultado[1]= "Es necesario que se especifique el parametro puertoSmtp";
				return resultado;
			}
			if(correoOrigen == null){
				resultado[0]="000003";
				resultado[1]= "Es necesario que se especifique la cuenta de  correo de donde saldran los correos";
				return resultado;
			}
			if(contraseniaCorreoOrigen == null){
				resultado[0]="000004";
				resultado[1]= "Es necesario que se especifique la contraseña de la cuenta de  correo de donde saldran los correos";
				return resultado;
			}
			
			email = new HtmlEmail();
			email.setHostName(smtpServer);
			email.setSmtpPort(puertoSmtp);
			
			// se verifica si requiere autentificacion
			if(requiereAutentificacion){
				email.setAuthentication(correoOrigen, contraseniaCorreoOrigen);
			}
			
			// se pregunta si se debe estableces la seguridad por SSL
			if(secureConexion == SecureConexion.SSL){
				email.setSSLOnConnect(true);
			}
			
				email.setFrom(correoOrigen);
			} catch (EmailException e) {			
				e.printStackTrace();
				resultado[0]="000005";
				resultado[1]= "Ocurrio un error al configurar el envio de correos";
				return resultado;
			}
			configuracionRealizada = true;
			
		}	
		
		
		return resultado;
	}
	
	/**
	 * @Autor:			Miguel A.R.S.
	 * @Fecha:			18/05/2018
	 * @Descripcion:	Metodo que sirve para agregar, los correos destino
	 *
	 * @param correosDestinos		Este parametro representa un arreglo de strings, en donde se especifica los correo destinos
	 * @return						Este metodo devolvera un arreglo de Sting de 2 pocisiones, en donde en la primera posicion tendra un codigo
	 * 								en la segunda posicion un mensaje de acuerdo al codigo devuelsto. los codigos que devuekve son:
	 * 								000000->Destinatarios agregados correctamente
	 * 								000006->Por favor antes de anadir destinatarios, configure la cuenta de donde saldran los correos
	 * 								000007->"Ocurrio un error al anadir los destinatarios"
	 */
	public String[] anadirDestinatarios(String... correosDestinos){
		String[] resultado = new String[2];
		
		resultado[0]="000000";
		resultado[1]= "Destinatarios agregados correctamente";
		
		if(configuracionRealizada == false){
			resultado[0]="000006";
			resultado[1]= "Por favor antes de anadir destinatarios, configure la cuenta de donde saldran los correos";
			return resultado;
		}
		
		try {
			email.addTo(correosDestinos);
			
		} catch (EmailException e) {
			e.printStackTrace();
			resultado[0]="000007";
			resultado[1]= "Ocurrio un error al anadir los destinatarios";
			return resultado;
			
		}
		
		return resultado;
	}
	
	
	/**
	 * @Autor:			Miguel A.R.S.
	 * @Fecha:			18/05/2018
	 * @Descripcion:	Metodo para adjuntar de 1 a n archivos
	 *
	 * @param pathFiles				Este parametro representa un arreglo de strings, en donde se especifica una lista de paths de los
	 * 								archivos que se desea adjuntar.
	 * 
	 * @return						Este metodo devolvera un arreglo de Sting de 2 pocisiones, en donde en la primera posicion tendra un codigo
	 * 								en la segunda posicion un mensaje de acuerdo al codigo devuelsto. los codigos que devuekve son:
	 * 								000000->Archivos adjuntados correctamente
	 * 								000006->Por favor antes de adjuntar archivos, configure la cuenta de donde saldran los correos
	 * 								000008->El path de archivo que desae adjuntar, es nulo, Por favor indique el path del archivo que desea adjuntar
	 * 								000009->No es posible adjuntar el archivo[@nombreArchivo] - FILE[@pathFile] 								
	 * 								000010->Los archivos con extencion[@extencion] no son soportados para adjuntar - FILE[@pathFile]
	 * 								000011->Ocurrio un error al adjuntar el archivo[@pathFile]
	 * 								000013->No fue posible determinar un nombre para adjuntar el archivo - FILE[@pathFile]
	 * 								000012->Ocurrio un error al adjuntar el archivo[@pathFile]
	 * 								000014->Ocurrio un error al adjuntar el archivo[@pathFile]
	 * 								000015->Ocurrio un error al adjuntar el archivo[@pathFile]
	 */
	public String[] adjuntarArchivos(String... pathFiles){
		String extencion = null;
		String mimeType	= null;
		String[] resultado = new String[2];
		byte[] fileBytes = null;
		 int inicioSlash = -1;
		 String nombreArchivo= null;
		 
		resultado[0]="000000";
		resultado[1]= "Archivos adjuntados correctamente";
		
		if(configuracionRealizada == false){
			resultado[0]="000006";
			resultado[1]= "Por favor antes de adjuntar archivos, configure la cuenta de donde saldran los correos";
			return resultado;
		}
		
		for(String pathFile:pathFiles){
			
			pathFile = pathFile.trim();
			 extencion 	= "";
			 mimeType	= "";
			
			
			// se valida que no nos manden un pinche nulo
			if(pathFile == null){
				resultado[0]="000008";
				resultado[1]= "El path de archivo que desae adjuntar, es nulo, Por favor indique el path del archivo que desea adjuntar";
				return resultado;
			}
			
			// obtenemos el nombre del archivo
			inicioSlash = pathFile.lastIndexOf("/");
			 if (inicioSlash == -1){
				 inicioSlash = pathFile.lastIndexOf("\\");
			 }
			 
			 if(inicioSlash == -1){
				resultado[0]="000013";
				resultado[1]= "No fue posible determinar un nombre para adjuntar el archivo - FILE["+pathFile+"]";
				return resultado; 
			 }
			
			 nombreArchivo = pathFile.toUpperCase().trim().substring(inicioSlash+1, pathFile.length());
			if(nombreArchivo.length() <=4){
				resultado[0]="000009";
				resultado[1]= "No es posible adjuntar el archivo["+nombreArchivo+"] - FILE["+pathFile+"]";
				return resultado;
			}
			// extraemos la extencion
			extencion = pathFile.substring(pathFile.length()-3, pathFile.length()).toUpperCase();
			
			// buscamos la extencion dentro de los archivos permituidos
			mimeType = MIMETYPE.get(extencion);
			if(mimeType == null){
				resultado[0]="000010";
				resultado[1]= "Los archivos con extencion["+ extencion+"] no son soportados para adjuntar - FILE["+pathFile+"]";
				resultado[1] =  resultado[1] + "\n extenciones soportadas:" +extencionesSoportadas();
				return resultado;
			}
			
			// cargamos el archivo en un arreglo de bytes
			try {
				fileBytes = fileToBytes(pathFile);
			} catch (IOException e) {			
				e.printStackTrace();
				resultado[0]="000011";
				resultado[1]= "Ocurrio un error al adjuntar el archivo["+ pathFile+"]";
				return resultado;
			} catch (Exception e) {
				e.printStackTrace();
				resultado[0]="000012";
				resultado[1]= "Ocurrio un error al adjuntar el archivo["+ pathFile+"]";
				return resultado;
			}
			
			
			
			 
			 
			// adjuntamos el archivo para poder enviarlo
			try {
				email.attach(new ByteArrayDataSource(fileBytes, mimeType),      nombreArchivo, "archivo adjunto",  EmailAttachment.ATTACHMENT);
				resultado[1] = resultado[1] + "\n" + pathFile;
			} catch (EmailException e) {
				e.printStackTrace();
				resultado[0]="000014";
				resultado[1]= "Ocurrio un error al adjuntar el archivo["+ pathFile+"]";
				return resultado;
			} catch (IOException e) {
				e.printStackTrace();
				resultado[0]="000015";
				resultado[1]= "Ocurrio un error al adjuntar el archivo["+ pathFile+"]";
				return resultado;
			}
		
		}
		return resultado;
	}
	
	
	
	
	/**
	 * @Autor:			Miguel A.R.S.
	 * @Fecha:			18/05/2018
	 * @Descripcion:	Metodo encargado de enviar un correo electronico
	 *
	 * @param mensajeHTML				Parametro de tipo string en donde se espcifica un mensaje en formato HTML.
	 * 
	 * @param mensajePlanoAlternativo	Parametro de tipo string en donde se especifica un mensaje de texto plano, como alternativa, encaso 
	 * 									de que el cliente de correo del destinatario no acepte el msg en HTML
	 * 
	 * @param asunto					parametro de tipo String en donde se indicara el asunto del correo
	 * 
	 * @return							Este metodo devolvera un arreglo de Sting de 2 pocisiones, en donde en la primera posicion tendra un codigo
	 * 									en la segunda posicion un mensaje de acuerdo al codigo devuelsto. los codigos que devuekve son:
	 * 									000000->Correo enviado
	 * 									000006->Por favor antes de enviar un msg, configure la cuenta de donde saldran los correos
	 * 									000016->Por favor antes de enviar un msg, configure la cuenta de donde saldran los correos
	 * 									000017->Ocurrio un error al tratar de enviar el mensaje HTML - CORREO NO ENVIADO
	 * 									000018->Ocurrio un error al enviar el mensaje[revise los logs para mayor informacion]
	 */
	public String[] enviar(String mensajeHTML,String mensajePlanoAlternativo,String asunto){
		String[] resultado = new String[2];
		resultado[0]="000000";
		resultado[1]= "Correo enviado";
		
		if(configuracionRealizada == false){
			resultado[0]="000006";
			resultado[1]= "Por favor antes de enviar un msg, configure la cuenta de donde saldran los correos";
			return resultado;
		}
		
		
		if(mensajeHTML == null){
			resultado[0]="000016";
			resultado[1]= "El mensaje en HTML no puede ser nulo";
			return resultado;
		}
		if(mensajePlanoAlternativo == null || mensajePlanoAlternativo.equals("")){
			mensajePlanoAlternativo = "Tu cliente de correo no soporta mensajes en formato HTML";
		}
		email.setSubject(asunto);
		// se establece el mensaje en HTML
		try {
			email.setHtmlMsg(mensajeHTML);
		} catch (EmailException e) {
			e.printStackTrace();
			resultado[0]="000017";
			resultado[1]= "Ocurrio un error al tratar de enviar el mensaje HTML - CORREO NO ENVIADO";
			return resultado;
		}
		
		// se establece el mensaje en texto plano
		try {
			email.setTextMsg(mensajePlanoAlternativo);
		} catch (EmailException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		try {
			email.send();
		} catch (EmailException e) {
			e.printStackTrace();
			resultado[0]="000018";
			resultado[1]= "Ocurrio un error al enviar el mensaje[revise los logs para mayor informacion]";
			return resultado;
		}
		
		inicializar();
		return resultado;
	}
	
	
	
	
	/**
	 * @Autor:			Miguel A.R.S.
	 * @Fecha:			18/05/2018
	 * @Descripcion:	Metodo que sirve para registrar imagenes que seran usadas en el cuerpo del correo, embebiendolas
	 *
	 * @param pathImagen	parametro de tipo String de tipo String que indica el path de la imagen que se registrara para poder usarla posteriormente en el msg
	 * @param alias			parametro de tipo String en el cual se le especifica un alias a la imagen, para que atraves de este se le use en el cuerpo del msg
	 */
	public void registraCID(String pathImagen, String alias){
		if(CIDS == null){
			CIDS = new HashMap<String, String>();			
		}
		
		
		try {
			URL url = new URL(pathImagen);
			String cid =email.embed(url, "img");
			if(cid != null){
				CIDS.put(alias,cid );
			}
			
		} catch (EmailException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (MalformedURLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}
	
	
	
	/**
	 * @Autor:			Miguel A.R.S.
	 * @Fecha:			18/05/2018
	 * @Descripcion:	metodo para obtener un CID, de una imagen previamente registrada
	 *
	 * @param alias		parametro de stipo string, el cual indica el alias de la imagen que fue registrado con ateroridad
	 * @return			este metodo regresa el alias en una variable de tipo String, si el CID no existe refresara null
	 */
	public String getCID(String alias){
		if(CIDS == null){
			return null;			
		}
		
		return CIDS.get(alias);
	}
	
	
	
	
	
	/**
	 * @Autor:			Miguel A.R.S.
	 * @Fecha:			18/05/2018
	 * @Descripcion:	mETODO PRIVADO, QUE SIRVE PARA CARGAR EN UN ARREGLO DE BYTES UN ARCHIVO
	 *
	 * @param pathFile
	 * @return
	 * @throws IOException
	 * @throws Exception
	 */
	private static byte[] fileToBytes(String pathFile) throws IOException,Exception{
		
		if(pathFile == null){
			new IOException("El archivo que intenta convertir a bytes es nulo");
		}
		File file = new File(pathFile);
		  //init array with file length
		  byte[] bytesArray = new byte[(int) file.length()]; 

		  FileInputStream fis = new FileInputStream(file);
		  fis.read(bytesArray); //read file into bytes[]
		  fis.close();
					
		  return bytesArray;
		
	}
	
	private String extencionesSoportadas(){
		String resultado ="\n";
		for (Map.Entry<String, String> entry : MIMETYPE.entrySet()) {
			resultado = resultado +  entry.getKey() + "\n";
		}
		return resultado;
	}
	

}
