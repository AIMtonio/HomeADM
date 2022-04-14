package contabilidad.controlador;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import contabilidad.bean.ReporteAnexoYFapBean;

public class ReporteAnexoYFapVistaControlador extends SimpleFormController{
	String successView = null;		

 	public ReporteAnexoYFapVistaControlador(){
 		setCommandClass(ReporteAnexoYFapBean.class);
 		setCommandName("reporteAnexoYFapBean");
 	}
 	
 	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
 		
 		return new ModelAndView(getSuccessView(), "mensaje", null);
 		
 	}
}
