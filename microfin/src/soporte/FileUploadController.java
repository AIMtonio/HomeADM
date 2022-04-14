package soporte;

import general.bean.MensajeTransaccionBean;
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

public class FileUploadController extends SimpleFormController {

    protected ModelAndView onSubmit(
        HttpServletRequest request,
        HttpServletResponse response,
        Object command,
        BindException errors) throws ServletException, IOException {

         // cast the bean
        FileUploadBean bean = (FileUploadBean) command;
     
        String df = System.getProperty("user.home")+
        System.getProperty("file.separator")+"directorio"; 
			       
        	boolean exists = (new File(df)).exists();
        	if (exists) {
        		String archivoName = System.getProperty("user.home") + 
        							 System.getProperty("file.separator")+"directorio" +
        							 System.getProperty("file.separator")+"imagen.jpg";
        		 
        
        		 
        		  MultipartFile file = bean.getFile();
        	        if (file != null) {
        	          
        	     
        		
       
        		File filespring = new File(archivoName);  
            	FileUtils.writeByteArrayToFile(filespring, file.getBytes());  
        		}
        	}else {
        		 File aDir = new File(df);
        				aDir.mkdir();
        				String archivoName = System.getProperty("user.home") + 
						 System.getProperty("file.separator")+"directorio" +
						 System.getProperty("file.separator")+"imagen.jpg";
              		  MultipartFile file = bean.getFile();
              	        if (file != null) {
              	           
              	        
             
              		File filespring = new File(archivoName);  
                  	FileUtils.writeByteArrayToFile(filespring, file.getBytes());  
              		}
             
        }
        
        MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
        mensaje.setNumero(0);
        mensaje.setDescripcion("Archivo Subido");

        return new ModelAndView(getSuccessView(), "mensaje", mensaje);
    }
}