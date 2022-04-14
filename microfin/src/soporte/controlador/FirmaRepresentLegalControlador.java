package soporte.controlador;

import java.io.File;

import general.bean.MensajeTransaccionArchivoBean;
import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.FileUtils;
import org.springframework.validation.BindException;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import soporte.bean.FirmaRepresentLegalBean;
import soporte.servicio.FirmaRepresentLegalServicio;

public class FirmaRepresentLegalControlador extends SimpleFormController{
	FirmaRepresentLegalServicio firmaRepresentLegalServicio=null;
		
		protected ModelAndView onSubmit(HttpServletRequest request,HttpServletResponse response,
											Object command,BindException errors) throws Exception{
			String recurso ="";
	        String directorio ="";
	        String archivoNombre="";	        	        	      
	        
	        FirmaRepresentLegalBean firmaBean = (FirmaRepresentLegalBean) command;
	        
	      //Establecemos los Parametros de Auditoria del Nombre del Programa 
	    	//clienteArchivosServicio.getClienteArchivosDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
	        int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
	        recurso = request.getParameter("recurso");
	        	        
			MensajeTransaccionArchivoBean mensaje = null;
			
			if(tipoTransaccion==1){
				directorio = recurso+"Firmas/firma_Representante";
				firmaBean.setRecurso(directorio);
	        	mensaje = firmaRepresentLegalServicio.grabaTransaccion(tipoTransaccion, firmaBean);
	        	archivoNombre = mensaje.getRecursoOrigen();	
				System.out.println(archivoNombre);
	        	boolean exists = (new File(directorio)).exists();
	    		if(exists){
	    			MultipartFile file = firmaBean.getFile();
	    			//archivoNombre =directorio+System.getProperty("file.separator")+"Archivo"+archivo+extension;
	    			
	    			if (file != null) {
	    				File filespring = new File(archivoNombre);  
	    				FileUtils.writeByteArrayToFile(filespring, file.getBytes());  
	    			}
	    		}else{
	    			File aDir = new File(directorio);
	    			aDir.mkdir();
	    			MultipartFile file = firmaBean.getFile();
	            
	    			if (file != null) {
	    				File filespring = new File(archivoNombre);
	                  	FileUtils.writeByteArrayToFile(filespring, file.getBytes());  
	    			}
	    		}
			}
						
			return new ModelAndView(getSuccessView(), "mensaje", mensaje);
		}
		
		
		public FirmaRepresentLegalServicio getFirmaRepresentLegalServicio() {
			return firmaRepresentLegalServicio;
		}
		public void setFirmaRepresentLegalServicio(
				FirmaRepresentLegalServicio firmaRepresentLegalServicio) {
			this.firmaRepresentLegalServicio = firmaRepresentLegalServicio;
		}
}
