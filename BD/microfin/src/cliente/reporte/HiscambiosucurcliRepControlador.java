package cliente.reporte;


import java.io.ByteArrayOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.log4j.Logger;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;
import cliente.bean.HiscambiosucurcliBean;
import cliente.servicio.HiscambiosucurcliServicio;

   
public class HiscambiosucurcliRepControlador  extends AbstractCommandController{

	HiscambiosucurcliServicio hiscambiosucurcliServicio = null;
	String nomReporte= null;
	String nombreReporte= null;
	String successView = null;
	protected final Logger loggerSAFI = Logger.getLogger("SAFI");
	
	public static interface Enum_Con_TipRepor {
		  int  reportePDF  = 1 ;		
		  int  reporteFormatoSucPDF=2;
		}
	
	
	public HiscambiosucurcliRepControlador () {
		setCommandClass(HiscambiosucurcliBean.class);
		setCommandName("hiscambiosucurcliBean");
	}

	
	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors)throws Exception {
		
		HiscambiosucurcliBean bean = (HiscambiosucurcliBean) command;

	int tipoReporte =(request.getParameter("tipoReporte")!=null)? Integer.parseInt(request.getParameter("tipoReporte")): 0;
	
	
	switch(tipoReporte){	
		case Enum_Con_TipRepor.reportePDF:
			ByteArrayOutputStream htmlStringPDF = reportePDF(tipoReporte,bean, nomReporte, response);
		break;
		case Enum_Con_TipRepor.reporteFormatoSucPDF:
			ByteArrayOutputStream htmlStringPDFS = formatoPDF(bean, nombreReporte, response,request);
		break;
	}	
				
		return null;	
	}

		
	/* Reporte de apoyo escolar en PDF */
	public ByteArrayOutputStream reportePDF(int tipoReporte,HiscambiosucurcliBean bean, String nomReporte, HttpServletResponse response){
		ByteArrayOutputStream htmlStringPDF = null;
		try {
					htmlStringPDF = hiscambiosucurcliServicio.reporteCambiosSucursal(tipoReporte,bean, nomReporte);
					response.addHeader("Content-Disposition","inline; filename=ReporteCambiosSucursal.pdf");
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
	
	
	/* Reporte de apoyo escolar en PDF */
	public ByteArrayOutputStream formatoPDF(HiscambiosucurcliBean bean, String nomReporte, HttpServletResponse response,HttpServletRequest request){
		ByteArrayOutputStream htmlStringPDF = null;
		try {
					htmlStringPDF = hiscambiosucurcliServicio.cambioSucFormato(bean,request, nomReporte);
					response.addHeader("Content-Disposition","inline; filename=FormatoCambioSucursal.pdf");
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
	public HiscambiosucurcliServicio getHiscambiosucurcliServicio() {
		return hiscambiosucurcliServicio;
	}
	public void setHiscambiosucurcliServicio(
			HiscambiosucurcliServicio hiscambiosucurcliServicio) {
		this.hiscambiosucurcliServicio = hiscambiosucurcliServicio;
	}


	public String getNombreReporte() {
		return nombreReporte;
	}


	public void setNombreReporte(String nombreReporte) {
		this.nombreReporte = nombreReporte;
	}
	
}