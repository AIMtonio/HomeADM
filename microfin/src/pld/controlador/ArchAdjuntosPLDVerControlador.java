package pld.controlador;

import herramientas.Constantes;

import java.io.File;
import java.io.FileInputStream;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import pld.bean.ArchAdjuntosPLDBean;
import pld.servicio.ArchAdjuntosPLDServicio;

public class ArchAdjuntosPLDVerControlador extends AbstractCommandController {
	ArchAdjuntosPLDServicio	archAdjuntosPLDServicio	= null;
	
	public ArchAdjuntosPLDVerControlador() {
		setCommandClass(ArchAdjuntosPLDBean.class);
		setCommandName("archAdjuntosPLDBean");
	}
	
	protected ModelAndView handle(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {
		String contentOriginal = response.getContentType();
		String nombreArchivo = request.getParameter("recurso");
		
		try {
			
			
			String extension = nombreArchivo.substring(nombreArchivo.lastIndexOf('.'));
			String nombreArchivoConsultado= nombreArchivo.substring((nombreArchivo.lastIndexOf('/')+1), nombreArchivo.lastIndexOf('.'));

			File archivoFile = new File(nombreArchivo);
			
			FileInputStream fileInputStream = new FileInputStream(archivoFile);
			if (extension.equals(".doc") || extension.equals(".docx")) {
				response.setContentType("application/msword");
				response.addHeader("Content-Disposition", "inline; filename=" + nombreArchivoConsultado + extension);
			} else {
				if (extension.equals(".pdf")) {
					response.setContentType("application/pdf");
					response.addHeader("Content-Disposition", "inline; filename=" + nombreArchivoConsultado + extension);
				} else {
					if (extension.equals(".jpg")) {
						response.addHeader("Content-Disposition", "");
						response.setContentType(contentOriginal);
					} else {
						if (extension.equals(".jpeg")) {
							response.addHeader("Content-Disposition", "");
							response.setContentType(contentOriginal);
						} else {
							if (extension.equals(".xls")) {
								response.setContentType("application/xls");
								response.addHeader("Content-Disposition", "inline; filename=" + nombreArchivoConsultado + extension);
							} else {
								if (extension.equals(".xlsx")) {
									response.setContentType("application/xlsx");
									response.addHeader("Content-Disposition", "inline; filename=" + nombreArchivoConsultado + extension);
								} else {
									// no cambiar el  attachment por inline en este archivo, porque asi se utiliza
									response.addHeader("Content-Disposition", "attachment; filename=" + nombreArchivoConsultado + extension);
									response.setContentType(contentOriginal);
								}
							}
						}
					}
				}
			}
			
			response.setContentLength((int) archivoFile.length());
			int bytes;
			
			while ((bytes = fileInputStream.read()) != -1) {
				response.getOutputStream().write(bytes);
			}
			
			response.getOutputStream().flush();
			response.getOutputStream().close();
			
			return null;
			
		} catch (Exception e) {
			e.printStackTrace();
			String htmlString = Constantes.htmlErrorVerArchivoCliente;
			response.addHeader("Content-Disposition", "");
			response.setContentType(contentOriginal);
			response.setContentLength(htmlString.length());
			return new ModelAndView("resultadoTransaccionReporteVista", "reporte", htmlString);
		}
		
	}
	
	public ArchAdjuntosPLDServicio getArchAdjuntosPLDServicio() {
		return archAdjuntosPLDServicio;
	}
	
	public void setArchAdjuntosPLDServicio(ArchAdjuntosPLDServicio archAdjuntosPLDServicio) {
		this.archAdjuntosPLDServicio = archAdjuntosPLDServicio;
	}
	
}