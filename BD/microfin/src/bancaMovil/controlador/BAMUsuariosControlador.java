package bancaMovil.controlador;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import bancaMovil.bean.BAMUsuariosBean;
import bancaMovil.servicio.BAMUsuariosServicio;
import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;

@SuppressWarnings("deprecation")
public class BAMUsuariosControlador extends SimpleFormController {
	BAMUsuariosServicio usuariosServicio = null;

	public BAMUsuariosControlador() {
		setCommandClass(BAMUsuariosBean.class);
		setCommandName("bloDesUsuario");
	}

	protected ModelAndView onSubmit(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {

		usuariosServicio.getBAMUsuariosDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());

		BAMUsuariosBean usuarios = (BAMUsuariosBean) command;

		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
		MensajeTransaccionBean mensaje = usuariosServicio.grabaTransaccion(tipoTransaccion, usuarios);

		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public void setBAMUsuariosServicio(BAMUsuariosServicio usuariosServicio) {
		this.usuariosServicio = usuariosServicio;
	}

	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
	}

	public BAMUsuariosServicio getUsuariosServicio() {
		return usuariosServicio;
	}

	public void setUsuariosServicio(BAMUsuariosServicio usuariosServicio) {
		this.usuariosServicio = usuariosServicio;
	}
}
