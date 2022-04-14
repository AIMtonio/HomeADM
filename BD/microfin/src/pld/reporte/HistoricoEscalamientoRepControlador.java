package pld.reporte;

import java.io.ByteArrayOutputStream;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import pld.bean.ParametrosEscalaBean;
import pld.servicio.HistoricoEscalamientoRepServicio;

public class HistoricoEscalamientoRepControlador extends AbstractCommandController {
	
	HistoricoEscalamientoRepServicio historicoEscalamientoRepServicio = null;
	String successView = null;	
	String nomReporte = null;
	
	public HistoricoEscalamientoRepControlador(){
 		setCommandClass(ParametrosEscalaBean.class);
 		setCommandName("parametrosEscalaBean");
 	}

	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response, Object command, BindException errors)
			throws Exception {
		ParametrosEscalaBean imprimeHistBean = (ParametrosEscalaBean) command;
		ByteArrayOutputStream htmlStringPDF = imprimeHistorico(imprimeHistBean, response);
		return null;
	}
			
	// Reporte de Impresión de Cheques
	public ByteArrayOutputStream imprimeHistorico(ParametrosEscalaBean imprimeHistBean, HttpServletResponse response) {
		ByteArrayOutputStream htmlStringPDF = null;
		try {
			htmlStringPDF = historicoEscalamientoRepServicio.reporteHistorico(imprimeHistBean, nomReporte);
			response.addHeader("Content-Disposition", "inline; filename=ReporteHistoricoParamEscalamiento.pdf");
			response.setContentType("application/pdf");
			byte[] bytes = htmlStringPDF.toByteArray();
			response.getOutputStream().write(bytes, 0, bytes.length);
			response.getOutputStream().flush();
			response.getOutputStream().close();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return htmlStringPDF;
	}

	public String getSuccessView() {
		return successView;
	}

	public void setSuccessView(String successView) {
		this.successView = successView;
	}

	public HistoricoEscalamientoRepServicio getHistoricoEscalamientoRepServicio() {
		return historicoEscalamientoRepServicio;
	}

	public void setHistoricoEscalamientoRepServicio(
			HistoricoEscalamientoRepServicio historicoEscalamientoRepServicio) {
		this.historicoEscalamientoRepServicio = historicoEscalamientoRepServicio;
	}

	public String getNomReporte() {
		return nomReporte;
	}

	public void setNomReporte(String nomReporte) {
		this.nomReporte = nomReporte;
	}

}
