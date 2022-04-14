package contabilidad.reporte;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import contabilidad.bean.ReportesContablesBean;
import contabilidad.servicio.ReportesContablesServicio;

public class BalanzasContablesRepControlador extends AbstractCommandController{
	
	ReportesContablesServicio reportesContablesServicio = null;
	String nombreReporte = null;
	String successView = null;		   
	
	public BalanzasContablesRepControlador() {
		setCommandClass(ReportesContablesBean.class);
		setCommandName("reportesContables");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {

		ReportesContablesBean reportesContablesBean = (ReportesContablesBean) command;
		String htmlString = reportesContablesServicio.reportesContablesCuenta(reportesContablesBean, getNombreReporte());		
		
		return new ModelAndView(getSuccessView(), "reporte", htmlString);
		
	}

	public String getNombreReporte() {
		return nombreReporte;
	}

	public void setNombreReporte(String nombreReporte) {
		this.nombreReporte = nombreReporte;
	}

	public String getSuccessView() {
		return successView;
	}

	public void setSuccessView(String successView) {
		this.successView = successView;
	}

	public void setReportesContablesServicio(
			ReportesContablesServicio reportesContablesServicio) {
		this.reportesContablesServicio = reportesContablesServicio;
	}	
}
