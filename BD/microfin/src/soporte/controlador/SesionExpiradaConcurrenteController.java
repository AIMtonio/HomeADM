package soporte.controlador;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;

public class SesionExpiradaConcurrenteController extends AbstractController{
	
	
	public SesionExpiradaConcurrenteController() {
		super();
		//TODO Auto-generated constructor stub
	}
	
	protected ModelAndView handleRequestInternal(HttpServletRequest request,
			 HttpServletResponse response)
			throws Exception {
				
		return new ModelAndView("soporte/sesionExpiradaConcurrenteVista", "listaResultado", null);

	}

}
