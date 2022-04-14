package sms.controlador;

import java.text.SimpleDateFormat;
import java.util.Date;

import general.bean.MensajeTransaccionBean;
import herramientas.Constantes;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import sms.bean.SMSEnvioMensajeBean;
import sms.servicio.SMSEnvioMensajeServicio;

public class SMSEnvioMensajeControlador extends SimpleFormController {

	SMSEnvioMensajeServicio smsEnvioMensajeServicio = null;
	
	public SMSEnvioMensajeControlador(){
		setCommandClass(SMSEnvioMensajeBean.class);
		setCommandName("smsEnvioMensajeBean");
	}
	protected ModelAndView onSubmit(HttpServletRequest request,
					HttpServletResponse response,
					Object command,
					BindException errors) throws Exception{
		
		SMSEnvioMensajeBean smsEnvioMensaje = (SMSEnvioMensajeBean) command;
		smsEnvioMensajeServicio.getSmsEnvioMensajeDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		int tipoTransaccion = (request.getParameter("tipoTransaccion") != null)?
		Integer.parseInt(request.getParameter("tipoTransaccion")):
		0;
		Date f= new Date();
		SimpleDateFormat formateador = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		String fecha = formateador.format(f);
		smsEnvioMensaje.setFechaProgEnvio(fecha);
		MensajeTransaccionBean mensaje = null;
		mensaje = smsEnvioMensajeServicio.grabaTransaccion(tipoTransaccion, smsEnvioMensaje, null, Constantes.STRING_VACIO, Constantes.STRING_VACIO);
		
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}
	
	public void setSmsEnvioMensajeServicio(SMSEnvioMensajeServicio smsEnvioMensajeServicio){
		this.smsEnvioMensajeServicio = smsEnvioMensajeServicio;
	}
}
