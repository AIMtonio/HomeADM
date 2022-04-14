package soporte.reporte;

import java.io.ByteArrayOutputStream;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import tesoreria.bean.ReferenciasPagosBean;
import tesoreria.servicio.ReferenciasPagosServicio;

public class ReporteRefPagoInstControlador extends AbstractCommandController{
	private ReferenciasPagosServicio referenciasPagosServicio = null;
	String nombreReporte = null;
	String successView = null;

	public static interface Enum_Rep_Ref{
		int reportePDF = 1;
	}
	
	public ReporteRefPagoInstControlador(){
		setCommandClass(ReferenciasPagosBean.class);
		setCommandName("referenciasPagosBean");
	}

	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
		
		ReferenciasPagosBean referenciasPagosBean =(ReferenciasPagosBean)command;
		
		referenciasPagosServicio.getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		String htmlString= "";
		
		ByteArrayOutputStream htmlStringPDF = repRefPagoInstPDF(referenciasPagosBean, nombreReporte, response);
		
		return null;
		
	}

	private ByteArrayOutputStream repRefPagoInstPDF(ReferenciasPagosBean referenciasPagosBean, String nombreReporte,
			HttpServletResponse response) {
		ByteArrayOutputStream htmlStringPDF = null;
		try {
			htmlStringPDF = referenciasPagosServicio.repRefPagoInstPDF(referenciasPagosBean, nombreReporte);
			response.addHeader("Content-Disposition","inline; filename=ReporRefPagoInst.pdf");
			response.setContentType("application/pdf");
			byte[] bytes = htmlStringPDF.toByteArray();
			response.getOutputStream().write(bytes,0,bytes.length);
			response.getOutputStream().flush();
			response.getOutputStream().close();
		} catch (Exception e) {
			e.printStackTrace();
		}		
		return htmlStringPDF;
	}

	public ReferenciasPagosServicio getReferenciasPagosServicio() {
		return referenciasPagosServicio;
	}

	public String getNombreReporte() {
		return nombreReporte;
	}

	public String getSuccessView() {
		return successView;
	}

	public void setReferenciasPagosServicio(
			ReferenciasPagosServicio referenciasPagosServicio) {
		this.referenciasPagosServicio = referenciasPagosServicio;
	}

	public void setNombreReporte(String nombreReporte) {
		this.nombreReporte = nombreReporte;
	}

	public void setSuccessView(String successView) {
		this.successView = successView;
	}
	

}
