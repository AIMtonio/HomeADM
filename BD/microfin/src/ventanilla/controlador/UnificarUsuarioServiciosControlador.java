package ventanilla.controlador;

import general.bean.MensajeTransaccionBean;
import herramientas.Utileria;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import ventanilla.bean.UsuarioServiciosBean;
import ventanilla.servicio.UsuarioServiciosServicio;

public class UnificarUsuarioServiciosControlador extends SimpleFormController {

	UsuarioServiciosServicio usuarioServiciosServicio = null;

	public UnificarUsuarioServiciosControlador() {
		setCommandClass(UsuarioServiciosBean.class);
		setCommandName("usuarioServiciosBean");
	}

	protected ModelAndView onSubmit(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {

		usuarioServiciosServicio.getUsuarioServiciosDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());

		UsuarioServiciosBean usuarioServiciosBean = (UsuarioServiciosBean) command;

		int tipoTransaccion = (Utileria.esNumero(request.getParameter("tipoTransaccion"))) ? Utileria.convierteEntero(request.getParameter("tipoTransaccion")) : 0;
		int tipoActualizacion = (Utileria.esNumero(request.getParameter("tipoActualizacion"))) ? Utileria.convierteEntero(request.getParameter("tipoActualizacion")) : 0;

		MensajeTransaccionBean mensaje = usuarioServiciosServicio.grabaTransaccion(tipoTransaccion, tipoActualizacion, usuarioServiciosBean);

		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public UsuarioServiciosServicio getUsuarioServiciosServicio() {
		return usuarioServiciosServicio;
	}

	public void setUsuarioServiciosServicio(UsuarioServiciosServicio usuarioServiciosServicio) {
		this.usuarioServiciosServicio = usuarioServiciosServicio;
	}
}
