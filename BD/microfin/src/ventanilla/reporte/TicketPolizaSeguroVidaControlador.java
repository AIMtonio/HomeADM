package ventanilla.reporte;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import ventanilla.bean.CajasTransferBean;
import ventanilla.bean.IngresosOperacionesBean;
import ventanilla.servicio.IngresosOperacionesServicio;

public class TicketPolizaSeguroVidaControlador extends AbstractCommandController {
	IngresosOperacionesServicio ingresosOperacionesServicio = null;
	String nombreReporte = null;
	String successView = null;		
	public TicketPolizaSeguroVidaControlador(){
		setCommandClass(IngresosOperacionesBean.class);
		setCommandName("cobroSeguroVida");
	}
	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {
		// TODO Auto-generated method stub
		
		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
 								Integer.parseInt(request.getParameter("tipoTransaccion")):
								0;
 		
		String htmlString = ingresosOperacionesServicio.reporteTicket(tipoTransaccion, request, getNombreReporte());		
		
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

	public void setIngresosOperacionesServicio(
			IngresosOperacionesServicio ingresosOperacionesServicio) {
		this.ingresosOperacionesServicio = ingresosOperacionesServicio;
	}


}
