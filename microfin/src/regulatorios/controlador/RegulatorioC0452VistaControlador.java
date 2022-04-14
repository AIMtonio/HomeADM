package regulatorios.controlador;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import regulatorios.bean.RegulatorioA2611Bean;
import regulatorios.bean.RegulatorioC0452Bean;

public class RegulatorioC0452VistaControlador extends SimpleFormController{
	String successView = null;		

 	public RegulatorioC0452VistaControlador(){
 		setCommandClass(RegulatorioC0452Bean.class);
 		setCommandName("regulatorioC0452Bean");
 	}

 	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
 		
 		return new ModelAndView(getSuccessView(), "mensaje", null);
 		
 	}
}
 