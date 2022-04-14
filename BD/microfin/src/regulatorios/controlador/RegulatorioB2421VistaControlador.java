package regulatorios.controlador;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import regulatorios.bean.RegulatorioB2421Bean;

public class RegulatorioB2421VistaControlador extends SimpleFormController{
	String successView = null;		

 	public RegulatorioB2421VistaControlador(){
 		setCommandClass(RegulatorioB2421Bean.class);
 		setCommandName("regulatorioB2421Bean");
 	}

 	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
 		
 		return new ModelAndView(getSuccessView(), "mensaje", null);
 		
 	}
}
