package regulatorios.controlador;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import regulatorios.bean.RegulatorioBean;

public class RegulatorioA2011VistaControlador extends SimpleFormController {
	String successView = null;		

 	public RegulatorioA2011VistaControlador(){
 		setCommandClass(RegulatorioBean.class);
 		setCommandName("regulatoriosContabilidadBean");
 	}

 	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
 		
 		return new ModelAndView(getSuccessView(), "mensaje", null);
 		
 	}
	
}
