package pld.controlador;

import general.bean.MensajeTransaccionArchivoBean;
import herramientas.Utileria;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.GregorianCalendar;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.FileUtils;
import org.springframework.validation.BindException;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import pld.bean.ArchAdjuntosPLDBean;
import pld.servicio.ArchAdjuntosPLDServicio;
import pld.servicio.ArchAdjuntosPLDServicio.Enum_Tra_ArchAdjuntosPLD;

public class ArchAdjuntosPLDUploadControlador extends SimpleFormController {
	ArchAdjuntosPLDServicio	archAdjuntosPLDServicio;
	
	public ArchAdjuntosPLDUploadControlador() {
		setCommandClass(ArchAdjuntosPLDBean.class);
		setCommandName("ArchAdjuntosPLDBean");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws ServletException, IOException {
		ArchAdjuntosPLDBean bean = (ArchAdjuntosPLDBean) command;
		int tipoTransaccion = Utileria.convierteEntero(request.getParameter("tipoTransaccion"));
		MensajeTransaccionArchivoBean mensaje = null;
		try {
			SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd_HHmmss");
			Calendar calendario = new GregorianCalendar();
			String directorio = "";
			String archivoNombre = "";
			String rutaFinal = null;
			String[] ruta;
			archAdjuntosPLDServicio.getArchivosPLDDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
			switch (tipoTransaccion) {
				case Enum_Tra_ArchAdjuntosPLD.alta :
					
					MultipartFile file1 = bean.getFile();
					if (file1 != null) {
						
						String nombreOriginal = file1.getOriginalFilename();
						String r[] = nombreOriginal.split("\\.");
						nombreOriginal = r[0];
						
						String extension = r.length > 1 ? r[r.length - 1] : "";
						archivoNombre = nombreOriginal + sdf.format(calendario.getTime()) + "." + extension;
						bean.setRecurso(archivoNombre);
					}
					mensaje = archAdjuntosPLDServicio.grabaTransaccion(tipoTransaccion, bean);
					if (mensaje.getNumero() == 0) {
						rutaFinal = mensaje.getConsecutivoString();
						ruta = rutaFinal.split("\\/");
						directorio = rutaFinal.replace(ruta[ruta.length - 1], "");
						File directorioRuta = new File(directorio);
						if (!directorioRuta.exists()) {
							directorioRuta.mkdirs();
						}
						if (file1 != null) {
							File filespring = new File(rutaFinal);
							FileUtils.writeByteArrayToFile(filespring, file1.getBytes());
						}
					}
					mensaje.setNombreControl(bean.getTipoProceso());
					if (Utileria.convierteEntero(bean.getTipoProceso()) == 1) {
						mensaje.setConsecutivoString(bean.getOpeInusualID());
						
					} else {
						mensaje.setConsecutivoString(bean.getOpeInterPreoID());
					}
					break;
				default :
					mensaje = new MensajeTransaccionArchivoBean();
					mensaje.setNumero(999);
					mensaje.setDescripcion("El Tipo de Transacción no Existe.");
			}
		} catch (Exception ex) {
			mensaje = new MensajeTransaccionArchivoBean();
			mensaje.setNumero(999);
			mensaje.setDescripcion("Error al Subir el Archivo." + ex.getMessage());
			ex.printStackTrace();
		}
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}
	
	public ArchAdjuntosPLDServicio getArchAdjuntosPLDServicio() {
		return archAdjuntosPLDServicio;
	}
	
	public void setArchAdjuntosPLDServicio(ArchAdjuntosPLDServicio archAdjuntosPLDServicio) {
		this.archAdjuntosPLDServicio = archAdjuntosPLDServicio;
	}
	
}
