package pld.controlador;

import herramientas.Archivos;


import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import pld.bean.ReporteReelevantesBean;
import pld.servicio.OpeInusualesServicio;

public class PLDOpeInusualesDescargaRepControlador extends AbstractCommandController  {
	OpeInusualesServicio opeInusualesServicio = null;
	
	
	public PLDOpeInusualesDescargaRepControlador(){
		setCommandClass(ReporteReelevantesBean.class);
		setCommandName("ReelevantesCNBV");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
									HttpServletResponse response, 
									Object command, 
									BindException errors) throws Exception {
		
		String ruta = request.getParameter("ruta");
		String nombreArchivo = request.getParameter("nombreArchivo");
		
		Archivos archivoTXT= new Archivos();
		archivoTXT.obtenerArchivo(ruta, nombreArchivo, response, archivoTXT.DescargaArchivoTexto, "S");
	
		
		return null;
	}


	//--------------setter--------------------
	public void setOpeInusualesServicio(OpeInusualesServicio opeInusualesServicio) {
		this.opeInusualesServicio = opeInusualesServicio;
	}

	
	
}
