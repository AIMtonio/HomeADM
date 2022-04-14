package cedes.controlador;

	import herramientas.Constantes;
	import java.io.File;
	import java.io.FileInputStream;

	import javax.servlet.http.HttpServletRequest;
	import javax.servlet.http.HttpServletResponse;

	import org.springframework.validation.BindException;
	import org.springframework.web.servlet.ModelAndView;
	import org.springframework.web.servlet.mvc.AbstractCommandController;
	import cedes.bean.CedesArchivosBean;
	import cedes.servicio.CedesFileUploadServicio;



	public class CedesFileVerArchivoControlador extends AbstractCommandController{
		CedesFileUploadServicio cedesFileUploadServicio = null;		 
			
	 	public CedesFileVerArchivoControlador(){
	 		setCommandClass(CedesArchivosBean.class);
	 		setCommandName("cedesArchivosBean");
	 	}


	 	protected ModelAndView handle(HttpServletRequest request,
				  HttpServletResponse response,
				  Object command,
				  BindException errors) throws Exception {

	 		CedesArchivosBean fileBean = (CedesArchivosBean) command;
	 		CedesArchivosBean cedesArchivos = new CedesArchivosBean();
	 		
			int tipoConsulta = Integer.parseInt(request.getParameter("tipoConsulta"));
	 		 
			cedesArchivos = cedesFileUploadServicio.consultaArCuenta(tipoConsulta, fileBean);
	 		String contentOriginal = response.getContentType();
	 		
	 		String nombreArchivo =	cedesArchivos.getRecurso();
	 		
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


		public void setCedesFileUploadServicio(CedesFileUploadServicio cedesFileUploadServicio) {
			this.cedesFileUploadServicio = cedesFileUploadServicio;
		}
	 	
	 }

