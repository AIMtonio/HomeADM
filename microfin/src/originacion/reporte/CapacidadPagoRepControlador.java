package originacion.reporte;

import java.io.ByteArrayOutputStream;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import originacion.bean.CapacidadPagoBean;
import originacion.servicio.CapacidadPagoServicio;


   
public class CapacidadPagoRepControlador  extends AbstractCommandController{

	CapacidadPagoServicio capacidadPagoServicio = null;
	String nomReporte= null;
	String successView = null;
	protected final Logger loggerSAFI = Logger.getLogger("SAFI");
	
	public static interface Enum_Con_TipRepor {
		  int  reportePDF  = 1 ;		
		}
	
	
	public CapacidadPagoRepControlador () {
		setCommandClass(CapacidadPagoBean.class);
		setCommandName("capacidadPagoBean");
	}

	
	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors)throws Exception {
		
		CapacidadPagoBean bean = (CapacidadPagoBean) command;

	int tipoReporte =(request.getParameter("tipoReporte")!=null)? Integer.parseInt(request.getParameter("tipoReporte")): 0;
	
	
	switch(tipoReporte){	
		case Enum_Con_TipRepor.reportePDF:
			ByteArrayOutputStream htmlStringPDF = reportePDF(tipoReporte,bean, nomReporte, response);
		break;
	}	
				
		return null;	
	}

		
	/* Reporte de apoyo escolar en PDF */
	public ByteArrayOutputStream reportePDF(int tipoReporte,CapacidadPagoBean bean, String nomReporte, HttpServletResponse response){
		ByteArrayOutputStream htmlStringPDF = null;
		try {
			htmlStringPDF = capacidadPagoServicio.reporteCapacidadPago(tipoReporte,bean, nomReporte);
			response.addHeader("Content-Disposition","inline; filename=ReporteCapacidadPago.pdf");
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
	
	


	
	public String getNomReporte() {
		return nomReporte;
	}

	public void setNomReporte(String nomReporte) {
		this.nomReporte = nomReporte;
	}

	public String getSuccessView() {
		return successView;
	}
	
	public void setSuccessView(String successView) {
		this.successView = successView;
	}


	public CapacidadPagoServicio getCapacidadPagoServicio() {
		return capacidadPagoServicio;
	}


	public void setCapacidadPagoServicio(CapacidadPagoServicio capacidadPagoServicio) {
		this.capacidadPagoServicio = capacidadPagoServicio;
	}

	
	
}