package pld.controlador;

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

import cliente.servicio.ClienteArchivosServicio;

import cliente.bean.ClienteArchivosBean;
import soporte.servicio.TiposDocumentosServicio;

public class OpeEscalamientoInternoFileUploadControlador extends SimpleFormController {
	
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
	   
	    bean.setProspectoID((request.getParameter("prospectoID")!=null)? request.getParameter("prospectoID"):	"0"); 
	    
	    recurso = request.getParameter("recurso");
        	
	    		
        MensajeTransaccionArchivoBean mensaje = null;  
        
    	if(tipoTransaccion==1){
    		//si se trata de un cliente, se guarda en el directorio clientes sino se guarda en el de prospectos
    		if(clienteID.equals("0") ||clienteID.equals("") ||clienteID.equals(null)){
    			directorio =	recurso+"PLD/Prospectos/Prospecto"+Utileria.completaCerosIzquierda(bean.getProspectoID(),10)+"/";
    		}else{
    			directorio =	recurso+"PLD/Clientes/Cliente"+Utileria.completaCerosIzquierda(clienteID, 10)+"/";
    		}     	
        	
        	bean.setRecurso(directorio);
        	mensaje = clienteArchivosServicio.grabaTransaccion(tipoTransaccion, bean);
        	archivoNombre = mensaje.getRecursoOrigen();	
        
        	
    		boolean exists = (new File(directorio)).exists();
    		if (exists) {
    			MultipartFile file = bean.getFile();
    			
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

