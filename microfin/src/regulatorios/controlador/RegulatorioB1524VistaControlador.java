package regulatorios.controlador;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import regulatorios.bean.RegulatorioB1524Bean;

public class RegulatorioB1524VistaControlador extends SimpleFormController{
	String successView = null;		

 	public RegulatorioB1524VistaControlador(){
 		setCommandClass(RegulatorioB1524Bean.class);
 		setCommandName("regulatorioB1524Bean");
 	}

 	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
 		
 		return new ModelAndView(getSuccessView(), "mensaje", null);
 		
 	}
}
