package soporte.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import soporte.bean.RolesBean;
import soporte.servicio.RolesServicio;



public class RolesControlador extends SimpleFormController {

	RolesServicio rolesServicio = null;
	
	public RolesControlador() {
		setCommandClass(RolesBean.class);
		setCommandName("roles");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse response,
									Object command,							
									BindException errors) throws Exception {
		
		
		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
		RolesBean roles = (RolesBean) command;
		MensajeTransaccionBean mensaje = null;
		mensaje = rolesServicio.grabaTransaccion(tipoTransaccion,roles);
								
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public void setRolesServicio(RolesServicio rolesServicio) {
		this.rolesServicio = rolesServicio;
	}

	
		
}
