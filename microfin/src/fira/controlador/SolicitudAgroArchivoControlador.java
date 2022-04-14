
package fira.controlador;


import java.io.File;

import general.bean.MensajeTransaccionArchivoBean;
import herramientas.Utileria;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.FileUtils;
import org.springframework.validation.BindException;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import originacion.bean.SolicitudesArchivoBean;
import originacion.servicio.SolicitudArchivoServicio;

public class SolicitudAgroArchivoControlador  extends SimpleFormController {
	
	SolicitudArchivoServicio solicitudArchivoServicio = null;
	
	public SolicitudAgroArchivoControlador() {
		setCommandClass(SolicitudesArchivoBean.class);
		setCommandName("solicitudesArchivoBean");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse response,
									Object command,							
									BindException errors) throws Exception {
		
		
		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
								Integer.parseInt(request.getParameter("tipoTransaccion")):0;
		String directorio="";
		String archivoNombre="";
		String recurso="";
		SolicitudesArchivoBean solicitudesArchivoBean = (SolicitudesArchivoBean) command;
		solicitudesArchivoBean.setRecurso(solicitudesArchivoBean.getRecurso() + 
									 "Solicitudes"+ System.getProperty("file.separator") +"Solicitud" + solicitudesArchivoBean.getSolicitudCreditoID() +
									 System.getProperty("file.separator") + "Archivo");
		
		//Establecemos el Parametros de Auditoria del Nombre del Programa 
		solicitudArchivoServicio.getSolicitudArchivoDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		MensajeTransaccionArchivoBean mensaje = null;
		
		mensaje = solicitudArchivoServicio.grabaTransaccionCredito(tipoTransaccion, solicitudesArchivoBean);
		archivoNombre = mensaje.getRecursoOrigen();		
		directorio = recurso + "Solicitudes" + System.getProperty("file.separator") + "Solicitud" +
				solicitudesArchivoBean.getSolicitudCreditoID();
		
		boolean exists = (new File(directorio)).exists();		
		MultipartFile file = solicitudesArchivoBean.getFile();
		
		if(mensaje.getNumero() == 0){
			if (!exists) {
				File aDir = new File(directorio);
				aDir.mkdir();		
			}			
			if (file != null) {
				File filespring = new File(archivoNombre);  
				FileUtils.writeByteArrayToFile(filespring, file.getBytes());  
			}			
		}
	
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public SolicitudArchivoServicio getSolicitudArchivoServicio() {
		return solicitudArchivoServicio;
	}

	public void setSolicitudArchivoServicio(
			SolicitudArchivoServicio solicitudArchivoServicio) {
		this.solicitudArchivoServicio = solicitudArchivoServicio;
	}
    
	// -- Setters y Getters --------------------------------------------------------------------
	
	
	
			
}