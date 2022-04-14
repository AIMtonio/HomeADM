package activos.controlador;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import activos.bean.RepDepAmortizaActivosBean;

public class ReporteDepAmortizaActivosControlador extends SimpleFormController{

	public ReporteDepAmortizaActivosControlador(){
		setCommandClass(RepDepAmortizaActivosBean.class);
 		setCommandName("repDepAmortizaActivosBean");
		
	}

	protected ModelAndView onSubmit(HttpServletRequest request,
				HttpServletResponse response,
				Object command,
				BindException errors) throws Exception {

		RepDepAmortizaActivosBean repDepAmortizaActivosBean = (RepDepAmortizaActivosBean) command;
	
		String htmlString = ""; 		
	
		return new ModelAndView(getSuccessView(), "reporte", htmlString);
	}
}


