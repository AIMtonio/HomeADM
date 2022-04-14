package nomina.reporte;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import general.bean.MensajeTransaccionBean;
import nomina.bean.ArchivoInstalBean;
import nomina.servicio.ArchivoInstalServicio;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

public class ArchivoInstalRepControlador extends AbstractCommandController{
	ArchivoInstalServicio archivoInstalServicio = null;
	String successView = null;
	
	public ArchivoInstalRepControlador(){
		setCommandClass(ArchivoInstalBean.class);
		setCommandName("archivoInstalBean");
	}
	
	protected ModelAndView handle(HttpServletRequest request,HttpServletResponse response, Object command, BindException errors)throws Exception {
		try	{
			MensajeTransaccionBean mensaje = null;
			ArchivoInstalBean archivoInstalBean = (ArchivoInstalBean)command;
			
			archivoInstalServicio.generarReporteExcel(response, archivoInstalBean);
			
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return null;
	}

	public ArchivoInstalServicio getArchivoInstalServicio() {
		return archivoInstalServicio;
	}

	public void setArchivoInstalServicio(ArchivoInstalServicio archivoInstalServicio) {
		this.archivoInstalServicio = archivoInstalServicio;
	}

	public String getSuccessView() {
		return successView;
	}

	public void setSuccessView(String successView) {
		this.successView = successView;
	}
	
}
