package regulatorios.controlador;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import regulatorios.bean.RegulatorioB1522Bean;

public class RegulatorioB1522VistaControlador extends SimpleFormController{
	String successView = null;		

 	public RegulatorioB1522VistaControlador(){
 		setCommandClass(RegulatorioB1522Bean.class);
 		setCommandName("regulatorioB1522Bean");
 	}

 	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
 		
 		return new ModelAndView(getSuccessView(), "mensaje", null);
 		
 	}
}
