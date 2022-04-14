

package originacion.controlador;

import herramientas.Constantes;

import java.io.File;
import java.io.FileInputStream;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import originacion.bean.SolicitudesArchivoBean;
import originacion.servicio.SolicitudArchivoServicio;


public class SolicitudVerArchivoControlador extends AbstractCommandController{
	SolicitudArchivoServicio solicitudArchivoServicio = null;		 
	
 	public SolicitudVerArchivoControlador(){
 		setCommandClass(SolicitudesArchivoBean.class);
 		setCommandName("clienteArchivosBean");
 	}


 	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {

 		SolicitudesArchivoBean archivoBean = (SolicitudesArchivoBean) command;
 		SolicitudesArchivoBean solicitudArchivos = new SolicitudesArchivoBean();
 		
 		String contentOriginal = response.getContentType();
 		String nombreArchivo =	archivoBean.getRecurso();
 		
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
	 			if (extension.equals(".pdf") || extension.equals(".PDF")){
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
		 			 			}
	 							else{
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
 			String htmlString = Constantes.htmlErrorVerArchivoCliente;
 			response.addHeader("Content-Disposition","");
	 		response.setContentType(contentOriginal);
	 		response.setContentLength(htmlString.length());
 			return new ModelAndView("resultadoTransaccionReporteVista", "reporte", htmlString);
		}
 		
 	}


	public SolicitudArchivoServicio getSolicitudArchivoServicio() {
		return solicitudArchivoServicio;
	}


	public void setSolicitudArchivoServicio(
			SolicitudArchivoServicio solicitudArchivoServicio) {
		this.solicitudArchivoServicio = solicitudArchivoServicio;
	}


	


}
