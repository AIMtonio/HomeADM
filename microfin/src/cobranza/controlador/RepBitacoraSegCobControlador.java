package cobranza.controlador;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import cobranza.bean.RepAsignaCarteraBean;
import cobranza.bean.RepBitacoraSegCobBean;

public class RepBitacoraSegCobControlador extends SimpleFormController{
	String nombreReporte = null;
	
	public RepBitacoraSegCobControlador(){
		setCommandClass(RepBitacoraSegCobBean.class);
 		setCommandName("repBitacoraSegCobBean");		
	}

 	protected ModelAndView onSubmit(HttpServletRequest request,
 									HttpServletResponse response,
 									Object command,
 									BindException errors) throws Exception {

 		RepBitacoraSegCobBean repBitacoraSegCobBean = (RepBitacoraSegCobBean) command;

 		String htmlString = ""; 		

 		return new ModelAndView(getSuccessView(), "reporte", htmlString);
 	}

	public String getNombreReporte() {
		return nombreReporte;
	}

	public void setNombreReporte(String nombreReporte) {
		this.nombreReporte = nombreReporte;
	}
}
