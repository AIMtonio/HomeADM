package cobranza.controlador;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import cobranza.bean.RepLiberaCarteraBean;

public class RepLiberaCarteraControlador extends SimpleFormController {

	String nombreReporte = null;	

 	public RepLiberaCarteraControlador(){
 		setCommandClass(RepLiberaCarteraBean.class);
 		setCommandName("repLiberaCarteraBean");
 	}

 	protected ModelAndView onSubmit(HttpServletRequest request,
 									HttpServletResponse response,
 									Object command,
 									BindException errors) throws Exception {

 		RepLiberaCarteraBean repLiberaCarteraBean = (RepLiberaCarteraBean) command;

 		String htmlString = ""; 		

 		return new ModelAndView(getSuccessView(), "reporte", htmlString);
 	}

	public void setNombreReporte(String nombreReporte) {
		this.nombreReporte = nombreReporte;
	}
}
