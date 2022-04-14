package tarjetas.controlador;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;

import general.bean.MensajeTransaccionBean;



import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import tarjetas.bean.SolicitudTarDebBean;
import tarjetas.bean.TarjetaDebitoBean;
import tarjetas.servicio.SolicitudTarDebServicio;
import tarjetas.servicio.TarjetaDebitoServicio;


public class SolicitudTarDebControlador extends  SimpleFormController {	
	
	SolicitudTarDebServicio solicitudTarDebServicio= null;
	String archivoNombre="";		
	public SolicitudTarDebControlador(){
 		setCommandClass(SolicitudTarDebBean.class);
 		setCommandName("solicitudTarDeb");
 	}

	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws ServletException, IOException  {
		
		solicitudTarDebServicio.getSolicitudTarDebDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		
		SolicitudTarDebBean solicitudTarDebBean = (SolicitudTarDebBean) command;

		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
 		MensajeTransaccionBean mensaje = null;
 		
 	
						
 		mensaje = solicitudTarDebServicio.grabaTransaccion(tipoTransaccion, solicitudTarDebBean);
 		
 		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
		
	}

	public SolicitudTarDebServicio getSolicitudTarDebServicio() {
		return solicitudTarDebServicio;
	}

	public void setSolicitudTarDebServicio(
			SolicitudTarDebServicio solicitudTarDebServicio) {
		this.solicitudTarDebServicio = solicitudTarDebServicio;
	}
	




}
