package fira.reporte;

import herramientas.Utileria;

import java.io.ByteArrayOutputStream;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import credito.bean.CreditosBean;
import fira.servicio.ContratosFiraServicio;

public class ContratosFiraRepControlador extends AbstractCommandController {
	
	ContratosFiraServicio contratosFiraServicio = null;
	String nombreReporteFisica = null;
	String nombreReporteMoral = null;
	String nombreReporteAdminUnico = null;
	String successView = null;
	
	public ContratosFiraRepControlador() {
		setCommandClass(CreditosBean.class);
		setCommandName("creditosBean");
	}
	
	public static interface Enum_TipoReporte {
		int PersonaFisica	= 1;
		int PersonaMoral	= 2;
		int AdminUnico		= 3;
	}
	
	@Override
	protected ModelAndView handle(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {
		CreditosBean creditosBean = (CreditosBean) command;
		int tipoReporte = Utileria.convierteEntero(request.getParameter("tipoReporte"));
		switch(tipoReporte){
			case Enum_TipoReporte.PersonaFisica:
				crearCaratulaContrato(nombreReporteFisica,response, request, creditosBean);
				break;
			case Enum_TipoReporte.PersonaMoral:
				crearCaratulaContrato(nombreReporteMoral,response, request,creditosBean);
				break;
			case Enum_TipoReporte.AdminUnico:
				crearCaratulaContrato(nombreReporteAdminUnico,response, request,creditosBean);
				break;
		}
		return null;
	}
	
	public ByteArrayOutputStream crearCaratulaContrato(String nomReporte, HttpServletResponse response, HttpServletRequest request, CreditosBean bean) {
		ByteArrayOutputStream htmlStringPDF = null;
		try {
			htmlStringPDF = contratosFiraServicio.contrato(request, nomReporte, bean);
			response.addHeader("Content-Disposition", "inline; filename=AnexoContrato.pdf");
			response.setContentType("application/pdf");
			byte[] bytes = htmlStringPDF.toByteArray();
			response.getOutputStream().write(bytes, 0, bytes.length);
			response.getOutputStream().flush();
			response.getOutputStream().close();
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return htmlStringPDF;
	}
	
	public ContratosFiraServicio getContratosFiraServicio() {
		return contratosFiraServicio;
	}
	
	public void setContratosFiraServicio(ContratosFiraServicio contratosFiraServicio) {
		this.contratosFiraServicio = contratosFiraServicio;
	}

	public String getNombreReporteFisica() {
		return nombreReporteFisica;
	}

	public void setNombreReporteFisica(String nombreReporteFisica) {
		this.nombreReporteFisica = nombreReporteFisica;
	}

	public String getNombreReporteMoral() {
		return nombreReporteMoral;
	}

	public void setNombreReporteMoral(String nombreReporteMoral) {
		this.nombreReporteMoral = nombreReporteMoral;
	}

	public String getNombreReporteAdminUnico() {
		return nombreReporteAdminUnico;
	}

	public void setNombreReporteAdminUnico(String nombreReporteAdminUnico) {
		this.nombreReporteAdminUnico = nombreReporteAdminUnico;
	}

	public String getSuccessView() {
		return successView;
	}

	public void setSuccessView(String successView) {
		this.successView = successView;
	}
	
}