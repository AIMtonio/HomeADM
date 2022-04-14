package soporte.reporte;

import java.io.ByteArrayOutputStream;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import soporte.bean.RepBitacoraAccesoBean;
import soporte.servicio.BitacoraAccesoServicio;

import cobranza.bean.RepBitacoraSegCobBean;

public class ReporteBitacoraAccesoControlador extends AbstractCommandController{
	BitacoraAccesoServicio bitacoraAccesoServicio = null;
	String nombreReporte = null;
	String successView = null;

	public static interface Enum_Rep_BitAcceso{
		int reportePDF = 1;
	}
	
	public ReporteBitacoraAccesoControlador(){
		setCommandClass(RepBitacoraAccesoBean.class);
 		setCommandName("repBitacoraAccesoBean");			
	}

	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
		
		RepBitacoraAccesoBean repBitacoraAccesoBean = (RepBitacoraAccesoBean)command;
		
		bitacoraAccesoServicio.getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		String htmlString= "";
		
		ByteArrayOutputStream htmlStringPDF = repBitAccesoPDF(repBitacoraAccesoBean, nombreReporte, response);
		
		return null;
	}

	// Reporte bitacora de seguimiento de cobranza PDF
	private ByteArrayOutputStream repBitAccesoPDF(RepBitacoraAccesoBean repBitacoraAccesoBean, String nombreReporte,
			HttpServletResponse response) {
		ByteArrayOutputStream htmlStringPDF = null;
		try {
			htmlStringPDF = bitacoraAccesoServicio.reporteBitacoraAccesoPDF(repBitacoraAccesoBean, nombreReporte);
			response.addHeader("Content-Disposition","inline; filename=ReporteBitacoraAcceso.pdf");
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

	public BitacoraAccesoServicio getBitacoraAccesoServicio() {
		return bitacoraAccesoServicio;
	}

	public void setBitacoraAccesoServicio(
			BitacoraAccesoServicio bitacoraAccesoServicio) {
		this.bitacoraAccesoServicio = bitacoraAccesoServicio;
	}

	public String getNombreReporte() {
		return nombreReporte;
	}

	public String getSuccessView() {
		return successView;
	}

	public void setNombreReporte(String nombreReporte) {
		this.nombreReporte = nombreReporte;
	}

	public void setSuccessView(String successView) {
		this.successView = successView;
	}
	
	
}
