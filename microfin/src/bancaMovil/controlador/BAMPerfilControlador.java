package bancaMovil.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import bancaMovil.bean.BAMPerfilBean;
import bancaMovil.servicio.BAMPerfilServicio;

@SuppressWarnings("deprecation")
public class BAMPerfilControlador extends SimpleFormController {

	BAMPerfilServicio perfilServicio = null;

	public BAMPerfilControlador() {
		setCommandClass(BAMPerfilBean.class);
		setCommandName("perfil");
	}

	protected ModelAndView onSubmit(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {
		perfilServicio.getPerfilDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		BAMPerfilBean perfil = (BAMPerfilBean) command;
		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
		MensajeTransaccionBean mensaje = perfilServicio.grabaTransaccion(tipoTransaccion, perfil);
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public BAMPerfilServicio getPerfilServicio() {
		return perfilServicio;
	}

	public void setPerfilServicio(BAMPerfilServicio perfilServicio) {
		this.perfilServicio = perfilServicio;
	}

}
