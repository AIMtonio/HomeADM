package contabilidad.reporte;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import contabilidad.bean.ReportePolizaBean;
import contabilidad.servicio.PolizaServicio;

public class PantallaPolizaRepControlador extends SimpleFormController {

	PolizaServicio polizaServicio = null;
	String nombreReporte = null;
	

 	public PantallaPolizaRepControlador(){
 		setCommandClass(ReportePolizaBean.class);
 		setCommandName("reportePoliza");
 	}

 	protected ModelAndView onSubmit(HttpServletRequest request,
 									HttpServletResponse response,
 									Object command,
 									BindException errors) throws Exception {

 		ReportePolizaBean reportePolizaBean = (ReportePolizaBean) command;
 		String htmlString = polizaServicio.reportePoliza(reportePolizaBean, nombreReporte); 		 		

 		return new ModelAndView(getSuccessView(), "reporte", htmlString);
 	}
 	
	public void setPolizaServicio(PolizaServicio polizaServicio) {
		this.polizaServicio = polizaServicio;
	}

	public void setNombreReporte(String nombreReporte) {
		this.nombreReporte = nombreReporte;
	}

}
