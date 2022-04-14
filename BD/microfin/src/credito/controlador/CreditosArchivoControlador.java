package credito.controlador;

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

import credito.bean.CreditosArchivoBean;
import credito.servicio.CreditoArchivoServicio;

public class CreditosArchivoControlador  extends SimpleFormController {
	
	CreditoArchivoServicio creditoArchivoServicio = null;
	
	public CreditosArchivoControlador() {
		setCommandClass(CreditosArchivoBean.class);
		setCommandName("creditosArchivoBean");
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
		CreditosArchivoBean creditosArchivoBean = (CreditosArchivoBean) command;
		creditosArchivoBean.setRecurso(creditosArchivoBean.getRecurso() + 
									 "Creditos"+ System.getProperty("file.separator") +"Credito" + creditosArchivoBean.getCreditoID() +
									 System.getProperty("file.separator") + "Archivo");
		
		//Establecemos el Parametros de Auditoria del Nombre del Programa 
		creditoArchivoServicio.getCreditoArchivoDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		MensajeTransaccionArchivoBean mensaje = null;
		
		mensaje = creditoArchivoServicio.grabaTransaccionCredito(tipoTransaccion, creditosArchivoBean);
		archivoNombre = mensaje.getRecursoOrigen();		
		directorio = recurso + "Creditos" + System.getProperty("file.separator") + "Credito" +
					 creditosArchivoBean.getCreditoID();
		
		boolean exists = (new File(directorio)).exists();		
		MultipartFile file = creditosArchivoBean.getFile();
		
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
    
	// -- Setters y Getters --------------------------------------------------------------------
	
	public void setCreditoArchivoServicio(
			CreditoArchivoServicio creditoArchivoServicio) {
		this.creditoArchivoServicio = creditoArchivoServicio;
	}
	
			
}