package tesoreria.controlador;

import herramientas.Constantes;

import java.io.File;
import java.io.FileInputStream;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import tesoreria.bean.FacturaprovBean;


public class FacturaVisualizaArchivoControlador extends AbstractCommandController{
	public static String  ImagenFactura="I" ;
	public static String  extXML="xml" ;
	public static String  extPDF=".pdf" ;
								 
	
 	public FacturaVisualizaArchivoControlador(){
 		setCommandClass(FacturaprovBean.class);
 		setCommandName("facturaprovBean");
 	}


 	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {

 		FacturaprovBean fileBean = (FacturaprovBean) command;
 		
 		String contentOriginal = response.getContentType();
 		
 		String nombreArchivo =	request.getParameter("recurso");
 		String tipo= request.getParameter("tipo");
 		String extarchivo = request.getParameter("extarchivo");
 		String nombreArchivoConsultado= nombreArchivo.substring((nombreArchivo.lastIndexOf('/')+1));
 		File archivoFile = new File(nombreArchivo);	 
 		try{	 			 	
	 				
	 		FileInputStream fileInputStream = new FileInputStream(archivoFile);
	 			
	 		if(tipo != ImagenFactura ){
	 			response.setContentType("application/xml");
	 			response.addHeader("Content-Disposition","attachment; filename=" +nombreArchivoConsultado);

	 		}
	 		if( extarchivo.equalsIgnoreCase(extPDF) && tipo.equals(ImagenFactura)){
	 			response.setContentType("application/"+extarchivo);
 				response.setHeader("Content-Disposition","inline; filename=" +nombreArchivoConsultado);
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
 			String htmlString = Constantes.htmlErrorVerArchivoFactura;
 			response.addHeader("Content-Disposition","");
	 		response.setContentType(contentOriginal);
	 		response.setContentLength(htmlString.length());
 			return new ModelAndView("resultadoTransaccionReporteVista", "reporte", htmlString);
		}
 		
 	}
 	
 }
