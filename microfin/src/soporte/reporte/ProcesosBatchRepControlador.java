package soporte.reporte;

import herramientas.Utileria;
import soporte.servicio.FileUploadServicio;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;
import org.springframework.web.servlet.mvc.AbstractCommandController;

	public class ProcesosBatchRepControlador extends AbstractCommandController{
		
		FileUploadServicio fileUploadServicio = null;
		String nombreReporte = null;
		String successView = null;		   
		
		public ProcesosBatchRepControlador() {
			setCommandClass(Object.class);
			setCommandName("procesosBatch");
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

		public FileUploadServicio getFileUploadServicio() {
			return fileUploadServicio;
		}

		public void setFileUploadServicio(FileUploadServicio fileUploadServicio) {
			this.fileUploadServicio = fileUploadServicio;
		}

		
	}
	
