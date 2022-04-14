package ventanilla.controlador;

import java.io.ByteArrayOutputStream;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import ventanilla.bean.CajasVentanillaBean;
import ventanilla.servicio.CajasVentanillaServicio;

public class DetalleArqueoControlador extends AbstractCommandController{
	
	public static interface Enum_Con_TipRepor {
		  int  ReporPantalla= 1 ;
		  int  ReporPDF= 2 ;
	}
	
	CajasVentanillaServicio cajasVentanillaServicio = null;
	String nombreReporte = null;
	String successView = null;
	
	public DetalleArqueoControlador(){
		setCommandClass(CajasVentanillaBean.class);
		setCommandName("cajasVentanillaBean");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {
		String htmlString = "";
		cajasVentanillaServicio.getCajasVentanillaDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		if ((request.getParameter("numOperacion").equals("41")) || (request.getParameter("numOperacion").equals("42")) || (request.getParameter("numOperacion").equals("16")) || (request.getParameter("numOperacion").equals("36"))){
			htmlString = cajasVentanillaServicio.reporteDetalleArqueoTransfer(request, nombreReporte);
		}else{
			htmlString = cajasVentanillaServicio.reporteDetalleArqueo(request, nombreReporte);
		}
		
		return new ModelAndView(getSuccessView(), "reporte", htmlString);
	}

	public void setCajasVentanillaServicio(
			CajasVentanillaServicio cajasVentanillaServicio) {
		this.cajasVentanillaServicio = cajasVentanillaServicio;
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
}