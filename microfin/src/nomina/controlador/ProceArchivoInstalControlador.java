package nomina.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import nomina.bean.ArchivoInstalBean;
import nomina.servicio.ArchivoInstalServicio;

import org.apache.log4j.Logger;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

public class ProceArchivoInstalControlador extends SimpleFormController{
	
	ArchivoInstalServicio archivoInstalServicio = null;

	protected final Logger loggerSAFI = Logger.getLogger("SAFI");
	
	public ProceArchivoInstalControlador(){
		setCommandClass(ArchivoInstalBean.class);
		setCommandName("archivoInstalBean");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request, 
			HttpServletResponse response, 
			Object command, 
			BindException errors) throws Exception {
		
		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
				Integer.parseInt(request.getParameter("tipoTransaccion")): 0;		
			
		ArchivoInstalBean archivoInstalBean = (ArchivoInstalBean)command;
		MensajeTransaccionBean mensaje = null;
				
		mensaje = archivoInstalServicio.grabaTransaccion(tipoTransaccion, archivoInstalBean);
		
		
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public ArchivoInstalServicio getArchivoInstalServicio() {
		return archivoInstalServicio;
	}

	public void setArchivoInstalServicio(ArchivoInstalServicio archivoInstalServicio) {
		this.archivoInstalServicio = archivoInstalServicio;
	}
	
}
