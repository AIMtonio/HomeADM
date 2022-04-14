package sms.controlador;

import general.bean.MensajeTransaccionBean;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.FileUtils;
import org.springframework.validation.BindException;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import sms.bean.ParametrosSMSBean;
import sms.bean.SMSEnvioMensajeBean;
import sms.servicio.ParametrosSMSServicio;
import sms.servicio.SMSEnvioMensajeServicio;

public class SMSFileUploadControlador extends SimpleFormController{
	SMSEnvioMensajeServicio smsEnvioMensajeServicio = null;
	ParametrosSMSServicio parametrosSMSServicio = null;
	
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception{
		
		String[] extensValidas = {"txt","jpg","png","jpeg","gif","csv","xls","xlsx","tiff","pdf","doc","docx"};
		boolean validaExt = false;
		SMSEnvioMensajeBean smsEnvioMensaje = (SMSEnvioMensajeBean) command;
		smsEnvioMensajeServicio.getSmsEnvioMensajeDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		int tipoTransaccion = (request.getParameter("tipoTransaccion") != null)?
				Integer.parseInt(request.getParameter("tipoTransaccion")):
					0;
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		String directorio = "";
		String archivoNombre ="";
		ParametrosSMSBean parametrosSMSBean = null;
		ParametrosSMSBean parametros = null;
		parametros = parametrosSMSServicio.consulta(tipoTransaccion, parametrosSMSBean);
		directorio = parametros.getRutaMasivos();
		Date f= new Date();
		SimpleDateFormat formateador = new SimpleDateFormat("dd-MM-yyyyhh:mm:ss");
		String fecha = formateador.format(f);
		Integer usuario = smsEnvioMensajeServicio.getSmsEnvioMensajeDAO().getParametrosAuditoriaBean().getUsuario();
		boolean exists = (new File(directorio)).exists();
		 archivoNombre = request.getParameter("extarchivo");
		
		for(String w : extensValidas)//Verfica que sea tio de archivo permitido
			{
			validaExt|=archivoNombre.toLowerCase().endsWith(w);
			}
		if(validaExt) {
		if (exists) {
			MultipartFile file = smsEnvioMensaje.getFile();
			//archivoNombre =directorio+smsEnvioMensaje.getCampaniaID()+System.getProperty("file.separator")+smsEnvioMensaje.getCampaniaID()+usuario+fecha+".xls";
			archivoNombre =directorio+smsEnvioMensaje.getCampaniaID()+System.getProperty("file.separator")+smsEnvioMensaje.getCampaniaID()+usuario+fecha+".csv";
			if (file != null) {
				File filespring = new File(archivoNombre);  
				FileUtils.writeByteArrayToFile(filespring, file.getBytes());  
			}
		}else {
			File aDir = new File(directorio);
			aDir.mkdir();
			MultipartFile file = smsEnvioMensaje.getFile();
			//archivoNombre =directorio+smsEnvioMensaje.getCampaniaID()+System.getProperty("file.separator")+smsEnvioMensaje.getCampaniaID()+usuario+fecha+".xls";
			archivoNombre =directorio+smsEnvioMensaje.getCampaniaID()+System.getProperty("file.separator")+smsEnvioMensaje.getCampaniaID()+usuario+fecha+".csv";
			if (file != null) {
				File filespring = new File(archivoNombre);
				FileUtils.writeByteArrayToFile(filespring, file.getBytes());  
			}
		}
		}
		else
			return new ModelAndView(getSuccessView(), "mensaje", null);
		mensaje.setNumero(0);
		mensaje.setDescripcion("Archivo Digitalizado Exitosamente");
		mensaje.setConsecutivoString(archivoNombre);
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}
	public void setSmsEnvioMensajeServicio(
			SMSEnvioMensajeServicio smsEnvioMensajeServicio) {
		this.smsEnvioMensajeServicio = smsEnvioMensajeServicio;
	}
	public void setParametrosSMSServicio(ParametrosSMSServicio parametrosSMSServicio) {
		this.parametrosSMSServicio = parametrosSMSServicio;
	}

}
