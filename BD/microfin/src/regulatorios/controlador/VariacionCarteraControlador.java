package regulatorios.controlador;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import regulatorios.bean.VariacionCarteraBean;


public class VariacionCarteraControlador  extends SimpleFormController {
	String successView = null;		

 	public VariacionCarteraControlador(){
 		setCommandClass(VariacionCarteraBean.class);
 		setCommandName("variacionCarteraBean");
 	}
 	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
 		
 		return new ModelAndView(getSuccessView(), "mensaje", null);
 		
 	}
}
