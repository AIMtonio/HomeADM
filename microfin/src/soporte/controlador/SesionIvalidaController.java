package soporte.controlador;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;

public class SesionIvalidaController extends AbstractController{
	protected final Logger loggerSAFI = Logger.getLogger("SAFI");
	
	public SesionIvalidaController() {
		super();
		//TODO Auto-generated constructor stub
	}
	
	protected ModelAndView handleRequestInternal(
										HttpServletRequest request,
										HttpServletResponse response) throws Exception {		
		
		loggerSAFI.debug("Session Invalida");
		return new ModelAndView("soporte/sessionInvalida", "listaResultado", null);

	}

}
