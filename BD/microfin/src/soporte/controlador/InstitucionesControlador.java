package soporte.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import soporte.bean.InstitucionesBean;
import soporte.servicio.InstitucionesServicio;

public class InstitucionesControlador extends SimpleFormController{
	
	InstitucionesServicio institucionesServicio = null;
	
	public InstitucionesControlador() {
		setCommandClass(InstitucionesBean.class);
		setCommandName("instituciones");
	}
		
	
	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse response,
									Object command,
									BindException errors) throws Exception {
		
		InstitucionesBean institucion = (InstitucionesBean) command;
		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
	
		
		MensajeTransaccionBean mensaje = null;
		mensaje = institucionesServicio.grabaTransaccion(tipoTransaccion,institucion);
																
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public void setInstitucionesServicio(InstitucionesServicio institucionesServicio) {
		this.institucionesServicio = institucionesServicio;
	}
	

}
