package ventanilla.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import ventanilla.bean.DenominacionMovsBean;
import ventanilla.servicio.DenominacionMovsServicio;

public class DenominacionMovsControlador extends SimpleFormController {
	DenominacionMovsServicio denominacionMovsServicio = null;
	public DenominacionMovsControlador(){
		setCommandClass(DenominacionMovsBean.class);
		setCommandName("denominacionMovsBean");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {
		return new ModelAndView("denominacionMovsRep.htm");
	}

	public DenominacionMovsServicio getDenominacionMovsServicio() {
		return denominacionMovsServicio;
	}

	public void setDenominacionMovsServicio(
			DenominacionMovsServicio denominacionMovsServicio) {
		this.denominacionMovsServicio = denominacionMovsServicio;
	}

	
	
	
}
