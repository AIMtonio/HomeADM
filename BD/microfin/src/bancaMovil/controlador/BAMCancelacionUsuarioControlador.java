package bancaMovil.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import bancaMovil.bean.BAMUsuariosBean;
import bancaMovil.servicio.BAMUsuariosServicio;

@SuppressWarnings("deprecation")
public class BAMCancelacionUsuarioControlador extends SimpleFormController {

	BAMUsuariosServicio usuariosServicio = null;
	
	public BAMCancelacionUsuarioControlador() {
		setCommandClass(BAMUsuariosBean.class);
		setCommandName("cancelaUsuario");
	}

	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse response,
									Object command,
									BindException errors) throws Exception {
		usuariosServicio.getBAMUsuariosDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
		BAMUsuariosBean usuario = (BAMUsuariosBean) command;
		MensajeTransaccionBean mensaje = null;
		mensaje = usuariosServicio.grabaTransaccion(tipoTransaccion, usuario);
								
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public BAMUsuariosServicio getUsuariosServicio() {
		return usuariosServicio;
	}

	public void setUsuariosServicio(BAMUsuariosServicio usuariosServicio) {
		this.usuariosServicio = usuariosServicio;
	}
	
}
	