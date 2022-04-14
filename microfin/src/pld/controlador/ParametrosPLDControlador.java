package pld.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import pld.bean.OpeInusualesBean;
import pld.bean.ParametrosAlertasBean;
import pld.bean.ParametrosPLDBean;
import pld.servicio.OpeInusualesServicio;
import pld.servicio.ParametrosAlertasServicio;
import pld.servicio.ParametrosPLDServicio;

public class ParametrosPLDControlador extends SimpleFormController{
	
	ParametrosPLDServicio parametrosPLDServicio = null;

	public ParametrosPLDControlador() {
		setCommandClass(ParametrosPLDBean.class);
		setCommandName("parametrosPLDBean");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
		
		parametrosPLDServicio.getParametrosPLDDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		
		ParametrosPLDBean parametrosPLDBean = (ParametrosPLDBean) command;
		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
		
		MensajeTransaccionBean mensaje = null;
		mensaje = parametrosPLDServicio.grabaTransaccion(tipoTransaccion,parametrosPLDBean);

		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public ParametrosPLDServicio getParametrosPLDServicio() {
		return parametrosPLDServicio;
	}

	public void setParametrosPLDServicio(ParametrosPLDServicio parametrosPLDServicio) {
		this.parametrosPLDServicio = parametrosPLDServicio;
	}
	
}

