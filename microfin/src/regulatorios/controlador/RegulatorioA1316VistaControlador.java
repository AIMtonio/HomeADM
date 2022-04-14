package regulatorios.controlador;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import regulatorios.bean.RegulatorioA1316Bean;

public class RegulatorioA1316VistaControlador  extends SimpleFormController{
	String successView = null;		

 	public RegulatorioA1316VistaControlador(){
 		setCommandClass(RegulatorioA1316Bean.class);
 		setCommandName("regulatorioA1316Bean");
 	}

 	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
 		
 		return new ModelAndView(getSuccessView(), "mensaje", null);
 		
 	}
}
 