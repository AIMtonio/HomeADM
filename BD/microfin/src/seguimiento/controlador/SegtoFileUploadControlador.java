package seguimiento.controlador;

import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;
import general.servicio.ParametrosAplicacionServicio;

import java.io.File;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.apache.commons.io.FileUtils;
import org.springframework.validation.BindException;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import seguimiento.bean.SegtoArchivoBean;
import seguimiento.servicio.SegtoArchivoServicio;

public class SegtoFileUploadControlador extends SimpleFormController{
	
	SegtoArchivoServicio segtoArchivoServicio= null;
	protected final Logger loggerSAFI = Logger.getLogger("SAFI");
	ParametrosAplicacionServicio	parametrosAplicacionServicio	= null;
	
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception{
		SegtoArchivoBean segtoArchivoBean = (SegtoArchivoBean) command;
		segtoArchivoServicio.getSegtoArchivoDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		int tipoTransaccion = (request.getParameter("tipoTransaccion") != null)?
				Integer.parseInt(request.getParameter("tipoTransaccion")):
					0;
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		ParametrosSesionBean parametros = parametrosAplicacionServicio.consultaParametrosSessionLocal();
		String directorio = parametros.getRutaArchivos()+"Seguimiento/";
		String archivoNombre ="";
		

		boolean exists = (new File(directorio)).exists();
		if (exists) {
			MultipartFile file = segtoArchivoBean.getFile();
			archivoNombre =directorio+segtoArchivoBean.getSegtoPrograID() +System.getProperty("file.separator")+segtoArchivoBean.getFile().getOriginalFilename();
			if (file != null) {
				File filespring = new File(archivoNombre);  
				FileUtils.writeByteArrayToFile(filespring, file.getBytes());  
			}
		}else {
			File aDir = new File(directorio);
			aDir.mkdir();
			MultipartFile file = segtoArchivoBean.getFile();
			archivoNombre =directorio+segtoArchivoBean.getSegtoPrograID()+System.getProperty("file.separator")+segtoArchivoBean.getFile().getOriginalFilename();
			if (file != null) {
				File filespring = new File(archivoNombre);
				FileUtils.writeByteArrayToFile(filespring, file.getBytes());				
			}
		}
		mensaje = new MensajeTransaccionBean();
	
		mensaje.setNumero(0);
		mensaje.setDescripcion("Archivo Cargado Exitósamente ");
		mensaje.setNombreControl(segtoArchivoBean.getSegtoPrograID()+"|"+ segtoArchivoBean.getNumSecuencia()+"|"+segtoArchivoBean.getConsecutivoID()+"|"+directorio+"|"+segtoArchivoBean.getComentaAdjunto()+"|"+segtoArchivoBean.getFile().getOriginalFilename());
			
		ModelAndView modelAndView = new ModelAndView("resultadoTransaccionArchivoSegtoVista");
		modelAndView.addObject("mensaje", mensaje);

		return modelAndView;
	}

	public SegtoArchivoServicio getSegtoArchivoServicio() {
		return segtoArchivoServicio;
	}

	public void setSegtoArchivoServicio(SegtoArchivoServicio segtoArchivoServicio) {
		this.segtoArchivoServicio = segtoArchivoServicio;
	}

	public Logger getLoggerSAFI() {
		return loggerSAFI;
	}

	public ParametrosAplicacionServicio getParametrosAplicacionServicio() {
		return parametrosAplicacionServicio;
	}

	public void setParametrosAplicacionServicio(
			ParametrosAplicacionServicio parametrosAplicacionServicio) {
		this.parametrosAplicacionServicio = parametrosAplicacionServicio;
	}
}