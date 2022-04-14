package inversiones.reporte;

import java.io.ByteArrayOutputStream;

import inversiones.bean.InversionBean;
import inversiones.servicio.InversionServicio;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import credito.bean.CreditosBean;

public class PagareInverRepControlador extends AbstractCommandController{
	
	InversionServicio inversionServicio = null;
	String nombreReporte = null;
	String successView = null;
	
	public PagareInverRepControlador(){
		setCommandClass(InversionBean.class);
		setCommandName("inversionBean");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {
		
		InversionBean inversionBean = (InversionBean) command;
		ByteArrayOutputStream htmlString = RepInversiones(inversionBean, nombreReporte,response);
		
 		return new ModelAndView(getSuccessView(), "reporte", htmlString);

	}
	
	public ByteArrayOutputStream RepInversiones(InversionBean inversionBean, String nombreReporte, HttpServletResponse response){
		ByteArrayOutputStream htmlStringPDF = null;
		try {
			htmlStringPDF = inversionServicio.reporteInversion(inversionBean, nombreReporte);
			response.addHeader("Content-Disposition","inline; filename=ReporteInversiones.pdf");
			response.setContentType("application/pdf");
			byte[] bytes = htmlStringPDF.toByteArray();
			response.getOutputStream().write(bytes,0,bytes.length);
			response.getOutputStream().flush();
			response.getOutputStream().close();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}		
	return htmlStringPDF;
	}
	
	public void setInversionServicio(InversionServicio inversionServicio) {
		this.inversionServicio = inversionServicio;
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
