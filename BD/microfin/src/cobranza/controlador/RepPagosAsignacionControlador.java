package cobranza.controlador;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import cobranza.bean.RepPagosAsignacionBean;

public class RepPagosAsignacionControlador extends SimpleFormController{

	public RepPagosAsignacionControlador(){
	 		setCommandClass(RepPagosAsignacionBean.class);
	 		setCommandName("repPagosAsignacionBean");
	 	}

	 	protected ModelAndView onSubmit(HttpServletRequest request,
 									HttpServletResponse response,
 									Object command,
 									BindException errors) throws Exception {

 		RepPagosAsignacionBean repPagosAsignacionBean = (RepPagosAsignacionBean) command;

 		String htmlString = ""; 		

 		return new ModelAndView(getSuccessView(), "reporte", htmlString);
 	}
}
