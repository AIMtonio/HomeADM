package sms.controlador;

import general.bean.MensajeTransaccionBean;
import herramientas.Constantes;

import java.text.SimpleDateFormat;
import java.util.Date;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import sms.bean.SMSPlantillaBean;
import sms.servicio.SMSPlantillaServicio;

public class SMSPlantillaControlador extends SimpleFormController {

	SMSPlantillaServicio smsPlantillaServicio = null;
	
	public SMSPlantillaControlador(){
		setCommandClass(SMSPlantillaBean.class);
		setCommandName("smsPlantillaBean");
	}
	protected ModelAndView onSubmit(HttpServletRequest request,
					HttpServletResponse response,
					Object command,
					BindException errors) throws Exception{
		
		SMSPlantillaBean smsPlantilla = (SMSPlantillaBean) command;

		smsPlantillaServicio.getSmsPlantillaDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		int tipoTransaccion = (request.getParameter("tipoTransaccion") != null)?
		Integer.parseInt(request.getParameter("tipoTransaccion")):
		0;

		MensajeTransaccionBean mensaje = null;
		mensaje = smsPlantillaServicio.grabaTransaccion(tipoTransaccion, smsPlantilla );

		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}
	public SMSPlantillaServicio getSmsPlantillaServicio() {
		return smsPlantillaServicio;
	}
	public void setSmsPlantillaServicio(SMSPlantillaServicio smsPlantillaServicio) {
		this.smsPlantillaServicio = smsPlantillaServicio;
	}

}
