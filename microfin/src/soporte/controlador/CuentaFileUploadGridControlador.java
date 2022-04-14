package soporte.controlador;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import soporte.bean.CuentaArchivosBean;
import soporte.servicio.FileUploadServicio;

public class CuentaFileUploadGridControlador extends AbstractCommandController {
	FileUploadServicio fileUploadServicio = null;
	

	public CuentaFileUploadGridControlador() {
		setCommandClass(CuentaArchivosBean.class);
		setCommandName("cuentaArchivo");
	}
		
	protected ModelAndView handle(HttpServletRequest request,
								  HttpServletResponse response,
								  Object command,
								  BindException errors) throws Exception {
				
		CuentaArchivosBean ctaArchivo = (CuentaArchivosBean) command;
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		List ctaArchivoList =	fileUploadServicio.listaArchivosCta(tipoLista, ctaArchivo);
		
		
				
		return new ModelAndView("soporte/cuentaFileUploadGridVista", "cuentaArchivo", ctaArchivoList);
	}
	
	
	public void setFileUploadServicio(FileUploadServicio fileUploadServicio) {
		this.fileUploadServicio = fileUploadServicio;
	}


}
