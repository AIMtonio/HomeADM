package regulatorios.controlador;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import regulatorios.bean.RegulatorioA1012Bean;


public class RegulatorioA1012VistaControlador  extends SimpleFormController{
	String successView = null;		

 	public RegulatorioA1012VistaControlador(){
 		setCommandClass(RegulatorioA1012Bean.class);
 		setCommandName("regulatorioA1012Bean");
 	}
 	
 	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
 		
 		return new ModelAndView(getSuccessView(), "mensaje", null);
 		
 	}
}
