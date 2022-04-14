package soporte.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import soporte.bean.UsuarioBean;
import soporte.servicio.UsuarioServicio;

public class CambioContraseniaUsuarioControlador extends SimpleFormController {

	UsuarioServicio usuarioServicio = null;
	
	public CambioContraseniaUsuarioControlador() {
		setCommandClass(UsuarioBean.class);
		setCommandName("cambioContraUsuario");

	}

	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse response,
									Object command,
									BindException errors) throws Exception {

		String confirmaContra = "";
		
		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
		confirmaContra = request.getParameter("Confirmacontra");
		//Confirmacontra
		
		UsuarioBean usuario = (UsuarioBean) command;
		
		usuario.setConfirmarContra(confirmaContra);
		MensajeTransaccionBean mensaje = null;
		usuario.setContrasenia(request.getParameter("nuevaContra"));
		mensaje = usuarioServicio.actualizaUsuario(tipoTransaccion, usuario);
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public void setUsuarioServicio(UsuarioServicio usuarioServicio) {
		this.usuarioServicio = usuarioServicio;
	}

	
	
}

