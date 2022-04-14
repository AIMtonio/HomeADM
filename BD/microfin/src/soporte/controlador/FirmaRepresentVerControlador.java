package soporte.controlador;

import herramientas.Constantes;

import java.io.File;
import java.io.FileInputStream;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import soporte.bean.FirmaRepresentLegalBean;
import soporte.servicio.FirmaRepresentLegalServicio;

public class FirmaRepresentVerControlador extends AbstractCommandController{
	FirmaRepresentLegalServicio firmaRepresentLegalServicio=null;
	
	public FirmaRepresentVerControlador(){
		setCommandClass(FirmaRepresentLegalBean.class);
		setCommandName("verArchivo");
	}
	
	protected ModelAndView handle(HttpServletRequest request,HttpServletResponse response,
			  										Object command,BindException errors) throws Exception {
		FirmaRepresentLegalBean firmaLegalBean =(FirmaRepresentLegalBean) command;
		FirmaRepresentLegalBean firmaBean = new FirmaRepresentLegalBean();
				
		String contentOriginal = response.getContentType();
		String nombreArchivo =	request.getParameter("recurso");
		String extension = nombreArchivo.substring(nombreArchivo.lastIndexOf('.'));
		String nombreArchivoConsultado= nombreArchivo.substring((nombreArchivo.lastIndexOf('/')+1), nombreArchivo.lastIndexOf('.'));
 		File archivoFile = new File(nombreArchivo); 		
 		try{	 			 					
	 		FileInputStream fileInputStream = new FileInputStream(archivoFile);
	 		if(extension.equals(".jpg")){
					//response.setContentType("application/jpeg");
					response.addHeader("Content-Disposition","");
			 		response.setContentType(contentOriginal);
			}else if(extension.equals(".jpeg")){
					//response.setContentType("image/pjpeg");
					response.addHeader("Content-Disposition","");
			 		response.setContentType(contentOriginal);
			}else{
	 				// no cambiar el  attachment por inline en este archivo, porque asi se utiliza
	 				response.addHeader("Content-Disposition","attachment; filename=" +nombreArchivoConsultado+extension);
			 		response.setContentType(contentOriginal);
	 		}
	 		
	 		response.setContentLength((int) archivoFile.length()); 		
	 		int bytes;
	 		
			while ((bytes = fileInputStream.read()) != -1) {
				response.getOutputStream().write(bytes);
			}
	
			response.getOutputStream().flush();
			response.getOutputStream().close();
			
			return null;
	 	}catch(Exception e){
	 		String htmlString = Constantes.htmlErrorVerArchivoCliente;
 			response.addHeader("Content-Disposition","");
	 		response.setContentType(contentOriginal);
	 		response.setContentLength(htmlString.length());
 			return new ModelAndView("resultadoTransaccionReporteVista", "reporte", htmlString);
	 	}
	}

	public FirmaRepresentLegalServicio getFirmaRepresentLegalServicio() {
		return firmaRepresentLegalServicio;
	}

	public void setFirmaRepresentLegalServicio(
			FirmaRepresentLegalServicio firmaRepresentLegalServicio) {
		this.firmaRepresentLegalServicio = firmaRepresentLegalServicio;
	}
}
