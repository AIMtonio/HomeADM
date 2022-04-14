package tarjetas.reporte;

import java.io.ByteArrayOutputStream;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;
import org.springframework.web.servlet.mvc.SimpleFormController;

import soporte.servicio.FileUploadServicio;

import tarjetas.bean.TarDebArchAclaBean;
import tarjetas.servicio.TarDebArchAclaServicio;
import tarjetas.servicio.TarDebArchAclaServicio;

public class PDFAclaraArchiRepControlador extends AbstractCommandController{

	TarDebArchAclaServicio tarDebArchAclaServicio = null;
	String nombreReporte = null;	

 	public PDFAclaraArchiRepControlador(){
 		setCommandClass(TarDebArchAclaBean.class);
 		setCommandName("aclaracion");
 	}

 	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {

 		TarDebArchAclaBean aclaracionArchivo = (TarDebArchAclaBean) command;
 		String nombre = request.getParameter("nombre");
 		
 		ByteArrayOutputStream htmlString = tarDebArchAclaServicio.reporteArchivosAclaracionesPDF(aclaracionArchivo, nombre, nombreReporte);
 		
 		response.addHeader("Content-Disposition","inline; filename=archivoAclaracion.pdf");
 		response.setContentType("application/pdf");
 		byte[] bytes = htmlString.toByteArray();
 		response.getOutputStream().write(bytes,0,bytes.length);
		response.getOutputStream().flush();
		response.getOutputStream().close();

 		return null;
 	}

	public void setTarDebArchAclaServicio(TarDebArchAclaServicio tarDebArchAclaServicio) {
		this.tarDebArchAclaServicio = tarDebArchAclaServicio;
	}

	public void setNombreReporte(String nombreReporte) {
		this.nombreReporte = nombreReporte;
	}
	
}
