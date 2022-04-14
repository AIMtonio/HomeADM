package pld.reporte;
import herramientas.Utileria;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;


import pld.bean.OperAltoRiesgoBean;
import pld.servicio.OperAltoRiesgoServicio;

public class OperAltoRiesgoControlador extends SimpleFormController {
	
	OperAltoRiesgoServicio operAltoRiesgoServicio=null;
	String nombreReporte = null;
	
	public OperAltoRiesgoControlador() {
		setCommandClass(OperAltoRiesgoBean.class);
		setCommandName("opeAltoRiesgo");
	}
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {

	
	String htmlString = "";
	
	
		htmlString = operAltoRiesgoServicio.reporteOperAltoRiesgo(nombreReporte);

	return new ModelAndView(getSuccessView(), "reporte", htmlString);
	
}
	public void setNombreReporte(String nombreReporte) {
		this.nombreReporte = nombreReporte;
	}
	
	public void setOperAltoRiesgoServicio(OperAltoRiesgoServicio operAltoRiesgoServicio){
	   this.operAltoRiesgoServicio	= operAltoRiesgoServicio;
	}
	
}
