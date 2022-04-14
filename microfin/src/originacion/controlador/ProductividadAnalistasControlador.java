package originacion.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import originacion.bean.AnalistasAsignacionBean;
import originacion.servicio.AnalistasAsignacionServicio;;

public class ProductividadAnalistasControlador extends SimpleFormController {

	AnalistasAsignacionServicio analistasAsignacionServicio = null;

	public ProductividadAnalistasControlador() {
		setCommandClass(AnalistasAsignacionBean.class);
		setCommandName("analistasAsignacionBean");
	}

	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response, Object command, BindException errors)
			throws Exception {
		MensajeTransaccionBean mensaje = null;

		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public AnalistasAsignacionServicio getAnalistasAsignacionServicio() {
		return analistasAsignacionServicio;
	}

	public void setAnalistasAsignacionServicio(AnalistasAsignacionServicio analistasAsignacionServicio) {
		this.analistasAsignacionServicio = analistasAsignacionServicio;
	}

}

