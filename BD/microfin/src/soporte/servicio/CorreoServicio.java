package soporte.servicio;

import java.io.File;
import java.util.Properties;

import general.servicio.BaseServicio;
import herramientas.Constantes;
import herramientas.Utileria;

import javax.mail.MessagingException;
import javax.mail.Session;
import javax.mail.internet.MimeMessage;
import javax.mail.PasswordAuthentication;
import javax.mail.Message;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;

import org.pentaho.di.core.KettleEnvironment;
import org.pentaho.di.core.exception.KettleException;
import org.pentaho.di.core.util.EnvUtil;
import org.pentaho.di.trans.Trans;
import org.pentaho.di.trans.TransMeta;
import org.springframework.core.io.FileSystemResource;
import org.springframework.core.task.TaskExecutor;
import org.springframework.mail.javamail.JavaMailSenderImpl;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.util.StringUtils;

import soporte.bean.EnvioCorreoBean;
import soporte.bean.ParamGeneralesBean;
import soporte.dao.EnvioCorreoDAO;
import cliente.bean.ClienteBean;
import cliente.servicio.ClienteServicio;
import cuentas.bean.CuentasAhoBean;

public class CorreoServicio  extends BaseServicio {

	private Properties propiedadesEmail = null;
	JavaMailSenderImpl mailSender = new JavaMailSenderImpl();
	private ClienteServicio clienteServicio = null;
	ParamGeneralesServicio paramGeneralesServicio;
	public int RutaCorreoKTR = 3;
	TaskExecutor taskExecutor = null;
	EnvioCorreoDAO envioCorreoDAO =null;
	
	//---------- Tipo de Consulta ----------------------------------------------------------------
	public static interface Enum_Con_TipoCorreo {
		int aperturaCuenta = 1;
		int aperturaInversion = 2;
		int aperturaCredito = 3;
		int correoLibre = 4;
		
	}
	
	public static interface Enum_Con_CorreoServicio {
		int pendientes_pld = 1;
	}
	
	/* Envia un correo al Cliente como confirmacion de la realizacion
	/* de una operacion monetaria en la Aplicacion SAFI */
	public void enviaCorreoConfirmacionOp(String numeroCliente,										  
										  Object objetoBean,
										  int tipoEnvioCorreo){
				
		
		String mensajeCorreo;
		CuentasAhoBean cuentaBean;
		ClienteBean clienteBean = clienteServicio.consulta(ClienteServicio.Enum_Con_Cliente.correo, numeroCliente, "");
		if(clienteBean!=null && !clienteBean.getCorreo().trim().equalsIgnoreCase("")){
			try {
				MimeMessage message = mailSender.createMimeMessage();
				MimeMessageHelper helper;
				// TODO Obtener esta Informacion de la Variables de Aplicacion
				helper = new MimeMessageHelper(message, true);
				helper.setFrom("contacto@aye.com.mx");
				helper.setSubject("Confirmacion de Operacion!");
				
				helper.setTo(clienteBean.getCorreo());
				
				switch (tipoEnvioCorreo) {
					case Enum_Con_TipoCorreo.aperturaCuenta:
							mensajeCorreo = Constantes.CORREO_APERTURA_CUENTA;
							cuentaBean = (CuentasAhoBean)objetoBean;
							mensajeCorreo = StringUtils.replace(mensajeCorreo, "%NombreCliente%", clienteBean.getNombreCompleto());
							mensajeCorreo = StringUtils.replace(mensajeCorreo, "%NombreEmpresa%", "ACCION Y EVOLUCION");
							mensajeCorreo = StringUtils.replace(mensajeCorreo, "%Cuenta%", cuentaBean.getCuentaAhoID());
							mensajeCorreo = StringUtils.replace(mensajeCorreo, "%CuentaCLABE%", cuentaBean.getClabe());
							FileSystemResource recurso = new FileSystemResource(new File(Constantes.RUTA_IMAGENES +
																				System.getProperty("file.separator") +
																				"LogoPrincipal.png"));
							helper.setText(mensajeCorreo, true);
							helper.addInline("logoPeq", recurso);
						break;	
				}				
				
				mailSender.send(message);
				
			} catch (Exception e) {
				e.printStackTrace();
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en enviar correo de confirmacion", e);
			}
		}
		
	}
	
	// Envia un correo con mensaje y destinatario libre
	// cuenta Origen: Cuenta de Correo Origen (from)
	// cuentaDestinatario: Cuenta de Correo del destinatario
	// cuentasDestinatarios: Arreglo de cuentas de correos de Destinantarios, para envio a mas de una persona
	// subject: Asunto del Correo
	// mensajeCorreo: Cuerpo o Mensaje del Correo
	// objetoBean: Bean Generico para traspaso de informacion al correo (ClienteBean, CuentaAhoBean, etc )
	// tipoEnvioCorreo: Constante del enum CorreoServicio.Enum_Con_TipoCorreo, para especificar el tipo de correo a enviar
	
	public void enviaCorreo(
							String cuentaOrigen,
							String cuentaDestinatario,
							String[] cuentasDestinatarios,
							String subject,
							String mensajeCorreo,
			  				Object objetoBean,
			  				int tipoEnvioCorreo, FileSystemResource recurso){
		
		
		try {
					    
			MimeMessage message = mailSender.createMimeMessage();
			
			MimeMessageHelper helper;			
			helper = new MimeMessageHelper(message, true);
			helper.setFrom(cuentaOrigen);
			helper.setSubject(subject);
			if(cuentasDestinatarios!=null){
				helper.setTo(cuentasDestinatarios);	
			}else{
				helper.setTo(cuentaDestinatario);
			}
			
			switch (tipoEnvioCorreo) {
				case Enum_Con_TipoCorreo.correoLibre:
						helper.setText(mensajeCorreo, true);
						helper.addInline("logoPeq", recurso);
						
					break;
			}
			
			mailSender.send(message);

		} catch (MessagingException e) {
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en envia correo", e);
		}
	}
	
	
	
	public void enviaCorreoPLD(String	host, 
							String	puerto,
							String	userName,
							String	contrasenia,
							String cuentaOrigen,
							String cuentaDestinatario,
							String[] cuentasDestinatarios,
							String subject,
							String mensajeCorreo,
			  				Object objetoBean,
			  				int tipoEnvioCorreo, FileSystemResource recurso){
		
		
		try {
			
		 	mailSender.setHost(host);
			mailSender.setPort(Integer.parseInt(puerto));
			mailSender.setUsername(userName);
		    mailSender.setPassword(contrasenia);
		    
			MimeMessage message = mailSender.createMimeMessage();
			
			MimeMessageHelper helper;			
			helper = new MimeMessageHelper(message, true);
			helper.setFrom(cuentaOrigen);
			helper.setSubject(subject);
			if(cuentasDestinatarios!=null){
				helper.setTo(cuentasDestinatarios);	
			}else{
				helper.setTo(cuentaDestinatario);
			}
			
			switch (tipoEnvioCorreo) {
				case Enum_Con_TipoCorreo.correoLibre:
						helper.setText(mensajeCorreo, true);
						helper.addInline("logoPeq", recurso);
						
					break;
			}
			
			mailSender.send(message);

		} catch (MessagingException e) {
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en envia correo", e);
		}
	}
	public void setMailSender(JavaMailSenderImpl mailSender) {
		this.mailSender = mailSender;
	}

	public void setClienteServicio(ClienteServicio clienteServicio) {
		this.clienteServicio = clienteServicio;
		
		String rutaImagenes = System.getProperty("user.home") +
							  System.getProperty("file.separator") + "opt" +
							  System.getProperty("file.separator") + "tomcat6" +
							  System.getProperty("file.separator") + "webapps" +
							  System.getProperty("file.separator") + "microfin" +
							  System.getProperty("file.separator") + "images";
							  
		
	}
	
	
	/**
	 * 
	 * @param servidorEmail  Servidor de correo ejemplo: mail.efisys.com.mx
	 * @param puertoEmail	Numero de puerto  ejemplo:  995  
	 * @param usuarioEnvioEmail	nombre del usuario de la cuenta de correo origen  ejemplo:  jcastaneda
	 * @param PaswordUsuario	password del usuario de la cuenta de correo origen  ejemplo jcasta
	 * @param autenticacion		indica si requiere autenticacion la cuenta  solo puede ser de forma textual "true" o "false"
	 * @return propiedades
	 */
	
	 
	public Properties cargaPropiedadesEmail(String servidorEmail, String puertoEmail, String usuarioEnvioEmail, String PaswordUsuario, String autenticacion){
		
		propiedadesEmail = new Properties();
		propiedadesEmail.setProperty("mail.smtp.host", servidorEmail);
		propiedadesEmail.setProperty("mail.smtp.port", puertoEmail);
		propiedadesEmail.setProperty("mail.smtp.user", usuarioEnvioEmail);
		propiedadesEmail.setProperty("mail.smtp.psw", usuarioEnvioEmail);
		propiedadesEmail.setProperty("mail.smtp.auth", autenticacion);
		
		return propiedadesEmail;
	}
	
	/**
	 * 
	 * @param cuentaOrigen	Cuenta De correo Origen   ejemplo@micorreo.com
	 * @param cuentaDestinatario Cuenta de correo Destino   tucorreo@correos.com.mx	 * 
	 * @param subject	Asunto del correo  ejemplo:  aviso		
	 * @param mensajeCorreo  Mensaje de correo   Ejemplo: Estimado cliente se le informa que tiene un credito preautorizado comunicarse a telefono 5865855875  
	 */
	public String enviarEmail(String cuentaOrigen, String cuentaDestinatario, String subject, String mensajeCorreo) {
	 String MensajeRespuesta = "";
//		se crea un objeto de sesion
		Session session = Session.getInstance(propiedadesEmail,
		  new javax.mail.Authenticator() {
			protected PasswordAuthentication getPasswordAuthentication() {
				return new PasswordAuthentication(propiedadesEmail.getProperty("mail.smtp.user"), propiedadesEmail.getProperty("mail.smtp.psw"));
			}
		  });
 
		try {
 
			Message message = new MimeMessage(session);
			message.setFrom(new InternetAddress(cuentaOrigen));
			message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(cuentaDestinatario));
			message.setSubject(subject);
			message.setText(mensajeCorreo); 
			Transport.send(message);
			
			MensajeRespuesta = "Correo enviado a " + cuentaDestinatario;
			
		 
		} catch (MessagingException e) {
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en enviar email", e);
			throw new RuntimeException(e);
		}
		return MensajeRespuesta;
	}
	
	/**
	 * @param filename Ruta completa del archivo ktr que se encarga de realizar el envio de correo. Ejemplo: /opt/tomcat6/EnvioCorreo.ktr
	 */
	public void enviarCorreo(String filename) {
		try {
			KettleEnvironment.init();
			EnvUtil.environmentInit();
			TransMeta transMeta = new TransMeta(filename);
			Trans trans = new Trans(transMeta);

			trans.execute(null); // You can pass arguments instead of null.
			trans.waitUntilFinished();
			if(trans.getErrors() > 0){
				throw new RuntimeException("Hubo errores durante la ejecución de la transformación: " + filename);
			}
		} catch (KettleException e) {
			// TODO Put your exception-handling code here.
			e.printStackTrace();
			loggerSAFI.error(e.getMessage());
		}
	}
	/**
	 * Consulta la ruta de EnvioCorreo.ktr en parametros generales y Ejecuta la transformación para el envio.
	 */
	public void EjecutaEnvioCorreo() {
		try {
			EnvioCorreoBean envioCorreoBean = new EnvioCorreoBean();
			EnvioCorreoBean enviosPendientes = consultas(envioCorreoBean, Enum_Con_CorreoServicio.pendientes_pld);
			if (false) {
				// Tipo de consulta  para obtener la ruta de EnvioCorreo.ktr
				int tipoConParam = RutaCorreoKTR;
				ParamGeneralesBean paramGeneralesBean = new ParamGeneralesBean();
				paramGeneralesBean = paramGeneralesServicio.consulta(tipoConParam, paramGeneralesBean);
				
				final String ruta = paramGeneralesBean.getValorParametro();
				
				taskExecutor.execute(new Runnable() {
					public void run() {
						enviarCorreo(ruta);
					}
				});
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		}
	}
	
	public EnvioCorreoBean consultas(EnvioCorreoBean EnvioCorreoBean, int tipo_consulta) {
		System.out.println("Consultas correo");
		EnvioCorreoBean envioCorreoBean = null;
		switch (tipo_consulta) {
			case Enum_Con_CorreoServicio.pendientes_pld:
				envioCorreoBean = envioCorreoDAO.consultaPendientesPLD(envioCorreoBean, Enum_Con_CorreoServicio.pendientes_pld);
				break;
		}
		return envioCorreoBean;
	}
	public TaskExecutor getTaskExecutor() {
		return taskExecutor;
	}

	public void setTaskExecutor(TaskExecutor taskExecutor) {
		this.taskExecutor = taskExecutor;
	}
	
	public ParamGeneralesServicio getParamGeneralesServicio() {
		return paramGeneralesServicio;
	}

	public void setParamGeneralesServicio(
			ParamGeneralesServicio paramGeneralesServicio) {
		this.paramGeneralesServicio = paramGeneralesServicio;
	}

	public EnvioCorreoDAO getEnvioCorreoDAO() {
		return envioCorreoDAO;
	}

	public void setEnvioCorreoDAO(EnvioCorreoDAO envioCorreoDAO) {
		this.envioCorreoDAO = envioCorreoDAO;
	}
	
}
