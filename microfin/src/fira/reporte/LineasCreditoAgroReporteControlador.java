package fira.reporte;



import fira.servicio.CreditosAgroServicio;
import general.bean.ParametrosAuditoriaBean;
import herramientas.Utileria;

import java.io.ByteArrayOutputStream;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import credito.servicio.LineasCreditoServicio;
import credito.bean.LineasCreditoBean;

import soporte.servicio.ParametrosSisServicio;

public class LineasCreditoAgroReporteControlador extends AbstractCommandController{
    ParametrosSisServicio	parametrosSisServicio	= null;
	LineasCreditoServicio	lineasCreditoServicio	= null;
	String					nomReporte				= null;
	String					successView				= null;

    public static interface Enum_Con_TipRepor {
		int	ReporPDF	= 1;
		int	ReporEXCEL	= 2;
	}
	
	public LineasCreditoAgroReporteControlador() {
		setCommandClass(LineasCreditoBean.class);
		setCommandName("lineasCreditoBean");
	}
	
	@Override
    protected ModelAndView handle(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {
		
    	LineasCreditoBean lineasCreditoBean = (LineasCreditoBean) command;
		
		int tipoReporte = (request.getParameter("tipoReporte") != null) ? Integer.parseInt(request.getParameter("tipoReporte")) : 0;
		int tipoLista = (request.getParameter("tipoLista") != null) ? Integer.parseInt(request.getParameter("tipoLista")) : 0;
		
		String htmlString = "";
		try {
		   switch(tipoReporte){
					
				case Enum_Con_TipRepor.ReporPDF:
					ByteArrayOutputStream htmlStringPDF = repLineaCreditoAgroPDF(lineasCreditoBean, nomReporte, response);
				break;
				case Enum_Con_TipRepor.ReporEXCEL:		
					lineasCreditoServicio.reporteLineaCreditoAgroExcel(lineasCreditoBean, response);
				break;
		   }
		} catch(Exception exception) {
			exception.printStackTrace();
		}
		return null;
	}
	
    
	// Reporte de saldos totales de credito en pdf
	public ByteArrayOutputStream repLineaCreditoAgroPDF(LineasCreditoBean lineasCreditoBean, String nomReporte, HttpServletResponse response) {
		ByteArrayOutputStream htmlStringPDF = null;
		try {
			htmlStringPDF = lineasCreditoServicio.creaRepLineasCreditoPDF(lineasCreditoBean, nomReporte);
			response.addHeader("Content-Disposition", "inline; filename=lineasCreditoAgro.pdf");
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

    public String getNomReporte() {
		return nomReporte;
	}
	
	public void setNomReporte(String nomReporte) {
		this.nomReporte = nomReporte;
	}
	
	public ParametrosSisServicio getParametrosSisServicio() {
		return parametrosSisServicio;
	}
	
	public void setParametrosSisServicio(ParametrosSisServicio parametrosSisServicio) {
		this.parametrosSisServicio = parametrosSisServicio;
	}
	
	public String getSuccessView() {
		return successView;
	}
	
	public void setSuccessView(String successView) {
		this.successView = successView;
	}

	public LineasCreditoServicio getLineasCreditoServicio() {
		return lineasCreditoServicio;
	}

	public void setLineasCreditoServicio(LineasCreditoServicio lineasCreditoServicio) {
		this.lineasCreditoServicio = lineasCreditoServicio;
	}
}
