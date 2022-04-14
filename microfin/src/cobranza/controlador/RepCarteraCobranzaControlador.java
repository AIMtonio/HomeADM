package cobranza.controlador;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import cobranza.bean.RepCarteraCobranzaBean;


public class RepCarteraCobranzaControlador  extends SimpleFormController {

	String nombreReporte = null;	

 	public RepCarteraCobranzaControlador(){
 		setCommandClass(RepCarteraCobranzaBean.class);
 		setCommandName("repCarteraCobranza");
 	}

 	protected ModelAndView onSubmit(HttpServletRequest request,
 									HttpServletResponse response,
 									Object command,
 									BindException errors) throws Exception {

 		RepCarteraCobranzaBean repCarteraCobranza = (RepCarteraCobranzaBean) command;

 		String htmlString = ""; 		

 		return new ModelAndView(getSuccessView(), "reporte", htmlString);
 	}

	public void setNombreReporte(String nombreReporte) {
		this.nombreReporte = nombreReporte;
	}
}
