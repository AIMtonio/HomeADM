package pld.controlador;

import general.bean.MensajeTransaccionArchivoBean;

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

import pld.bean.RevisionRemesasBean;
import pld.servicio.RevisionRemesasServicio;

public class RevisionRemesasCheckListDocControlador extends SimpleFormController{

	RevisionRemesasServicio revisionRemesasServicio = null;

	public RevisionRemesasCheckListDocControlador (){
		setCommandClass(RevisionRemesasBean.class);
		setCommandName("revisionRemesasBean");
	}

	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws ServletException, IOException {

			String[] extensValidas = {"txt","jpg","png","jpeg","gif","csv","xls","xlsx","tiff","pdf","doc","docx"};
			boolean validaExt = false;

			String recurso = "";
			String directorio = "";
			String archivoNombre = "";
			String referencia = "";

			//Establecemos el Parametros de Auditoria del Nombre del Programa
			revisionRemesasServicio.getRevisionRemesasDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
	        int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));

	        RevisionRemesasBean revisionRemesasBean = (RevisionRemesasBean) command;

	        recurso = revisionRemesasBean.getRecurso();

	        referencia = revisionRemesasBean.getRemesaFolioID();

	        MensajeTransaccionArchivoBean mensaje = null;

	        if(tipoTransaccion == 1){
		    	directorio = recurso+"Remesas"+System.getProperty("file.separator")+"Referencia" + revisionRemesasBean.getRemesaFolioID()+System.getProperty("file.separator");

		    	revisionRemesasBean.setRecurso(directorio);

	        	mensaje = revisionRemesasServicio.grabaTransaccionDocumento(tipoTransaccion, revisionRemesasBean);

	        	if(mensaje.getNumero() == 0){
		        	archivoNombre = mensaje.getRecursoOrigen();

		        	for(String w : extensValidas)//Verfica que sea tio de archivo permitido
		        		validaExt|=archivoNombre.toLowerCase().endsWith(w);

		        	if(validaExt){

		    		boolean exists = (new File(directorio)).exists();
		    		if (exists) {
		    			MultipartFile file = revisionRemesasBean.getFile();

		    			if (file != null) {
		    				File filespring = new File(archivoNombre);
		    				FileUtils.writeByteArrayToFile(filespring, file.getBytes());
		    			}

		    		}else {
		    			File aDir = new File(directorio);
		    			aDir.mkdir();
		    			MultipartFile file = revisionRemesasBean.getFile();

		    			if (file != null) {
		    				File filespring = new File(archivoNombre);
		                  	FileUtils.writeByteArrayToFile(filespring, file.getBytes());
		    			}
		    		}
		    	}
		        	else
		        		return new ModelAndView(getSuccessView(), "mensaje", null);
		        }
	        }
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	// GETTER & SETTER
	public RevisionRemesasServicio getRevisionRemesasServicio() {
		return revisionRemesasServicio;
	}

	public void setRevisionRemesasServicio(RevisionRemesasServicio revisionRemesasServicio) {
		this.revisionRemesasServicio = revisionRemesasServicio;
	}
}
