
package tarjetas.reporte;
import java.io.ByteArrayOutputStream;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import tarjetas.bean.TarjetaDebitoBean;
import tarjetas.servicio.TarjetaDebitoServicio;

public class ReporteBloqDesbloqTarDebControlador  extends AbstractCommandController{

	TarjetaDebitoServicio  tarjetaDebitoServicio= null;
	String nomReporte= null;
	String successView = null;
	
	public static interface Enum_Con_TipRepor {
		  int  ReporPDF= 1 ;

		}
	public ReporteBloqDesbloqTarDebControlador () {
		setCommandClass(TarjetaDebitoBean.class);
		setCommandName("tarjetaDebitoBean");
	}
	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors)throws Exception {
		
		TarjetaDebitoBean tarjetaDebitoBean = (TarjetaDebitoBean) command;

	int tipoReporte =(request.getParameter("tipoReporte")!=null)?
			Integer.parseInt(request.getParameter("tipoReporte")):
		0;
	String htmlString= "";
			
		switch(tipoReporte){
			
			case Enum_Con_TipRepor.ReporPDF:
				ByteArrayOutputStream htmlStringPDF = BloqueoDesbloqueoTarDebRepPDF(tarjetaDebitoBean, nomReporte, response);
			break;
	
		}
			return null;
		}
			
	// Reporte de vencimientos en pdf
	public ByteArrayOutputStream BloqueoDesbloqueoTarDebRepPDF(TarjetaDebitoBean tarjetaDebitoBean, String nomReporte, HttpServletResponse response){
		ByteArrayOutputStream htmlStringPDF = null;
		try {
			htmlStringPDF = tarjetaDebitoServicio.creaReporteBloqueoDesbloqueoTarDebPDF(tarjetaDebitoBean, nomReporte);
			response.addHeader("Content-Disposition","inline; filename=ReporteBitacoraEstatus.pdf");
			response.setContentType("application/pdf");
			byte[] bytes = htmlStringPDF.toByteArray();
			response.getOutputStream().write(bytes,0,bytes.length);
			response.getOutputStream().flush();
			response.getOutputStream().close();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	return htmlStringPDF;
	}
	
	public void setTarjetaDebitoServicio(TarjetaDebitoServicio tarjetaDebitoServicio) {
		this.tarjetaDebitoServicio = tarjetaDebitoServicio;
	}
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
}

