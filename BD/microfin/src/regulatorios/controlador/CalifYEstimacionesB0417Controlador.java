package regulatorios.controlador;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import regulatorios.bean.CalificacionYEstimacionB0417Bean;

public class CalifYEstimacionesB0417Controlador extends SimpleFormController {

	String successView = null;		

 	public CalifYEstimacionesB0417Controlador(){
 		setCommandClass(CalificacionYEstimacionB0417Bean.class);
 		setCommandName("calificacionYEstimacionB0417Bean");
 	}

 	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
 		
 		return new ModelAndView(getSuccessView(), "mensaje", null);
 	}

	
}
