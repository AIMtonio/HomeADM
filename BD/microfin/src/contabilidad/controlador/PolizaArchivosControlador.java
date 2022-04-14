package contabilidad.controlador;

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

import contabilidad.bean.PolizaArchivosBean;
import contabilidad.servicio.PolizaArchivosServicio;

public class PolizaArchivosControlador extends SimpleFormController {
	
	PolizaArchivosServicio polizaArchivosServicio = null;
    protected ModelAndView onSubmit(HttpServletRequest request,
    								HttpServletResponse response,
    								Object command,
    								BindException errors) throws ServletException, IOException {
    	String recurso ="";
        String directorio ="";
        String archivoNombre="";
        String polizaID ="";
     
        
    	//Establecemos el Parametros de Auditoria del Nombre del Programa 
        polizaArchivosServicio.getPolizaArchivosDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));

		
		PolizaArchivosBean polizaArchivosbean = (PolizaArchivosBean) command;
		polizaID = ( polizaArchivosbean.getPolizaID() !=null ||  polizaArchivosbean.getPolizaID() != "")? polizaArchivosbean.getPolizaID():"0";
	   
	    recurso = request.getParameter("recurso");

        MensajeTransaccionArchivoBean mensaje = null;         
    	if(tipoTransaccion==1){
    	
    	directorio =	recurso+"Poliza Contable/Poliza"+Utileria.completaCerosIzquierda(polizaID, 10)+"/";        	
    	polizaArchivosbean.setRecurso(directorio);
    	              
         mensaje = polizaArchivosServicio.grabaTransaccion(tipoTransaccion, polizaArchivosbean, directorio);
       
  	} 	        
        return new ModelAndView(getSuccessView(), "mensaje", mensaje);
    
    }	
    
    //-----------------setter----------------------
    public void setPolizaArchivosServicio(PolizaArchivosServicio polizaArchivosServicio) {
		this.polizaArchivosServicio = polizaArchivosServicio;
	}
    
}
