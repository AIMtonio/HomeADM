package soporte.controlador;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import general.bean.MensajeTransaccionBean;
import general.bean.MensajeTransaccionArchivoBean;
import herramientas.Utileria;
import soporte.servicio.FileUploadServicio;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

public class ProcesosBatchControlador extends SimpleFormController {
	FileUploadServicio fileUploadServicio = null;
	String nombreReporte = null;
	String successView = null;		

 	public ProcesosBatchControlador(){
 		setCommandClass(Object.class);
 		setCommandName("procesosBatch");
 	}

 	protected ModelAndView onSubmit(HttpServletRequest request,
				HttpServletResponse response,
				Object command,
				BindException errors) throws Exception {

 		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
				Integer.parseInt(request.getParameter("tipoTransaccion")):
			0;
				
		MensajeTransaccionBean mensaje = null;
		
								
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
 		

}

	public String getNombreReporte() {
		return nombreReporte;
	}

	public void setNombreReporte(String nombreReporte) {
		this.nombreReporte = nombreReporte;
	}

	public FileUploadServicio getFileUploadServicio() {
		return fileUploadServicio;
	}

	public void setFileUploadServicio(FileUploadServicio fileUploadServicio) {
		this.fileUploadServicio = fileUploadServicio;
	}




}

