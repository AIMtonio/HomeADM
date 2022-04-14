package inversiones.reporte;

import herramientas.Utileria;
import inversiones.bean.TasasInversionBean;
import inversiones.servicio.TasasInversionServicio;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

public class TasasInversionRepControlador extends AbstractCommandController{
	
	TasasInversionServicio tasasInversionServicio = null;
	String nombreReporte = null;
	String successView = null;
	
	public TasasInversionRepControlador(){
		setCommandClass(TasasInversionBean.class);
		setCommandName("tasasInversionBean");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {
		
		TasasInversionBean tasasInversionBean = (TasasInversionBean) command;
																					   
		String htmlString = tasasInversionServicio.reporteTasaInversion(tasasInversionBean, nombreReporte);
		
		return new ModelAndView(getSuccessView(), "reporte", htmlString);
		
	}
	
	
	
	
	public void setTasasInversionServicio(TasasInversionServicio tasasInversionServicio) {
		this.tasasInversionServicio = tasasInversionServicio;
	}

	public void setNombreReporte(String nombreReporte) {
		this.nombreReporte = nombreReporte;
	}	
	
	private String getNombreReporte() {
		return nombreReporte;
	}

	public void setSuccessView(String successView) {
		this.successView = successView;
	}

	private String getSuccessView() {
		return successView;
	}

}
