package ventanilla.controlador;

import general.bean.MensajeTransaccionBean;
import herramientas.Utileria;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import soporte.servicio.CorreoServicio;
import ventanilla.bean.UsuarioServiciosBean;
import ventanilla.servicio.UsuarioServiciosServicio;

public class UsuarioServiciosControlador extends SimpleFormController {
	UsuarioServiciosServicio	usuarioServiciosServicio	= null;
	private CorreoServicio		correoServicio				= null;
	
	public UsuarioServiciosControlador() {
		setCommandClass(UsuarioServiciosBean.class);
		setCommandName("usuarioServiciosBean");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {
		MensajeTransaccionBean mensaje = null;
		try {
			usuarioServiciosServicio.getUsuarioServiciosDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
			
			UsuarioServiciosBean usuarioServiciosBean = (UsuarioServiciosBean) command;
			int tipoTransaccion = Utileria.convierteEntero(request.getParameter("tipoTransaccion"));
			int tipoActualizacion = Utileria.convierteEntero(request.getParameter("tipoActualizacion"));
			
			mensaje = usuarioServiciosServicio.grabaTransaccion(tipoTransaccion, tipoActualizacion, usuarioServiciosBean);
			
			try {
				correoServicio.EjecutaEnvioCorreo();//Ejecuta el envio de correo
			} catch (Exception exa) {
				exa.printStackTrace();
			}
		} catch (Exception ex) {
			ex.printStackTrace();
			if (mensaje == null) {
				mensaje = new MensajeTransaccionBean();
			}
			if (mensaje.getDescripcion() != null && mensaje.getDescripcion().isEmpty()) {
				mensaje.setDescripcion("Error al grabar la Transacción");
			}
			mensaje.setNumero(999);
		}
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}
	
	public UsuarioServiciosServicio getUsuarioServiciosServicio() {
		return usuarioServiciosServicio;
	}
	
	public void setUsuarioServiciosServicio(
			UsuarioServiciosServicio usuarioServiciosServicio) {
		this.usuarioServiciosServicio = usuarioServiciosServicio;
	}
	
	public CorreoServicio getCorreoServicio() {
		return correoServicio;
	}
	
	public void setCorreoServicio(CorreoServicio correoServicio) {
		this.correoServicio = correoServicio;
	}
	
}
