package regulatorios.controlador;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import regulatorios.bean.RegulatorioC2613Bean;

public class RegulatorioC2613VistaControlador extends SimpleFormController{
	String successView = null;		

 	public RegulatorioC2613VistaControlador(){
 		setCommandClass(RegulatorioC2613Bean.class);
 		setCommandName("regulatorioC2613Bean");
 	}

 	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
 		
 		return new ModelAndView(getSuccessView(), "mensaje", null);
 		
 	}
}
