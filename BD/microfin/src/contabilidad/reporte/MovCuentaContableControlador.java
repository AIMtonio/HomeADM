
package contabilidad.reporte;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;


import contabilidad.bean.ReportesContablesBean;
import contabilidad.servicio.ReportesContablesServicio;

public class MovCuentaContableControlador  extends SimpleFormController{	

	
	ReportesContablesServicio reportesContablesServicio = null;
	String nombreReporte = null;   
	
	public MovCuentaContableControlador() {
		setCommandClass(ReportesContablesBean.class);
		setCommandName("reportesContables");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {

		ReportesContablesBean reportesContablesBean = (ReportesContablesBean) command;
		
		String htmlString = reportesContablesServicio.reportesMovCuentaContaPoliza(reportesContablesBean, nombreReporte);		
		
		
			

		return new ModelAndView(getSuccessView(), "reporte", htmlString);
		
	}


	public void setNombreReporte(String nombreReporte) {
		this.nombreReporte = nombreReporte;
	}

	public ReportesContablesServicio getReportesContablesServicio() {
		return reportesContablesServicio;
	}

	public void setReportesContablesServicio(
			ReportesContablesServicio reportesContablesServicio) {
		this.reportesContablesServicio = reportesContablesServicio;
	}


}