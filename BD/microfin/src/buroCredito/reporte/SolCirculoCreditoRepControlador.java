package buroCredito.reporte;

import java.io.BufferedWriter;
import java.io.ByteArrayOutputStream;
import java.io.FileInputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import buroCredito.bean.SolBuroCreditoBean;
import buroCredito.servicio.SolBuroCreditoServicio;

import credito.bean.CreditosBean;
import credito.bean.ReporteMinistraBean;
import credito.reporte.EnvioBuroCreditoRepControlador.Enum_Con_TipRepor;
import credito.servicio.CreditosServicio;

public class SolCirculoCreditoRepControlador  extends AbstractCommandController  {
	
	public static interface Enum_Con_TipRepor {
		  int  ReporPDF= 1 ;
		  int  ReporAuntCredPDF= 2 ;
		  int  ReporAutorizaSolCre =  3;
	}
	
	SolBuroCreditoServicio solBuroCreditoServicio = null;
	String nomReporte= null;
	String successView = null;
	
	public SolCirculoCreditoRepControlador () {
		setCommandClass(SolBuroCreditoBean.class);
		setCommandName("solBuroCreditoBean");
	}

	@Override
	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors)throws Exception {
		
		SolBuroCreditoBean solBuroCredito = (SolBuroCreditoBean) command;
		int tipoReporte =(request.getParameter("tipoReporte")!=null)?
				Integer.parseInt(request.getParameter("tipoReporte")):
			0;
		int tipoLista =(request.getParameter("tipoLista")!=null)?
				Integer.parseInt(request.getParameter("tipoLista")):
		0;
			
			solBuroCreditoServicio.getSolBuroCreditoDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
			String htmlString= "";
			
				switch(tipoReporte){
				case Enum_Con_TipRepor.ReporPDF:
					ByteArrayOutputStream htmlStringPDF = reporteCCPDF(solBuroCredito, nomReporte, response);
				break;
				
				case Enum_Con_TipRepor.ReporAuntCredPDF:
					ByteArrayOutputStream htmlStringAutPDF = reporteAutorizacionPDF(solBuroCredito, nomReporte, response);
				break;
				
				case Enum_Con_TipRepor.ReporAutorizaSolCre:
					ByteArrayOutputStream htmlStringAutSolPDF = reporteAutoSolRepCreditoPDF(solBuroCredito, nomReporte, response);
				break;
				
				
				}
					return null;
			}
			
			// Reporte CC PDF
			public ByteArrayOutputStream reporteCCPDF(SolBuroCreditoBean solBuroCreditoBean, String nomReporte, HttpServletResponse response){
			ByteArrayOutputStream htmlStringPDF = null;
			try { 
				htmlStringPDF = solBuroCreditoServicio.reporteCCPDF(solBuroCreditoBean, nomReporte);
				response.addHeader("Content-Disposition","inline; filename=ReporteCC.pdf");
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
			
			// Reporte Autorizacion Credito CC
			
			public ByteArrayOutputStream reporteAutorizacionPDF(SolBuroCreditoBean solBuroCreditoBean, String nomReporte, HttpServletResponse response){
			ByteArrayOutputStream htmlStringAutPDF = null;
			try { 
				htmlStringAutPDF = solBuroCreditoServicio.reporteAutorizacionPDF(solBuroCreditoBean, nomReporte);
				response.addHeader("Content-Disposition","inline; filename=ReporteCC.pdf");
				response.setContentType("application/pdf");
				byte[] bytes = htmlStringAutPDF.toByteArray();
				response.getOutputStream().write(bytes,0,bytes.length);
				response.getOutputStream().flush();
				response.getOutputStream().close();
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}		
			return htmlStringAutPDF;
			}
				
			// Reporte Autorizacion Autorización para Solicitar Reportes de Credito Personas Físicas 
			
						public ByteArrayOutputStream reporteAutoSolRepCreditoPDF(SolBuroCreditoBean solBuroCreditoBean, String nomReporte, HttpServletResponse response){
						ByteArrayOutputStream htmlStringAutPDF = null;
						try { 
							htmlStringAutPDF = solBuroCreditoServicio.reporteAutoSolRepCreditoPDF(solBuroCreditoBean, nomReporte);
							response.addHeader("Content-Disposition","inline; filename=AutorizacionConsulta.pdf");
							response.setContentType("application/pdf");
							byte[] bytes = htmlStringAutPDF.toByteArray();
							response.getOutputStream().write(bytes,0,bytes.length);
							response.getOutputStream().flush();
							response.getOutputStream().close();
						} catch (Exception e) {
							// TODO Auto-generated catch block
							e.printStackTrace();
						}		
						return htmlStringAutPDF;
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
