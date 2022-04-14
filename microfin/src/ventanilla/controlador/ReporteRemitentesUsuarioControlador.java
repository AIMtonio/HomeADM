package ventanilla.controlador;

import general.bean.MensajeTransaccionBean;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import ventanilla.bean.ReporteRemitentesUsuarioBean;

public class ReporteRemitentesUsuarioControlador extends  SimpleFormController{
	
	public ReporteRemitentesUsuarioControlador(){
 		setCommandClass(ReporteRemitentesUsuarioBean.class);
 		setCommandName("reporteRemitentesUsuarioBean");
 	}

	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws ServletException, IOException  {
		
		ReporteRemitentesUsuarioBean reporteRemitentesUsuarioBean = (ReporteRemitentesUsuarioBean) command;	
 		MensajeTransaccionBean mensaje = null;
 
 		return new ModelAndView(getSuccessView(),"mensaje", mensaje);
		
	}

}
