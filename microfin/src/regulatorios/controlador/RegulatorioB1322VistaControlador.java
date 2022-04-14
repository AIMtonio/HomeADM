package regulatorios.controlador;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import regulatorios.bean.RegulatorioB1322Bean;


public class RegulatorioB1322VistaControlador extends SimpleFormController {
	
	String successView = null;
	
	public RegulatorioB1322VistaControlador(){
 		setCommandClass(RegulatorioB1322Bean.class);
 		setCommandName("regulatorioB1322Bean");
 	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
 		
 		return new ModelAndView(getSuccessView(), "mensaje", null);
 		
 	}
}
