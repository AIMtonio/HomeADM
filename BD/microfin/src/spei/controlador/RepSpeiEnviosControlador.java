package spei.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import spei.bean.RepSpeiEnviosBean;
import spei.servicio.RepSpeiEnviosServicio;

public class RepSpeiEnviosControlador extends SimpleFormController{
	RepSpeiEnviosServicio repSpeiEnviosServicio = null;
	
	public RepSpeiEnviosControlador() {
		setCommandClass(RepSpeiEnviosBean.class);
		setCommandName("repSpeiEnvios");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
	
		RepSpeiEnviosBean repConvenSecBean = (RepSpeiEnviosBean) command;
		MensajeTransaccionBean mensaje = null;
											
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public RepSpeiEnviosServicio getRepSpeiEnviosServicio() {
		return repSpeiEnviosServicio;
	}

	public void setRepSpeiEnviosServicio(RepSpeiEnviosServicio repSpeiEnviosServicio) {
		this.repSpeiEnviosServicio = repSpeiEnviosServicio;
	}
}