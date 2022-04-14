package regulatorios.controlador;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import regulatorios.bean.CarteraPorTipoA0411Bean;

public class CarteraporTipoA0411Controlador extends SimpleFormController{
	String successView = null;		

 	public CarteraporTipoA0411Controlador(){
 		setCommandClass(CarteraPorTipoA0411Bean.class);
 		setCommandName("carteraPorTipoA0411Bean");
 	}

 	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
 		
 		return new ModelAndView(getSuccessView(), "mensaje", null);
 		
 	}
}
