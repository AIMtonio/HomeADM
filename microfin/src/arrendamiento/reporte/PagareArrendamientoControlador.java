package arrendamiento.reporte;

import java.io.ByteArrayOutputStream;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import cliente.bean.ReporteApoyoEscolarSolBean;

import arrendamiento.bean.ArrendamientosBean;
import arrendamiento.servicio.ArrendamientosServicio;


public class PagareArrendamientoControlador extends AbstractCommandController{
	ArrendamientosServicio arrendamientosServicio = null;
	String nombreReporte = null;
	String successView = null;		   

	public PagareArrendamientoControlador() {
		setCommandClass(ArrendamientosBean.class);
 		setCommandName("arrendamientosBean");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {

		ArrendamientosBean arrendamientosBean = (ArrendamientosBean) command;
		
		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?Integer.parseInt(request.getParameter("tipoTransaccion")):	0;
		ByteArrayOutputStream htmlString = crearPagarePDF(tipoTransaccion, nombreReporte, response, request);
		
		return new ModelAndView(getSuccessView(), "reporte", htmlString);
	}
	
	
	public ByteArrayOutputStream crearPagarePDF(int tipoReporte,String nomReporte, HttpServletResponse response, HttpServletRequest request){
		ByteArrayOutputStream htmlStringPDF = null;
		try {
			htmlStringPDF = arrendamientosServicio.reporteArrendamiento(tipoReporte, request, nombreReporte);
			response.addHeader("Content-Disposition","inline; filename=PagareArrendamiento.pdf");
			response.setContentType("application/pdf");
			byte[] bytes = htmlStringPDF.toByteArray();
			response.getOutputStream().write(bytes,0,bytes.length);
			response.getOutputStream().flush();
			response.getOutputStream().close();			

		} catch (Exception e) {
			e.printStackTrace();
		}
	return htmlStringPDF;
	}// reporte PDF

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

	public ArrendamientosServicio getArrendamientosServicio() {
		return arrendamientosServicio;
	}

	public void setArrendamientosServicio(
			ArrendamientosServicio arrendamientosServicio) {
		this.arrendamientosServicio = arrendamientosServicio;
	}
}
