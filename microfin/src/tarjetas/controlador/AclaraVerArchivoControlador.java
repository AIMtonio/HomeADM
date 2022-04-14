package tarjetas.controlador;

import herramientas.Constantes;
import java.io.File;
import java.io.FileInputStream;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;
import tarjetas.bean.TarDebArchAclaBean;
import tarjetas.servicio.TarDebArchAclaServicio;



public class AclaraVerArchivoControlador extends AbstractCommandController{
	TarDebArchAclaServicio tarDebArchAclaServicio = null;		 
		
 	public AclaraVerArchivoControlador(){
 		setCommandClass(TarDebArchAclaBean.class);
 		setCommandName("aclaraArchivosBean");
 	}

 	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {

 		TarDebArchAclaBean aclaracionArchivos = (TarDebArchAclaBean) command;
// 		TarDebArchAclaBean aclalaracionArchivos = new TarDebArchAclaBean();
		//int tipoConsulta = Integer.parseInt(request.getParameter("tipoConsulta"));
		
	
 		String contentOriginal = response.getContentType();
 		
 		String nombreArchivo =	aclaracionArchivos.getNombreArchivo();
 		String nombreCompleto = aclaracionArchivos.getRuta()+aclaracionArchivos.getReporteID()+"/"+nombreArchivo;
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

	public void setTarDebArchAclaServicio(TarDebArchAclaServicio tarDebArchAclaServicio) {
		this.tarDebArchAclaServicio = tarDebArchAclaServicio;
	}
 	
 }