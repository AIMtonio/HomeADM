package buroCredito.controlador;

import general.bean.ParametrosSesionBean;
import herramientas.Constantes;

import java.io.File;
import java.io.FileInputStream;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import soporte.PropiedadesBuroCreditoBean;
import soporte.PropiedadesSAFIBean;
import buroCredito.bean.EnvioCintaCirculoBean;
import buroCredito.servicio.EnvioCintaCirculoServicio;

public class CirculoArchivosVerVtaCarControlador extends AbstractCommandController{
		
	EnvioCintaCirculoServicio envioCintaCirculoServicio = null;
	ParametrosSesionBean parametrosSesionBean = null;
	
	public CirculoArchivosVerVtaCarControlador(){
 		setCommandClass(EnvioCintaCirculoBean.class);
 		setCommandName("EnvioCintaCirculoBean");
 	}

	public static interface Enum_Rep {
		int personasFisicas  	 = 1;
		int personasMorales  	 = 2;
	}

 	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {

 		EnvioCintaCirculoBean cintaCirculoBean = (EnvioCintaCirculoBean) command;
 		String contentOriginal = response.getContentType(); 	
 		
 		try{	 			 	

 			int tipoReporte =(request.getParameter("tipoReporte")!=null) ? Integer.parseInt(request.getParameter("tipoReporte")): 0;
 			
 			switch(tipoReporte){
 				case Enum_Rep.personasFisicas:
		 	 		String nombreArchivo = envioCintaCirculoServicio.generaArchivoEnvioCirculoCreditoVtaCar(cintaCirculoBean);
		 	 		String rutaArchivo = PropiedadesBuroCreditoBean.propiedadesBuroCredito.getProperty(parametrosSesionBean.getOrigenDatos()+".RutaArchivoEnvioCirculo")+nombreArchivo;
		 	 		File archivoFile = new File(rutaArchivo);	 
		 			//Se reeamplaza el nombre del archivo por guiones por problemas en firefox
		 	 		String nombreArchivoConGuion = nombreArchivo.replace(" ","_");
			 		
			 		FileInputStream fileInputStream = new FileInputStream(archivoFile);	 		
			 			// no cambiar el  attachment por inline en este archivo, porque asi se utiliza
				 			 				response.addHeader("Content-Disposition","attachment; filename=" +nombreArchivoConGuion);
					 				 		response.setContentType(contentOriginal);
			
			 		response.setContentLength((int) archivoFile.length()); 		
			 		int bytes;
			 		
					while ((bytes = fileInputStream.read()) != -1) {
						response.getOutputStream().write(bytes);
					}
			
					response.getOutputStream().flush();
					response.getOutputStream().close();
 				break;
 			}			
			
			return null;
			
 		}catch (Exception e) {
 			e.printStackTrace();
 			String htmlString = Constantes.htmlErrorReporteCirculo;
 			response.addHeader("Content-Disposition","");
	 		response.setContentType(contentOriginal);
	 		response.setContentLength(htmlString.length());
 			return new ModelAndView("resultadoTransaccionReporteVista", "reporte", htmlString);
		}
 		
 	}

	// ------ Getters y Setters -----------------------------------------------------------------
 	
	public EnvioCintaCirculoServicio getEnvioCintaCirculoServicio() {
		return envioCintaCirculoServicio;
	}


	public void setEnvioCintaCirculoServicio(
			EnvioCintaCirculoServicio envioCintaCirculoServicio) {
		this.envioCintaCirculoServicio = envioCintaCirculoServicio;
	}

	
	public ParametrosSesionBean getParametrosSesionBean() {
		return parametrosSesionBean;
	}

	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}
 	
 }








