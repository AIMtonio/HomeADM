package cedes.reporte;

import java.io.ByteArrayOutputStream;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import cedes.bean.CedesBean;
import cedes.servicio.CedesServicio;

public class PagareFijoCedeRepControlador extends AbstractCommandController{
	
	CedesServicio cedesServicio = null;
	String nombreReporte = null;
	String successView = null;
	
	public PagareFijoCedeRepControlador(){
		setCommandClass(CedesBean.class);
		setCommandName("cedesBean");
	}
	 
	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {
		
		CedesBean cedesBean = (CedesBean) command;
		ByteArrayOutputStream htmlString = RepCedes(cedesBean, nombreReporte,response);
		
 		return new ModelAndView(getSuccessView(), "reporte", htmlString);

	}
	
	public ByteArrayOutputStream RepCedes(CedesBean cedesBean, String nombreReporte, HttpServletResponse response){
		ByteArrayOutputStream htmlStringPDF = null;
		try {
			htmlStringPDF = cedesServicio.reporteCedes(cedesBean, nombreReporte);
			response.addHeader("Content-Disposition","inline; filename=ReporteCedesTasaFija.pdf");
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
	

	public CedesServicio getCedesServicio() {
		return cedesServicio;
	}

	public void setCedesServicio(CedesServicio cedesServicio) {
		this.cedesServicio = cedesServicio;
	}

	public String getNombreReporte() {
		return nombreReporte;
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
