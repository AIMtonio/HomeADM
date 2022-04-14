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

import credito.bean.CreditosBean;

import soporte.servicio.ParametrosSisServicio;

public class CreditosConsolidadosRepControlador extends AbstractCommandController{
    ParametrosSisServicio	parametrosSisServicio	= null;
	CreditosAgroServicio	creditosAgroServicio	= null;
	String					nomReporte				= null;
	String					successView				= null;

    public static interface Enum_Con_TipRepor {
		int	ReporPDF	= 1;
	}
	
	public CreditosConsolidadosRepControlador() {
		setCommandClass(CreditosBean.class);
		setCommandName("creditosBean");
	}

    protected ModelAndView handle(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {
		
		CreditosBean creditosBean = (CreditosBean) command;
		
		int tipoReporte = (request.getParameter("tipoReporte") != null) ? Integer.parseInt(request.getParameter("tipoReporte")) : 0;
		int tipoLista = (request.getParameter("tipoLista") != null) ? Integer.parseInt(request.getParameter("tipoLista")) : 0;
		
		String htmlString = "";
		
		switch (tipoReporte) {
			
			case Enum_Con_TipRepor.ReporPDF :
				ByteArrayOutputStream htmlStringPDF = CredConsolidaPDF(creditosBean, nomReporte, response);
				break;
		}
		return null;
	}
	
	// Reporte de saldos totales de credito en pdf
	public ByteArrayOutputStream CredConsolidaPDF(CreditosBean creditosBean, String nomReporte, HttpServletResponse response) {
		ByteArrayOutputStream htmlStringPDF = null;
		try {
			htmlStringPDF = creditosAgroServicio.reporteCreditoConsolidaPDF(creditosBean, nomReporte);
			response.addHeader("Content-Disposition", "inline; filename=creditosConsolidadosAgro.pdf");
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

	public CreditosAgroServicio getCreditosAgroServicio() {
		return creditosAgroServicio;
	}

	public void setCreditosAgroServicio(CreditosAgroServicio creditosAgroServicio) {
		this.creditosAgroServicio = creditosAgroServicio;
	}
}
