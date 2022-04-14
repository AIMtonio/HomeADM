package ventanilla.controlador;

import general.bean.MensajeTransaccionArchivoBean;
import herramientas.Utileria;

import java.io.File;
import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.FileUtils;
import org.apache.log4j.Logger;
import org.springframework.validation.BindException;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import ventanilla.bean.UsuarioServiciosBean;
import ventanilla.servicio.UsuarioArchivosServicio;

public class UsuarioArchivosControlador extends SimpleFormController {
	
	UsuarioArchivosServicio usuarioArchivosServicio = null;
	
	protected final Logger loggerSAFI = Logger.getLogger("SAFI");

	  protected ModelAndView onSubmit(HttpServletRequest request,
				HttpServletResponse response,
				Object command,
				BindException errors) throws ServletException, IOException {
		  
		  String[] extensValidas = {"txt","jpg","png","jpeg","gif","csv","xls","xlsx","tiff","pdf","doc","docx"};
		  boolean validaExt = false;
			
		String recurso ="";
        String directorio ="";
        String archivoNombre="";
        String usuarioID ="";
		 
        //Establecemos el Parametros de Auditoria del Nombre del Programa
        usuarioArchivosServicio.getUsuarioArchivosDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
        int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
        
        UsuarioServiciosBean bean = (UsuarioServiciosBean) command;
        
        usuarioID = (bean.getUsuarioID() != null || bean.getUsuarioID() != "")? bean.getUsuarioID(): "0";
       
        recurso = request.getParameter("recurso");
        MensajeTransaccionArchivoBean mensaje = null;
        
		if(tipoTransaccion == 1){
			

	    	//si se trata de un cliente, se guarda en el directorio clientes sino se guarda en el de prospectos
	    	directorio =	recurso+"UsuarioServicio/Usuario" + usuarioID +"/";
	    		     	
	        	
	        	bean.setRecurso(directorio);
	        	mensaje = usuarioArchivosServicio.grabaTransaccion(tipoTransaccion, bean);
	        	archivoNombre = mensaje.getRecursoOrigen();	
	        	
	        	for(String w : extensValidas)//Verfica que sea tio de archivo permitido
	        		validaExt|=archivoNombre.toLowerCase().endsWith(w);
	        	
	        	if(validaExt){
	        	
	    		boolean exists = (new File(directorio)).exists();
	    		if (exists) {
	    			MultipartFile file = bean.getFile();
	    			//archivoNombre =directorio+System.getProperty("file.separator")+"Archivo"+archivo+extension;
	    			
	    			if (file != null) {
	    				File filespring = new File(archivoNombre);  
	    				FileUtils.writeByteArrayToFile(filespring, file.getBytes());  
	    			}
	          	   
	    		}else {
	    			File aDir = new File(directorio);
	    			aDir.mkdir();
	    			MultipartFile file = bean.getFile();
	            
	    			if (file != null) {
	    				File filespring = new File(archivoNombre);
	                  	FileUtils.writeByteArrayToFile(filespring, file.getBytes());  
	    			}
	    		}    		
	    	} 
	        	else
	        		return new ModelAndView(getSuccessView(), "mensaje", null);
		}
		 
		 return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	 }

	public UsuarioArchivosServicio getUsuarioArchivosServicio() {
		return usuarioArchivosServicio;
	}

	public void setUsuarioArchivosServicio(
			UsuarioArchivosServicio usuarioArchivosServicio) {
		this.usuarioArchivosServicio = usuarioArchivosServicio;
	}
	  
	  
	 
}
