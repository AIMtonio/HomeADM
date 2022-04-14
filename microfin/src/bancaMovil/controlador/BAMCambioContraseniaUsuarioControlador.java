package bancaMovil.controlador;

import general.bean.MensajeTransaccionBean;
import herramientas.Utileria;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import bancaMovil.bean.BAMUsuariosBean;
import bancaMovil.servicio.BAMUsuariosServicio;

@SuppressWarnings("deprecation")
public class BAMCambioContraseniaUsuarioControlador extends SimpleFormController {

	BAMUsuariosServicio usuariosServicio = null;

	public BAMCambioContraseniaUsuarioControlador() {
		setCommandClass(BAMUsuariosBean.class);
		setCommandName("cambioContraUsuario");

	}

	protected ModelAndView onSubmit(HttpServletRequest request, HttpServletResponse response, Object command,
			BindException errors) throws Exception {
		
		usuariosServicio.getBAMUsuariosDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		BAMUsuariosBean usuario = (BAMUsuariosBean) command;
		MensajeTransaccionBean mensaje = null;
		String tipoTransaccion = request.getParameter("tipoTransaccion");
		mensaje = usuariosServicio.grabaTransaccion(Utileria.convierteEntero(tipoTransaccion), usuario);
		
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public BAMUsuariosServicio getUsuariosServicio() {
		return usuariosServicio;
	}

	public void setUsuariosServicio(BAMUsuariosServicio usuariosServicio) {
		this.usuariosServicio = usuariosServicio;
	}

}
