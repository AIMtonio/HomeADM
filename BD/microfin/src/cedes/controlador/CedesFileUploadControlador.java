package cedes.controlador;


	import general.bean.MensajeTransaccionArchivoBean;
import herramientas.Utileria;

import java.io.File;
import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.FileUtils;
import org.springframework.validation.BindException;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import cedes.bean.CedesArchivosBean;
import soporte.bean.TiposDocumentosBean;
import cedes.dao.CedesFileUploadDAO;
import cedes.servicio.CedesFileUploadServicio;
import soporte.servicio.TiposDocumentosServicio;

	public class CedesFileUploadControlador extends SimpleFormController {
		
		String[] extensValidas = {"txt","jpg","png","jpeg","gif","csv","xls","xlsx","tiff","pdf","doc","docx"};
		boolean validaExt = false;
		
		CedesFileUploadServicio cedesFileUploadServicio = null;
		TiposDocumentosServicio tiposDocumentosServicio = null;
		CedesFileUploadDAO cedesFileUploadDAO = null;	
	    protected ModelAndView onSubmit(HttpServletRequest request,
	    								HttpServletResponse response,
	    								Object command,
	    								BindException errors) throws ServletException, IOException {

	    	
			int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
			
			 
			
			CedesArchivosBean cedesBean = (CedesArchivosBean) command;
		    TiposDocumentosBean tipoDocto = new TiposDocumentosBean();
		    TiposDocumentosBean tipoDocumentoBean = new TiposDocumentosBean();
			String cedeID = cedesBean.getCedeID();
			
			
			cedesBean.setArchivoCuentaID(request.getParameter("archivoCuentaID"));

			cedesBean.setObservacion(request.getParameter("observacion")); 
			String recurso ="";
	        String extension ="";
	        String directorio ="";
	        String archivoNombre="";
	        MensajeTransaccionArchivoBean mensaje = null; 
	        CedesArchivosBean cedesArchivosBean = null;  
			 archivoNombre = request.getParameter("extarchivo");
	        
	        for(String w : extensValidas){
	        	validaExt|=extension.toLowerCase().endsWith(w);
		        }
	        
	        if(validaExt){
			if(tipoTransaccion==4){
				tipoDocumentoBean.setTipoDocumentoID(cedesBean.getTipoDocumento());

			    tipoDocto = tiposDocumentosServicio.consulta(TiposDocumentosServicio.Enum_Con_TiposDocumentos.descripcion, tipoDocumentoBean);
		        String tipoDocumento = tipoDocto.getDescripcion();
		        
		        recurso = request.getParameter("recurso");
		        extension = request.getParameter("extarchivo");
		        directorio =	recurso+"Cedes/Cede"+cedeID+"/"+tipoDocumento;
		    	
		              
		        cedesArchivosBean = cedesFileUploadServicio.consultaArCuenta(CedesFileUploadServicio.Enum_Con_File.numeroSiguienCede, cedesBean );
		    	
				String archivo = Utileria.completaCerosIzquierda(cedesArchivosBean.getArchivoCuentaID(),5);
				
				
				    		
	    		boolean exists = (new File(directorio)).exists();
	    		if (exists) {
	    			MultipartFile file = cedesBean.getFile();
	    			archivoNombre =directorio+System.getProperty("file.separator")+"Archivo"+archivo+extension;
	    			
	    			if (file != null) {
	    				File filespring = new File(archivoNombre);  
	    				FileUtils.writeByteArrayToFile(filespring, file.getBytes());  
	    			}
	          	   
	    		}else {
	    			File aDir = new File(directorio);
	    			aDir.mkdir();
	    			MultipartFile file = cedesBean.getFile();
	    			archivoNombre =directorio+System.getProperty("file.separator")+"Archivo"+archivo+extension;
	    			if (file != null) {
	    				File filespring = new File(archivoNombre);
	                  	FileUtils.writeByteArrayToFile(filespring, file.getBytes());  
	    			}
	    		}
	    		
	    	} 	
	        
	    	recurso = archivoNombre;
	    	cedesBean.setRecurso(recurso);
	    	mensaje = cedesFileUploadServicio.grabaTransaccionCta(tipoTransaccion, cedesBean);
	        }// Verifica que sea archivo permitido
	        else //En caso de no ser tipo de archivo permitido
	        	return null;
	    	return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	    }
		public void setCedesFileUploadServicio(CedesFileUploadServicio cedesFileUploadServicio) {
			this.cedesFileUploadServicio = cedesFileUploadServicio;
		}
		public void setTiposDocumentosServicio(
				TiposDocumentosServicio tiposDocumentosServicio) {
			this.tiposDocumentosServicio = tiposDocumentosServicio;
		}
	    
	    
	}


