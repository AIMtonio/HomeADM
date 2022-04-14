
package tarjetas.reporte;
import java.io.ByteArrayOutputStream;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import tarjetas.bean.TarjetaCreditoBean;
import tarjetas.servicio.TarjetaCreditoServicio;




public class ReporteBloqDesbloqTarCredControlador  extends AbstractCommandController{

	TarjetaCreditoServicio  tarjetaCreditoServicio= null;
	String nomReporte= null;
	String successView = null;
	
	public static interface Enum_Con_TipRepor {
		  int  ReporPDF= 1 ;

		}
	public ReporteBloqDesbloqTarCredControlador () {
		setCommandClass(TarjetaCreditoBean.class);
		setCommandName("tarjetaDebitoBean");
	}
	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors)throws Exception {
		
		TarjetaCreditoBean tarjetaCreditoBean = (TarjetaCreditoBean) command;

	int tipoReporte =(request.getParameter("tipoReporte")!=null)?
			Integer.parseInt(request.getParameter("tipoReporte")):
		0;
	String htmlString= "";
			
		switch(tipoReporte){
			
			case Enum_Con_TipRepor.ReporPDF:
				ByteArrayOutputStream htmlStringPDF = BloqueoDesbloqueoTarDebRepPDF(tarjetaCreditoBean, nomReporte, response);
			break;
	
		}
			return null;
		}
			
	// Reporte de vencimientos en pdf
	public ByteArrayOutputStream BloqueoDesbloqueoTarDebRepPDF(TarjetaCreditoBean tarjetaCreditoBean, String nomReporte, HttpServletResponse response){
		ByteArrayOutputStream htmlStringPDF = null;
		try {
			htmlStringPDF = tarjetaCreditoServicio.creaReporteBloqueoDesbloqueoTarCredPDF(tarjetaCreditoBean, nomReporte);
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
	
	
	
	
	
	public TarjetaCreditoServicio getTarjetaCreditoServicio() {
		return tarjetaCreditoServicio;
	}
	public void setTarjetaCreditoServicio(
			TarjetaCreditoServicio tarjetaCreditoServicio) {
		this.tarjetaCreditoServicio = tarjetaCreditoServicio;
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

