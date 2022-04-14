package sms.controlador;

import general.bean.MensajeTransaccionBean;
import herramientas.Constantes;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import sms.bean.SMSCondiciCargaBean;
import sms.bean.SMSEnvioMensajeBean;
import sms.servicio.SMSEnvioMensajeServicio;

public class SMSCancelarEnvioMensajeControlador extends SimpleFormController {

	SMSEnvioMensajeServicio smsEnvioMensajeServicio = null;
	
	public SMSCancelarEnvioMensajeControlador(){
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
		MensajeTransaccionBean mensaje = null;
		mensaje = smsEnvioMensajeServicio.grabaTransaccion(tipoTransaccion, smsEnvioMensaje, null,Constantes.STRING_VACIO,Constantes.STRING_VACIO);
	
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}
	
	public void setSmsEnvioMensajeServicio(SMSEnvioMensajeServicio smsEnvioMensajeServicio){
		this.smsEnvioMensajeServicio = smsEnvioMensajeServicio;
	}
}
