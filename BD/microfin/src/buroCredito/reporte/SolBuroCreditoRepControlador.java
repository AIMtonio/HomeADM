package buroCredito.reporte;

import java.io.ByteArrayOutputStream;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import buroCredito.bean.SolBuroCreditoBean;
import buroCredito.servicio.SolBuroCreditoServicio;

public class SolBuroCreditoRepControlador extends AbstractCommandController {

	public static interface Enum_Con_TipRepor {
		int ReporPantalla = 1;
		int ReporPDF = 2;
	}

	SolBuroCreditoServicio solBuroCreditoServicio = null;
	String nomReporte = null;
	String successView = null;

	public SolBuroCreditoRepControlador() {
		setCommandClass(SolBuroCreditoBean.class);
		setCommandName("solBuroCreditoBean");
	}

	@Override
	protected ModelAndView handle(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {

		SolBuroCreditoBean solBuroCredito = (SolBuroCreditoBean) command;
		int tipoReporte = (request.getParameter("tipoReporte") != null) ? Integer.parseInt(request.getParameter("tipoReporte")) : 0;
		int tipoLista = (request.getParameter("tipoLista") != null) ? Integer.parseInt(request.getParameter("tipoLista")) : 0;

		solBuroCreditoServicio.getSolBuroCreditoDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		String htmlString = "";

		switch (tipoReporte) {
		case Enum_Con_TipRepor.ReporPantalla:
			htmlString = solBuroCreditoServicio.reporteBC(solBuroCredito, nomReporte);
			break;

		case Enum_Con_TipRepor.ReporPDF:
			ByteArrayOutputStream htmlStringPDF = reporteBCPDF(solBuroCredito, nomReporte, response);
			break;

		}
		if (tipoReporte == Enum_Con_TipRepor.ReporPantalla) {
			return new ModelAndView(getSuccessView(), "reporte", htmlString);
		} else {
			return null;
		}

	}

	// Reporte BC PDF
	public ByteArrayOutputStream reporteBCPDF(SolBuroCreditoBean solBuroCreditoBean, String nomReporte, HttpServletResponse response) {
		ByteArrayOutputStream htmlStringPDF = null;
		try {
			htmlStringPDF = solBuroCreditoServicio.reporteBCPDF(solBuroCreditoBean, nomReporte);
			response.addHeader("Content-Disposition", "inline; filename=ReporteBC.pdf");
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

	public String getNomReporte() {
		return nomReporte;
	}

	public void setNomReporte(String nomReporte) {
		this.nomReporte = nomReporte;
	}

	public void setSolBuroCreditoServicio(
			SolBuroCreditoServicio solBuroCreditoServicio) {
		this.solBuroCreditoServicio = solBuroCreditoServicio;
	}

	public String getSuccessView() {
		return successView;
	}

	public void setSuccessView(String successView) {
		this.successView = successView;
	}

}
