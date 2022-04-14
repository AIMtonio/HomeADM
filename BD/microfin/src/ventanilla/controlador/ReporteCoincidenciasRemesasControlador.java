package ventanilla.controlador;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import general.bean.MensajeTransaccionBean;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import ventanilla.bean.ReporteCoincidenciasRemesasBean;

public class ReporteCoincidenciasRemesasControlador extends  SimpleFormController{
	
	public ReporteCoincidenciasRemesasControlador(){
 		setCommandClass(ReporteCoincidenciasRemesasBean.class);
 		setCommandName("reporteCoincidenciasRemesasBean");
 	}

	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws ServletException, IOException  {
		
		ReporteCoincidenciasRemesasBean reporteCoincidenciasRemesasBean = (ReporteCoincidenciasRemesasBean) command;	
 		MensajeTransaccionBean mensaje = null;
 
 		return new ModelAndView(getSuccessView(),"mensaje", mensaje);
		
	}

}
