package soporte.controlador;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;

public class OlvidoUsuarioControlador extends AbstractController{


	protected ModelAndView handleRequestInternal(HttpServletRequest request,
			 HttpServletResponse response)
	throws Exception {

		return new ModelAndView("soporte/olvidoUsuario", "null", null);
	}

	
	
}
