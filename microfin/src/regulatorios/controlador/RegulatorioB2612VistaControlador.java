package regulatorios.controlador;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import regulatorios.bean.RegulatorioB2612Bean;

public class RegulatorioB2612VistaControlador extends SimpleFormController{
	String successView = null;		

 	public RegulatorioB2612VistaControlador(){
 		setCommandClass(RegulatorioB2612Bean.class);
 		setCommandName("regulatorioB2612Bean");
 	}

 	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
 		
 		return new ModelAndView(getSuccessView(), "mensaje", null);
 		
 	}
}
