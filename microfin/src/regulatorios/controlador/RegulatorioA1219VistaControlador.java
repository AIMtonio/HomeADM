package regulatorios.controlador;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import regulatorios.bean.RegulatorioA1219Bean;

public class RegulatorioA1219VistaControlador extends SimpleFormController{
	String successView = null;		

 	public RegulatorioA1219VistaControlador(){
 		setCommandClass(RegulatorioA1219Bean.class);
 		setCommandName("regulatorioA1219Bean");
 	}

 	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
 		
 		return new ModelAndView(getSuccessView(), "mensaje", null);
 		
 	}
}
