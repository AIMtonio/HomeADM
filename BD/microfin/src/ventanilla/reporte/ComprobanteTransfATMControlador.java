package ventanilla.reporte;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import ventanilla.bean.CajeroATMTransfBean;

import ventanilla.servicio.CajeroATMTransfServicio;

public class ComprobanteTransfATMControlador extends AbstractCommandController{
	CajeroATMTransfServicio  cajeroATMTransfServicio =null;
	String nombreReporte = null;
	String successView = null;	
	
	public ComprobanteTransfATMControlador() {
		setCommandClass(CajeroATMTransfBean.class);
		setCommandName("cajeroATMTransfBean");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {

		CajeroATMTransfBean cajeroATMTransf = (CajeroATMTransfBean) command;
		
		String htmlString = cajeroATMTransfServicio.comprobanteTransferATM(request, getNombreReporte());		
		
		return new ModelAndView(getSuccessView(), "reporte", htmlString);
		
	}

	public String getNombreReporte() {
		return nombreReporte;
	}

	public void setNombreReporte(String nombreReporte) {
		this.nombreReporte = nombreReporte;
	}

	public String getSuccessView() {
		return successView;
	}

	public void setSuccessView(String successView) {
		this.successView = successView;
	}

	public void setCajeroATMTransfServicio(
			CajeroATMTransfServicio cajeroATMTransfServicio) {
		this.cajeroATMTransfServicio = cajeroATMTransfServicio;
	}

	


}
