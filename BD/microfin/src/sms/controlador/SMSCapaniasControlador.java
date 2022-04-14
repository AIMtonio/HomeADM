package sms.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import sms.bean.SMSCapaniasBean;
import sms.servicio.SMSCapaniasServicio;



public class SMSCapaniasControlador extends SimpleFormController {

	SMSCapaniasServicio smsCapaniasServicio = null;

	public SMSCapaniasControlador(){
		setCommandClass(SMSCapaniasBean.class);
		setCommandName("smsCapaniasBean");
	}

	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse response,
									Object command,
									BindException errors) throws Exception {

		SMSCapaniasBean smsCapanias = (SMSCapaniasBean) command;
		smsCapaniasServicio.getSmsCapaniasDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());

		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
					Integer.parseInt(request.getParameter("tipoTransaccion")):
				0;
					
		String codigosResp = request.getParameter("codigosRespuesta");
		MensajeTransaccionBean mensaje = null;
		mensaje = smsCapaniasServicio.grabaTransaccion(tipoTransaccion,smsCapanias,codigosResp);

		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public void setSmsCapaniasServicio(SMSCapaniasServicio smsCapaniasServicio) {
		this.smsCapaniasServicio = smsCapaniasServicio;
	}


} 
