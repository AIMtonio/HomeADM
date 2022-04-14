package soporte.controlador;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import general.bean.MensajeTransaccionBean;
import herramientas.Utileria;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import soporte.bean.UsuarioBean;
import soporte.servicio.UsuarioServicio;

public class checkInOutAnalistaControlador extends SimpleFormController {

	UsuarioServicio usuarioServicio = null;
	
	public checkInOutAnalistaControlador() {
		setCommandClass(UsuarioBean.class);
		setCommandName("usuario");
	}

	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse response,
									Object command,
									BindException errors) throws Exception {

		int tipoActualizacion = Utileria.convierteEntero(request.getParameter("tipoActualizacion"));
		UsuarioBean usuario = (UsuarioBean) command;
		String usu= usuario.getUsuarioID();
	
		MensajeTransaccionBean mensaje = null;

		mensaje = usuarioServicio.actualizaUsuario(tipoActualizacion, usuario);
						
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public void setUsuarioServicio(UsuarioServicio usuarioServicio) {
		this.usuarioServicio = usuarioServicio;
	}

	
	
}
