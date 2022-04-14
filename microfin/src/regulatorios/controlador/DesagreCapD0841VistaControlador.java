package regulatorios.controlador;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;
import regulatorios.bean.DesagreCaptaD0841Bean;

public class DesagreCapD0841VistaControlador extends SimpleFormController {

	String successView = null;		

 	public DesagreCapD0841VistaControlador(){
 		setCommandClass(DesagreCaptaD0841Bean.class);
 		setCommandName("desagreCaptaD0841Bean");
 	}

 	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
 		
 		return new ModelAndView(getSuccessView(), "mensaje", null);
 		
 	}
}