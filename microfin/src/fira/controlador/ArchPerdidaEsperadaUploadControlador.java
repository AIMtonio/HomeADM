package fira.controlador;

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

import fira.bean.ArchPerdidaEsperadaBean;
import general.bean.MensajeTransaccionArchivoBean;

public class ArchPerdidaEsperadaUploadControlador extends SimpleFormController {
	public ArchPerdidaEsperadaUploadControlador() {
		setCommandClass(ArchPerdidaEsperadaBean.class);
		setCommandName("archPerdidaEsperadaBean");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws ServletException, IOException {
		String directorio = "";
		String archivoNombre = "";
		String rutaFinal = null;
		ArchPerdidaEsperadaBean bean = (ArchPerdidaEsperadaBean) command;
		MensajeTransaccionArchivoBean mensaje = null;

		directorio = bean.getRecurso() + "FIRA/"+bean.getFecha()+"/";
		bean.setRecurso(directorio);
		
		boolean exists = (new File(directorio)).exists();
			if (exists) {
				MultipartFile file = bean.getFile();
				archivoNombre = directorio+file.getOriginalFilename();
				if (file != null) {
					File filespring = new File(archivoNombre);
					FileUtils.writeByteArrayToFile(filespring, file.getBytes());
					rutaFinal = filespring.getAbsolutePath();
				}
				
			} else {
				File aDir = new File(directorio);
				aDir.mkdirs();
				MultipartFile file = bean.getFile();
				archivoNombre = directorio+file.getOriginalFilename();
				if (file != null) {
					File filespring = new File(archivoNombre);
					FileUtils.writeByteArrayToFile(filespring, file.getBytes());
					rutaFinal = filespring.getAbsolutePath();
				}
			}
			if(mensaje==null){
				mensaje=new MensajeTransaccionArchivoBean();
				mensaje.setNumero(0);
				mensaje.setDescripcion("Archivo Subido Exitosamente.");
				mensaje.setConsecutivoString(rutaFinal);
				mensaje.setNombreControl(bean.getRutaLocal());
			}
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

}
