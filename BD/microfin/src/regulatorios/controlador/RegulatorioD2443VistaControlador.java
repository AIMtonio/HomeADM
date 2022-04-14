package regulatorios.controlador;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import regulatorios.bean.RegulatorioD2443Bean;

public class RegulatorioD2443VistaControlador extends SimpleFormController{
	String successView = null;		

 	public RegulatorioD2443VistaControlador(){
 		setCommandClass(RegulatorioD2443Bean.class);
 		setCommandName("regulatorioD2443Bean");
 	}

 	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
 		
 		return new ModelAndView(getSuccessView(), "mensaje", null);
 		
 	}
}
