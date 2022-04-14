package regulatorios.controlador;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import regulatorios.bean.RegulatorioA2111Bean;

public class RegulatorioA2111VistaControlador extends SimpleFormController{
	String successView = null;		

 	public RegulatorioA2111VistaControlador(){
 		setCommandClass(RegulatorioA2111Bean.class);
 		setCommandName("regulatorioA2111Bean");
 	}

 	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
 		
 		return new ModelAndView(getSuccessView(), "mensaje", null);
 		
 	}
}
