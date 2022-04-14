package soporte.reporte;

import java.io.ByteArrayOutputStream;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;
import org.springframework.web.servlet.mvc.SimpleFormController;

import soporte.servicio.FileUploadServicio;

import soporte.bean.CuentaArchivosBean;
import cuentas.servicio.CuentasAhoServicio;

public class PDFCuentaFileRepControlador extends AbstractCommandController{

	FileUploadServicio fileUploadServicio = null;
	String nombreReporte = null;	

 	public PDFCuentaFileRepControlador(){
 		setCommandClass(CuentaArchivosBean.class);
 		setCommandName("cliente");
 	}

 	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {

 		CuentaArchivosBean cuentaFile = (CuentaArchivosBean) command;
 		String nombreCliente = request.getParameter("nombreCliente");
 		
 		ByteArrayOutputStream htmlString = fileUploadServicio.reporteArchivosCuentasPDF(cuentaFile, nombreCliente, nombreReporte);
 		
 		response.addHeader("Content-Disposition","inline; filename=archivoCuenta.pdf");
 		response.setContentType("application/pdf");
 		byte[] bytes = htmlString.toByteArray();
 		response.getOutputStream().write(bytes,0,bytes.length);
		response.getOutputStream().flush();
		response.getOutputStream().close();

 		return null;
 	}

	public void setFileUploadServicio(FileUploadServicio fileUploadServicio) {
		this.fileUploadServicio = fileUploadServicio;
	}

	public void setNombreReporte(String nombreReporte) {
		this.nombreReporte = nombreReporte;
	}
	
}
