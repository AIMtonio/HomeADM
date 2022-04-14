package soporte.controlador;

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

import soporte.bean.CuentaArchivosBean;
import soporte.bean.TiposDocumentosBean;
import soporte.dao.FileUploadDAO;
import soporte.servicio.FileUploadServicio;
import soporte.servicio.TiposDocumentosServicio;

public class CuentaFileUploadControlador extends SimpleFormController {
	
	String[] extensValidas = {"txt","jpg","png","jpeg","gif","csv","xls","xlsx","tiff","pdf","doc","docx"};
	boolean validaExt = false;
	
	FileUploadServicio fileUploadServicio = null;
	TiposDocumentosServicio tiposDocumentosServicio = null;
	FileUploadDAO fileUploadDAO = null;	
    protected ModelAndView onSubmit(HttpServletRequest request,
    								HttpServletResponse response,
    								Object command,
    								BindException errors) throws ServletException, IOException {

    	
		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
		
		
		CuentaArchivosBean ctaBean = (CuentaArchivosBean) command;
	    TiposDocumentosBean tipoDocto = new TiposDocumentosBean();
	    TiposDocumentosBean tipoDocumentoBean = new TiposDocumentosBean();
		String cuentaAhoID = ctaBean.getCuentaAhoID();
		fileUploadServicio.getFileUploadDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		
		ctaBean.setArchivoCuentaID(request.getParameter("archivoCuentaID"));

		ctaBean.setObservacion(request.getParameter("observacion")); 
		String recurso ="";
        String extension ="";
        String directorio ="";
        String archivoNombre="";
        MensajeTransaccionArchivoBean mensaje = null; 
        CuentaArchivosBean cuentaArchivosBean = null;   
		if(tipoTransaccion==4){
			tipoDocumentoBean.setTipoDocumentoID(ctaBean.getTipoDocumento());
			
		

			
		    tipoDocto = tiposDocumentosServicio.consulta(TiposDocumentosServicio.Enum_Con_TiposDocumentos.descripcion, tipoDocumentoBean);
	        String tipoDocumento = tipoDocto.getDescripcion();
	        
	        recurso = request.getParameter("recurso");
	        extension = request.getParameter("extarchivo");
	        directorio =	recurso+"Cuentas/Cuenta"+cuentaAhoID+"/"+tipoDocumento;
	    	
	        for(String w : extensValidas)//Verfica que sea tio de archivo permitido
	        	validaExt|=extension.toLowerCase().endsWith(w);
	        
	        if(validaExt) {      
	        cuentaArchivosBean = fileUploadServicio.consultaArCuenta(FileUploadServicio.Enum_Con_File.numeroSiguiencta, ctaBean );
	    	
			String archivo = Utileria.completaCerosIzquierda(cuentaArchivosBean.getArchivoCuentaID(),5);
			
			
			    		
    		boolean exists = (new File(directorio)).exists();
    		if (exists) {
    			MultipartFile file = ctaBean.getFile();
    			archivoNombre =directorio+System.getProperty("file.separator")+"Archivo"+archivo+extension;
    			
    			if (file != null) {
    				File filespring = new File(archivoNombre);  
    				FileUtils.writeByteArrayToFile(filespring, file.getBytes());  
    			}
          	   
    		}else {
    			File aDir = new File(directorio);
    			aDir.mkdir();
    			MultipartFile file = ctaBean.getFile();
    			archivoNombre =directorio+System.getProperty("file.separator")+"Archivo"+archivo+extension;
    			if (file != null) {
    				File filespring = new File(archivoNombre);
                  	FileUtils.writeByteArrayToFile(filespring, file.getBytes());  
    			}
    		}
	        }
	        else 
	        	return new ModelAndView(getSuccessView(), "mensaje", null);
    	} 	
        
    	recurso = archivoNombre;
    	ctaBean.setRecurso(recurso);
    	mensaje = fileUploadServicio.grabaTransaccionCta(tipoTransaccion, ctaBean);
    	
    	return new ModelAndView(getSuccessView(), "mensaje", mensaje);
    }
	public void setFileUploadServicio(FileUploadServicio fileUploadServicio) {
		this.fileUploadServicio = fileUploadServicio;
	}
	public void setTiposDocumentosServicio(
			TiposDocumentosServicio tiposDocumentosServicio) {
		this.tiposDocumentosServicio = tiposDocumentosServicio;
	}
    
    
}

