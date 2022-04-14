package cliente.controlador;

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
import cliente.bean.ClienteArchivosBean;
import cliente.servicio.ClienteArchivosServicio;
public class ClientePROFUNArchivosAdjuntaControlador extends SimpleFormController {
	
	ClienteArchivosServicio clienteArchivosServicio = null;
    protected ModelAndView onSubmit(HttpServletRequest request,
    								HttpServletResponse response,
    								Object command,
    								BindException errors) throws ServletException, IOException {
    	String recurso ="";
        String directorio ="";
        String archivoNombre="";
        String clienteID ="";
     
       
    	//Establecemos el Parametros de Auditoria del Nombre del Programa 
    	clienteArchivosServicio.getClienteArchivosDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));

	    ClienteArchivosBean bean = (ClienteArchivosBean) command;
	   
	    clienteID = ( bean.getClienteID() !=null ||  bean.getClienteID() != "")?
	    		 bean.getClienteID():
						"0";
	   
	    bean.setClienteID((request.getParameter("clienteID")!=null)? request.getParameter("clienteID"):	"0"); 
	    recurso = request.getParameter("recurso");
	   	    		
        MensajeTransaccionArchivoBean mensaje = null; 
        
    	if(tipoTransaccion==1){
    		//indicando el directorio donde se guardaran los archivos
    		if(clienteID != null  || clienteID != ""){
    			directorio =	recurso+"/Clientes/Cliente"+Utileria.completaCerosIzquierda(bean.getClienteID(),10)+"/";
    		} 	
        	bean.setRecurso(directorio);
        	mensaje = clienteArchivosServicio.grabaTransaccion(tipoTransaccion, bean);
        	archivoNombre = mensaje.getRecursoOrigen();	
        	
        	
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
        return new ModelAndView(getSuccessView(), "mensaje", mensaje);
    
    }
	public ClienteArchivosServicio getClienteArchivosServicio() {
		return clienteArchivosServicio;
	}
	public void setClienteArchivosServicio(
			ClienteArchivosServicio clienteArchivosServicio) {
		this.clienteArchivosServicio = clienteArchivosServicio;
	}
	
}

