package soporte.controlador;

import herramientas.Constantes;
import java.io.File;
import java.io.FileInputStream;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;
import soporte.bean.CuentaArchivosBean;
import soporte.servicio.FileUploadServicio;



public class CuentaFileVerArchivoControlador extends AbstractCommandController{
	FileUploadServicio fileUploadServicio = null;		 
		
 	public CuentaFileVerArchivoControlador(){
 		setCommandClass(CuentaArchivosBean.class);
 		setCommandName("cuentaArchivosBean");
 	}


 	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {

 		CuentaArchivosBean fileBean = (CuentaArchivosBean) command;
 		CuentaArchivosBean cuentaArchivos = new CuentaArchivosBean();
 		
		int tipoConsulta = Integer.parseInt(request.getParameter("tipoConsulta"));
 		
 		cuentaArchivos = fileUploadServicio.consultaArCuenta(tipoConsulta, fileBean);
 		String contentOriginal = response.getContentType();
 		
 		String nombreArchivo =	cuentaArchivos.getRecurso();
 		
 		String extension = nombreArchivo.substring(nombreArchivo.lastIndexOf('.'));
 		String nombreArchivoConsultado= nombreArchivo.substring((nombreArchivo.lastIndexOf('/')+1), nombreArchivo.lastIndexOf('.'));
 		File archivoFile = new File(nombreArchivo);	 
 		try{	 			 	
	 				
	 		FileInputStream fileInputStream = new FileInputStream(archivoFile);

	 		
	 		
	 		if(extension.equals(".doc") || extension.equals(".docx")){
	 			response.setContentType("application/msword");
	 			response.addHeader("Content-Disposition","inline; filename=" +nombreArchivoConsultado+extension);
	 		}
	 		else{
	 			if (extension.equals(".pdf")){
	 				response.setContentType("application/pdf");
	 				response.addHeader("Content-Disposition","inline; filename=" +nombreArchivoConsultado+extension);
	 			}
	 			else{
	 				if(extension.equals(".jpg")){
	 					//response.setContentType("application/jpeg");
	 					response.addHeader("Content-Disposition","");
	 			 		response.setContentType(contentOriginal);
	 				}
	 				else{
	 					if(extension.equals(".jpeg")){
	 						//response.setContentType("image/pjpeg");
	 						response.addHeader("Content-Disposition","");
	 				 		response.setContentType(contentOriginal);
	 					}
	 					else{
	 						if (extension.equals(".xls")){
	 			 				response.setContentType("application/xls");
	 			 				response.addHeader("Content-Disposition","inline; filename=" +nombreArchivoConsultado+extension);
	 			 			}
	 						else{
	 							if (extension.equals(".xlsx")){
		 			 				response.setContentType("application/xlsx");
		 			 				response.addHeader("Content-Disposition","inline; filename=" +nombreArchivoConsultado+extension);
	 							}else{
		 			 				response.addHeader("Content-Disposition","inline; filename=" +nombreArchivoConsultado+extension);
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
			
 		}catch (Exception e) {
 			String htmlString = Constantes.htmlErrorVerArchivoCuenta;
 			response.addHeader("Content-Disposition","");
	 		response.setContentType(contentOriginal);
	 		response.setContentLength(htmlString.length());
 			return new ModelAndView("resultadoTransaccionReporteVista", "reporte", htmlString);
		}
 		
 	}


	public void setFileUploadServicio(FileUploadServicio fileUploadServicio) {
		this.fileUploadServicio = fileUploadServicio;
	}
 	
 }