package fira.controlador;

import java.io.File;
import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.FileUtils;
import org.apache.commons.io.FilenameUtils;
import org.springframework.validation.BindException;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import fira.bean.CatReportesFIRABean;
import general.bean.MensajeTransaccionArchivoBean;
import herramientas.Utileria;

public class ArchMonitoreoUploadControlador extends SimpleFormController {
	public ArchMonitoreoUploadControlador() {
		setCommandClass(CatReportesFIRABean.class);
		setCommandName("CatReportesFIRABean");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws ServletException, IOException {
		MensajeTransaccionArchivoBean mensaje = null;
		try {
			CatReportesFIRABean bean = (CatReportesFIRABean) command;
			
			String directorio = bean.getRecurso() + "FIRA/MONITOREO/" + bean.getFechaReporte() + "/";
			bean.setRecurso(directorio);
			int tipoArchiv = Utileria.convierteEntero(bean.getTipoArchivo());
			String archivoNombre = "";
			boolean exists = (new File(directorio)).exists();
			
			if (!exists) {
				File aDir = new File(directorio);
				aDir.mkdirs();
			}
			MultipartFile file = bean.getFile();
			String forma[] = file.getOriginalFilename().split("\\.");
			
			String nombre = forma[0];
			String extension = FilenameUtils.getExtension(file.getOriginalFilename());
			String nombreFinal = nombre + "_" + tipoArchiv + "." + extension;
			archivoNombre = directorio + nombreFinal;
			if (file != null) {
				File filespring = new File(archivoNombre);
				FileUtils.writeByteArrayToFile(filespring, file.getBytes());
			}
			
			if (mensaje == null) {
				mensaje = new MensajeTransaccionArchivoBean();
				mensaje.setNumero(0);
				mensaje.setDescripcion("Archivo Subido Exitosamente.");
				mensaje.setConsecutivoString(bean.getTipoArchivo());
				mensaje.setNombreControl(nombreFinal);
			}
		} catch (Exception ex) {
			ex.printStackTrace();
			mensaje = new MensajeTransaccionArchivoBean();
			mensaje.setNumero(888);
			mensaje.setDescripcion("Error al Subir Archivo: " + ex.getMessage());
		}
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

}
