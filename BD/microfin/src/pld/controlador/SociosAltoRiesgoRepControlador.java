package pld.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import pld.bean.SociosAltoRiesgoRepBean;
import pld.servicio.SociosAltoRiesgoRepServicio;

public class SociosAltoRiesgoRepControlador extends SimpleFormController{
	

	private SociosAltoRiesgoRepServicio sociosAltoRiesgoRepServicio;
	
	public SociosAltoRiesgoRepControlador() {
		setCommandClass(SociosAltoRiesgoRepBean.class);
		setCommandName("sociosAltoRiesgoRepBean");
}
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
		
		sociosAltoRiesgoRepServicio.getSociosAltoRiesgoRepDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		
		SociosAltoRiesgoRepBean sociosAltoRiesgoRepBean = (SociosAltoRiesgoRepBean) command;
		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
		MensajeTransaccionBean mensaje = null;
																
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}
	public SociosAltoRiesgoRepServicio getSociosAltoRiesgoRepServicio() {
		return sociosAltoRiesgoRepServicio;
	}
	public void setSociosAltoRiesgoRepServicio(
			SociosAltoRiesgoRepServicio sociosAltoRiesgoRepServicio) {
		this.sociosAltoRiesgoRepServicio = sociosAltoRiesgoRepServicio;
	}
		
	
}
