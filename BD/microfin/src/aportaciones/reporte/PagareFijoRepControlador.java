package aportaciones.reporte;

import java.io.ByteArrayOutputStream;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import aportaciones.bean.AportacionesBean;
import aportaciones.servicio.AportacionesServicio;

public class PagareFijoRepControlador extends AbstractCommandController{

	AportacionesServicio aportacionesServicio = null;
	String nombreReporte = null;
	String successView = null;

	public PagareFijoRepControlador(){
		setCommandClass(AportacionesBean.class);
		setCommandName("aportacionesBean");
	}

	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {

		AportacionesBean aportacionesBean = (AportacionesBean) command;
		ByteArrayOutputStream htmlString = RepAportaciones(aportacionesBean, nombreReporte,response);

		return new ModelAndView(getSuccessView(), "reporte", htmlString);

	}

	public ByteArrayOutputStream RepAportaciones(AportacionesBean aportacionesBean, String nombreReporte, HttpServletResponse response){
		ByteArrayOutputStream htmlStringPDF = null;
		try {
			htmlStringPDF = aportacionesServicio.reporteAportaciones(aportacionesBean, nombreReporte);
			response.addHeader("Content-Disposition","inline; filename=PagareAportTasaFija.pdf");
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

	public AportacionesServicio getAportacionesServicio() {
		return aportacionesServicio;
	}

	public void setAportacionesServicio(AportacionesServicio aportacionesServicio) {
		this.aportacionesServicio = aportacionesServicio;
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

}