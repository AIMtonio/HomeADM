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

public class UsuarioControlador extends SimpleFormController {

	UsuarioServicio usuarioServicio = null;
	
	public UsuarioControlador() {
		setCommandClass(UsuarioBean.class);
		setCommandName("usuario");
	}

	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse response,
									Object command,
									BindException errors) throws Exception {
		int tipoTransaccion = Utileria.convierteEntero(request.getParameter("tipoTransaccion"));
		UsuarioBean usuario = (UsuarioBean) command;
		String usu= usuario.getUsuarioID();
	
		MensajeTransaccionBean mensaje = null;
		mensaje = usuarioServicio.grabaTransaccion(tipoTransaccion, usuario);
						
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public void setUsuarioServicio(UsuarioServicio usuarioServicio) {
		this.usuarioServicio = usuarioServicio;
	}

	
	
}
