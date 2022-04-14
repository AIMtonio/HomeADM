package regulatorios.controlador;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import regulatorios.bean.RegulatorioB1523Bean;

public class RegulatorioB1523VistaControlador extends SimpleFormController{
	String successView = null;		

 	public RegulatorioB1523VistaControlador(){
 		setCommandClass(RegulatorioB1523Bean.class);
 		setCommandName("regulatorioB1523Bean");
 	}

 	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
 		
 		return new ModelAndView(getSuccessView(), "mensaje", null);
 		
 	}
}
