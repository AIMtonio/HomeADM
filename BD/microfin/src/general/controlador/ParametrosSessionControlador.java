package general.controlador;

import general.bean.ParametrosSesionBean;
import general.servicio.ParametrosAplicacionServicio;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

public class ParametrosSessionControlador extends AbstractCommandController{
	ParametrosAplicacionServicio parametrosAplicacionServicio = null;
	public static ParametrosSesionBean parametrosSesionBean;

	String successView = null;
	
	public ParametrosSessionControlador() {
		setCommandClass(ParametrosSesionBean.class);
		setCommandName("parametrosSesion");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {
		
		return new ModelAndView(getSuccessView(), "parametrosSession", parametrosAplicacionServicio.consultaParametrosSessionLocal());
		
	}
	
	// ---------------------------- Setters y Getters -------------------------------------------------------
	public void setSuccessView(String successView) {
		this.successView = successView;
	}
	private String getSuccessView() {
		return successView;
	}

	public void setParametrosAplicacionServicio(
			ParametrosAplicacionServicio parametrosAplicacionServicio) {
		this.parametrosAplicacionServicio = parametrosAplicacionServicio;
	}
	
	public ParametrosSesionBean getParametrosSesionBean() {
		return parametrosSesionBean;
	}

	public void setParametrosSesionBean(
			ParametrosSesionBean parametrosSesionBean) {
		ParametrosSessionControlador.parametrosSesionBean = parametrosSesionBean;
	}

	
}
