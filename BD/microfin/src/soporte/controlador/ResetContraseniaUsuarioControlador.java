package soporte.controlador;

import general.bean.MensajeTransaccionBean;
import herramientas.Utileria;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import soporte.bean.UsuarioBean;
import soporte.servicio.UsuarioServicio;

public class ResetContraseniaUsuarioControlador extends SimpleFormController {

	UsuarioServicio usuarioServicio = null;
	
	public ResetContraseniaUsuarioControlador() {
		setCommandClass(UsuarioBean.class);
		setCommandName("resetContraUsuario");

	}

	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse response,
									Object command,
									BindException errors) throws Exception {

		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
		
		UsuarioBean usuario = (UsuarioBean) command;
		MensajeTransaccionBean mensaje = null;
		
		mensaje = usuarioServicio.actualizaUsuario(tipoTransaccion, usuario);
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public void setUsuarioServicio(UsuarioServicio usuarioServicio) {
		this.usuarioServicio = usuarioServicio;
	}

	
	
}

