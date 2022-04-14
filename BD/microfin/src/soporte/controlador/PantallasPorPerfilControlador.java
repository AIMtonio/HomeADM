package soporte.controlador;

import general.bean.MensajeTransaccionBean;
import herramientas.Utileria;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import soporte.bean.OpcionesRolBean;
import soporte.bean.RolesBean;
import soporte.bean.UsuarioBean;
import soporte.servicio.OpcionesRolServicio;
import soporte.servicio.RolesServicio;
import soporte.servicio.UsuarioServicio;

public class PantallasPorPerfilControlador extends SimpleFormController {

	OpcionesRolServicio opcionesRolServicio = null;
	
	public PantallasPorPerfilControlador() {
		setCommandClass(OpcionesRolBean.class);
		setCommandName("opcionesRol");
	}

	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse response,
									Object command,
									BindException errors) throws Exception {
		
		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
		String cadena = request.getParameter("cadenaPant");
		OpcionesRolBean rol = (OpcionesRolBean) command;
		
		MensajeTransaccionBean mensaje = null;
		mensaje = opcionesRolServicio.grabaListaRoles(tipoTransaccion, rol,cadena);
								
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public void setOpcionesRolServicio(OpcionesRolServicio opcionesRolServicio) {
		this.opcionesRolServicio = opcionesRolServicio;
	}
	
	
}

