package crowdfunding.controlador;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import general.bean.MensajeTransaccionBean;
import crowdfunding.servicio.GuiaContableCRWServicio;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

public class GuiaContableCRWControlador extends SimpleFormController{

	GuiaContableCRWServicio guiaContableCRWServicio = null;

	public GuiaContableCRWControlador() {
		setCommandClass(Object.class);
		setCommandName("CRW");
	}

	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
		MensajeTransaccionBean mensaje = null;
		mensaje = guiaContableCRWServicio.grabaTransaccion(request);
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public GuiaContableCRWServicio getGuiaContableCRWServicio() {
		return guiaContableCRWServicio;
	}

	public void setGuiaContableCRWServicio(
			GuiaContableCRWServicio guiaContableCRWServicio) {
		this.guiaContableCRWServicio = guiaContableCRWServicio;
	}
}