package credito.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import ventanilla.bean.DenominacionMovsBean;
import ventanilla.servicio.DenominacionMovsServicio;

public class CheckListIntegraECControlador extends SimpleFormController {
	public CheckListIntegraECControlador(){
		setCommandClass(DenominacionMovsBean.class);
		setCommandName("integraExpCredBean");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {
		return new ModelAndView("checkListIntegraEC.htm");
	}

		
	
	
}
