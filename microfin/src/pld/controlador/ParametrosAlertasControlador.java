package pld.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import pld.bean.ParametrosAlertasBean;
import pld.servicio.ParametrosAlertasServicio;

public class ParametrosAlertasControlador extends SimpleFormController{
	
	ParametrosAlertasServicio parametrosAlertasServicio = null;

	public ParametrosAlertasControlador() {
		setCommandClass(ParametrosAlertasBean.class);
		setCommandName("alertasAutomaticas");
}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
		
		parametrosAlertasServicio.getParametrosAlertasDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		
		ParametrosAlertasBean parametrosAlertas = (ParametrosAlertasBean) command;
		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
		
		MensajeTransaccionBean mensaje = null;
		mensaje = parametrosAlertasServicio.grabaTransaccion(tipoTransaccion,parametrosAlertas);
										
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public void setParametrosAlertasServicio(
			ParametrosAlertasServicio parametrosAlertasServicio) {
		this.parametrosAlertasServicio = parametrosAlertasServicio;
	}
	
}

