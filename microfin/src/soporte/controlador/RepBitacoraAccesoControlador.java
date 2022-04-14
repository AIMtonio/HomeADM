package soporte.controlador;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import cobranza.bean.RepBitacoraSegCobBean;

import soporte.bean.RepBitacoraAccesoBean;

public class RepBitacoraAccesoControlador extends SimpleFormController{
	String nombreReporte = null;
	
	public RepBitacoraAccesoControlador(){
		setCommandClass(RepBitacoraAccesoBean.class);
 		setCommandName("repBitacoraAccesoBean");
		
	}

 	protected ModelAndView onSubmit(HttpServletRequest request,
 									HttpServletResponse response,
 									Object command,
 									BindException errors) throws Exception {

 		RepBitacoraAccesoBean repBitacoraSegCobBean = (RepBitacoraAccesoBean) command;

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
