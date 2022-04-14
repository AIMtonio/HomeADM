package seguimiento.controlador;

import herramientas.Constantes;

import java.io.File;
import java.io.FileInputStream;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import seguimiento.bean.SegtoArchivoBean;
import seguimiento.servicio.SegtoArchivoServicio;

public class CapturaSegtoVerArchivoControlador extends AbstractCommandController{
	SegtoArchivoServicio segtoArchivoServicio = null;
	public CapturaSegtoVerArchivoControlador(){
 		setCommandClass(SegtoArchivoBean.class);
 		setCommandName("segtoArchivoBean");
 	}
	
	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {

		SegtoArchivoBean segtoArchivos = (SegtoArchivoBean) command;
//		TarDebArchAclaBean aclalaracionArchivos = new TarDebArchAclaBean();
		//int tipoConsulta = Integer.parseInt(request.getParameter("tipoConsulta"));
		
	
		String contentOriginal = response.getContentType();
		
		String nombreArchivo =	segtoArchivos.getNombreArchivo();
		String nombreCompleto = segtoArchivos.getRutaArchivo()+segtoArchivos.getSegtoPrograID()+"/"+nombreArchivo;
		String extension = nombreArchivo.substring(nombreArchivo.lastIndexOf('.'));
		//String nombreArchivoConsultado= nombreArchivo.substring((nombreArchivo.lastIndexOf('/')+1), nombreArchivo.lastIndexOf('.'));
		
		File archivoFile = new File(nombreCompleto);	 
		try{	 			 	
	 				
	 		FileInputStream fileInputStream = new FileInputStream(archivoFile);

	 		
	 		
	 		if(extension.equals(".doc") || extension.equals(".docx")){
	 			response.setContentType("application/msword");
	 			response.addHeader("Content-Disposition","inline; filename=" +nombreArchivo);
	 		}
	 		else{
	 			if (extension.equals(".pdf")){
	 				response.setContentType("application/pdf");
	 				response.addHeader("Content-Disposition","inline; filename=" +nombreArchivo);
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
	 			 				response.addHeader("Content-Disposition","inline; filename=" +nombreArchivo);
	 			 			}
	 						else{
	 							if (extension.equals(".xlsx")){
		 			 				response.setContentType("application/xlsx");
		 			 				response.addHeader("Content-Disposition","inline; filename=" +nombreArchivo);
	 							}else{
		 			 				response.addHeader("Content-Disposition","inline; filename=" +nombreArchivo);
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
			e.printStackTrace();
			String htmlString = Constantes.htmlErrorVerArchivoCuenta;
			response.addHeader("Content-Disposition","");
	 		response.setContentType(contentOriginal);
	 		response.setContentLength(htmlString.length());
			return new ModelAndView("resultadoTransaccionReporteVista", "reporte", htmlString);
		}
	}

	public SegtoArchivoServicio getSegtoArchivoServicio() {
		return segtoArchivoServicio;
	}

	public void setSegtoArchivoServicio(SegtoArchivoServicio segtoArchivoServicio) {
		this.segtoArchivoServicio = segtoArchivoServicio;
	}
}