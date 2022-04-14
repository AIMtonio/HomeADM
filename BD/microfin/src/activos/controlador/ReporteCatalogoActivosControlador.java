package activos.controlador;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import activos.bean.RepCatalogoActivosBean;

public class ReporteCatalogoActivosControlador extends SimpleFormController{

	public ReporteCatalogoActivosControlador(){
		setCommandClass(RepCatalogoActivosBean.class);
 		setCommandName("repCatalogoActivosBean");
		
	}

	protected ModelAndView onSubmit(HttpServletRequest request,
				HttpServletResponse response,
				Object command,
				BindException errors) throws Exception {

		RepCatalogoActivosBean repCatalogoActivosBean = (RepCatalogoActivosBean) command;
	
		String htmlString = ""; 		
	
		return new ModelAndView(getSuccessView(), "reporte", htmlString);
	}
}


