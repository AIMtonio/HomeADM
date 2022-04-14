package bancaMovil.controlador;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import bancaMovil.bean.BAMOperacionBean;
import bancaMovil.servicio.BAMUsuariosServicio;
import general.bean.MensajeTransaccionBean;

@SuppressWarnings("deprecation")
public class BAMBitacoraOperControlador extends SimpleFormController {

	BAMUsuariosServicio usuariosServicio = null;

	public BAMBitacoraOperControlador() {
		setCommandClass(BAMOperacionBean.class);
		setCommandName("operacionBean");
	}

	protected ModelAndView onSubmit(HttpServletRequest request, HttpServletResponse response, Object command,
			BindException errors) throws ServletException, IOException {

		MensajeTransaccionBean mensaje = null;

		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public BAMUsuariosServicio getUsuariosServicio() {
		return usuariosServicio;
	}

	public void setUsuariosServicio(BAMUsuariosServicio usuariosServicio) {
		this.usuariosServicio = usuariosServicio;
	}

}