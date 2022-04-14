package contabilidad.reporte;
import java.io.ByteArrayOutputStream;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import contabilidad.bean.ReportePolizaBean;
import contabilidad.servicio.PolizaServicio;


public class PolizaRepControlador extends AbstractCommandController {

	PolizaServicio polizaServicio = null;
	String nombreReporte = null;
	String successView = null;		 

 	public PolizaRepControlador(){
 		setCommandClass(ReportePolizaBean.class);
 		setCommandName("reportePoliza");
 	}

 	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {

 		ReportePolizaBean reportePolizaBean = (ReportePolizaBean) command;
 		
 		
		ByteArrayOutputStream htmlStringPDF = polizaServicio.reportePolizaPDF(reportePolizaBean, nombreReporte);
		response.setContentType("application/pdf");
 		response.addHeader("Content-Disposition", "inline; filename=PolizaContable.pdf");
		
		
		byte[] bytes = htmlStringPDF.toByteArray();
		response.getOutputStream().write(bytes,0,bytes.length);
		response.getOutputStream().flush();
		response.getOutputStream().close();

		return null;	
 	}
		
	public void setPolizaServicio(PolizaServicio polizaServicio) {
		this.polizaServicio = polizaServicio;
	}
	
	public void setNombreReporte(String nombreReporte) {
		this.nombreReporte = nombreReporte;
	}

	public void setSuccessView(String successView) {
		this.successView = successView;
	}
	private String getSuccessView() {
		return successView;
	}

}
