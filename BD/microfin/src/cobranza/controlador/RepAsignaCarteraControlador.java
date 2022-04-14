package cobranza.controlador;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import cobranza.bean.RepAsignaCarteraBean;

public class RepAsignaCarteraControlador extends SimpleFormController {

	String nombreReporte = null;	

 	public RepAsignaCarteraControlador(){
 		setCommandClass(RepAsignaCarteraBean.class);
 		setCommandName("repAsignaCarteraBean");
 	}

 	protected ModelAndView onSubmit(HttpServletRequest request,
 									HttpServletResponse response,
 									Object command,
 									BindException errors) throws Exception {

 		RepAsignaCarteraBean repAsignaCarteraBean = (RepAsignaCarteraBean) command;

 		String htmlString = ""; 		

 		return new ModelAndView(getSuccessView(), "reporte", htmlString);
 	}

	public void setNombreReporte(String nombreReporte) {
		this.nombreReporte = nombreReporte;
	}
}
