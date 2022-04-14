package pld.reporte;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import pld.servicio.ParametrosOpRelServicio;
import soporte.servicio.FileUploadServicio;



public class PantallaBitacoraBatchControlador extends AbstractCommandController{
	
	FileUploadServicio fileUploadServicio = null;		
	String nombreReporte = null;
	String successView = null;		   
	
	public PantallaBitacoraBatchControlador() {
		setCommandClass(Object.class);
		setCommandName("BatchPLD");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {

		String fechaInicio = request.getParameter("fechaInicio");
		String fechaFin = request.getParameter("fechaFin");
		String htmlString = fileUploadServicio.reporteProcesosBatch(fechaInicio,fechaFin, nombreReporte); 		 		
		return new ModelAndView(getSuccessView(), "reporte", htmlString);
		
	}

	

	public FileUploadServicio getFileUploadServicio() {
		return fileUploadServicio;
	}

	public void setFileUploadServicio(FileUploadServicio fileUploadServicio) {
		this.fileUploadServicio = fileUploadServicio;
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
