package regulatorios.controlador;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import regulatorios.bean.RegulatorioA3011Bean;

public class RegulatorioA3011VistaControlador  extends SimpleFormController {
	String successView = null;		

 	public RegulatorioA3011VistaControlador(){
 		setCommandClass(RegulatorioA3011Bean.class);
 		setCommandName("regulatorioA3011Bean");
 	}

 	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
 		
 		return new ModelAndView(getSuccessView(), "mensaje", null);
 		
 	}
}
