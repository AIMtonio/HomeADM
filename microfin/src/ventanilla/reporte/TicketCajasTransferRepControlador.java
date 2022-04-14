package ventanilla.reporte;

import java.io.ByteArrayOutputStream;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import ventanilla.bean.CajasTransferBean;
import ventanilla.bean.IngresosOperacionesBean;
import ventanilla.reporte.TiraAuditoraRepControlador.Enum_Con_TipRepor;
import ventanilla.servicio.CajasTransferServicio;

public class TicketCajasTransferRepControlador extends AbstractCommandController{
	CajasTransferServicio cajasTransferServicio = null;
	String nombreReporte = null;
	String successView = null;	
	public TicketCajasTransferRepControlador(){
		setCommandClass(CajasTransferBean.class);
		setCommandName("cajasTransferBean");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {

		CajasTransferBean cajasTransfer = (CajasTransferBean) command;
		
		int tipoReporte =(request.getParameter("tipoReporte")!=null)?
								Integer.parseInt(request.getParameter("tipoReporte")):
								0;
		
		String htmlString = cajasTransferServicio.reporteTicketTransfer(tipoReporte, request, getNombreReporte());		
		
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

	public void setCajasTransferServicio(CajasTransferServicio cajasTransferServicio) {
		this.cajasTransferServicio = cajasTransferServicio;
	}
	
}
