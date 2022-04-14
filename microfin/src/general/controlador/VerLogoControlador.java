package general.controlador;

import general.bean.ParametrosAuditoriaBean;
import herramientas.Constantes;

import java.io.File;
import java.io.FileInputStream;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;;

public class VerLogoControlador extends AbstractCommandController{
	
	String[] extensValidas = {"txt","jpg","png","jpeg","gif","csv","xls","xlsx","tiff","pdf","doc","docx"};
	boolean validaExt = false;
		
 	public VerLogoControlador(){
 		setCommandClass(ParametrosAuditoriaBean.class);
 		setCommandName("parametrosAuditoriaBean");
 	}


 	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {

 		ParametrosAuditoriaBean fileBean = (ParametrosAuditoriaBean) command;
 		
 		String contentOriginal = response.getContentType(); 		
 		String nombreArchivo =	request.getParameter("rutaLogoCliente"); 		
 		String extension = nombreArchivo.substring(nombreArchivo.lastIndexOf('.'));
 		File archivoFile = new File(nombreArchivo);	
 		
 		for(String w : extensValidas)
 			validaExt|=extension.toLowerCase().endsWith(w);
 		
 		try{
 			
 			if(!validaExt)
 				throw new Exception();
 			
	 		FileInputStream fileInputStream = new FileInputStream(archivoFile);	 		

			if(extension.equals(".jpg")){
				response.addHeader("Content-Disposition","");
		 		response.setContentType(contentOriginal);
			}else{
				if(extension.equals(".jpeg")){
					response.addHeader("Content-Disposition","");
			 		response.setContentType(contentOriginal);
				}else{
					if (extension.equals(".png")){
						response.addHeader("Content-Disposition","");
				 		response.setContentType(contentOriginal);
		 			}else{
						response.addHeader("Content-Disposition","");
				 		response.setContentType(contentOriginal);
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
 			System.out.println(e);
 			String htmlString = Constantes.htmlErrorVerArchivoCliente;
 			response.addHeader("Content-Disposition","");
	 		response.setContentType(contentOriginal);
	 		response.setContentLength(htmlString.length());
 			return new ModelAndView("resultadoTransaccionReporteVista", "reporte", htmlString);
		}
 		
 	}

 }