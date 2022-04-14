package tarjetas.reporte;

import java.io.ByteArrayOutputStream;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import tarjetas.bean.TarCredMovimientosBean;
import tarjetas.servicio.TarCredMovimientosServicio;

public class ReportePDFMovTarCredControlador extends AbstractCommandController{

	TarCredMovimientosServicio tarCredMovimientosServicio = null;
	String nomReporte= null;
	String successView = null;
	
	public static interface Enum_Con_TipoReporte {
		  int  ReportePDF = 1;

	}
	public ReportePDFMovTarCredControlador () {
		setCommandClass(TarCredMovimientosBean.class);
 		setCommandName("tarDebMovimientosBean");
 	}
	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors)throws Exception {
		
		TarCredMovimientosBean tarCredMovimientosBean = (TarCredMovimientosBean) command;

		int tipoReporte =(request.getParameter("tipoReporte")!=null)?
				Integer.parseInt(request.getParameter("tipoReporte")):
				0;
			String htmlString= "";
					
				switch(tipoReporte){
					case Enum_Con_TipoReporte.ReportePDF:
						ByteArrayOutputStream htmlStringPDF = MovimientosTarjetaRep(tarCredMovimientosBean, nomReporte, response);
					break;
				}
					return null;
			}
			
	// Reporte de Movimientos por Tarjeta
	public ByteArrayOutputStream MovimientosTarjetaRep(TarCredMovimientosBean tarcredMovimientosBean, String nomReporte, HttpServletResponse response){
		ByteArrayOutputStream htmlStringPDF = null;
		try {
			htmlStringPDF = tarCredMovimientosServicio.creaReporteMovimientosTarCredPDF(tarcredMovimientosBean, nomReporte);
			response.addHeader("Content-Disposition","inline; filename=ReporteMovimientosTarjeta.pdf");
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

	// Getter y Setter
	
	
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
	public TarCredMovimientosServicio getTarCredMovimientosServicio() {
		return tarCredMovimientosServicio;
	}
	public void setTarCredMovimientosServicio(
			TarCredMovimientosServicio tarCredMovimientosServicio) {
		this.tarCredMovimientosServicio = tarCredMovimientosServicio;
	}
}
