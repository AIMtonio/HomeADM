package contabilidad.reporte;

import java.io.ByteArrayOutputStream;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import contabilidad.bean.ReporteBalanzaContableBean;
import contabilidad.servicio.ReportesContablesServicio;

public class PantallaBalanzasContaRepControlador extends AbstractCommandController{
		
	public static interface Enum_Rep_BalanzaContable {
		int ReporPantalla = 1 ;
		int ReporPDF = 2 ;
		int ReporExcel = 3 ;
	}
	
	ReportesContablesServicio reportesContablesServicio = null;
	String nombreReporte = null;
	String successView = null;		   
	
	public PantallaBalanzasContaRepControlador() {
		setCommandClass(ReporteBalanzaContableBean.class);
		setCommandName("balanza");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {
		
		reportesContablesServicio.getParamGeneralesServicio().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		ReporteBalanzaContableBean reporteBalanzaContable = (ReporteBalanzaContableBean) command;
		int tipoReporte = (request.getParameter("tipoReporte") != null) ? Integer.parseInt(request.getParameter("tipoReporte")) : 0;
		int tipoLista = (request.getParameter("tipoLista") != null) ? Integer.parseInt(request.getParameter("tipoLista")) : 0;
 
		String htmlString = "";
		ByteArrayOutputStream byteArrayOutputStream = null;
		
		switch(tipoReporte){
			case Enum_Rep_BalanzaContable.ReporPantalla:
				 htmlString = reportesContablesServicio.reporteBalanzaComprobacion(reporteBalanzaContable, getNombreReporte()); 
			break;
			case Enum_Rep_BalanzaContable.ReporPDF:
				byteArrayOutputStream = reporteBalanzaComprobacionPDF(reporteBalanzaContable, getNombreReporte(), response);
			break;
			case Enum_Rep_BalanzaContable.ReporExcel:		
				 reportesContablesServicio.reporteBalanzaComprobacionExcel(tipoLista, reporteBalanzaContable, response);
			break;
		}
		
		if(tipoReporte == Enum_Rep_BalanzaContable.ReporPantalla ){
			return new ModelAndView(getSuccessView(), "reporte", htmlString);
		}else {
			return null;
		}
			
	}
	
	// Reporte  de balanza contable en PDF
	public ByteArrayOutputStream reporteBalanzaComprobacionPDF(ReporteBalanzaContableBean reporteBalanzaContable, String nomReporte, HttpServletResponse response){
		ByteArrayOutputStream byteArrayOutputStream = null;
		try {
			byteArrayOutputStream = reportesContablesServicio.reporteBalanzaComprobacionPDF(reporteBalanzaContable, nomReporte);
			response.addHeader("Content-Disposition","inline; filename=ReporteBalanza.pdf");
			response.setContentType("application/pdf");
			byte[] bytes = byteArrayOutputStream.toByteArray();
			response.getOutputStream().write(bytes,0,bytes.length);
			response.getOutputStream().flush();
			response.getOutputStream().close();
		} catch (Exception e) {

			e.printStackTrace();
		}
		return byteArrayOutputStream;
	}		

	public String getNombreReporte() {
		return nombreReporte;
	}

	public String getSuccessView() {
		return successView;
	}

	public void setReportesContablesServicio(
			ReportesContablesServicio reportesContablesServicio) {
		this.reportesContablesServicio = reportesContablesServicio;
	}

	public void setNombreReporte(String nombreReporte) {
		this.nombreReporte = nombreReporte;
	}

	public void setSuccessView(String successView) {
		this.successView = successView;
	}
}
