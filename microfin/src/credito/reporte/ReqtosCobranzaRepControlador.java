package credito.reporte;

import herramientas.Utileria;

import java.io.ByteArrayOutputStream;
import java.util.List;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFDataFormat;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.ss.util.CellRangeAddress;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import credito.bean.CreditosBean;
import credito.bean.RepCalificacionPorcResBean;
import credito.bean.RepEstimacionesCredPrevBean;
import credito.reporte.EstimacionesCredPrevRepControlador.Enum_Con_TipRepor;
import credito.servicio.CreditosServicio;

public class ReqtosCobranzaRepControlador extends AbstractCommandController{

	CreditosServicio creditosServicio = null;
	String nomReportePrim= null;
	String nombReporteSeg = null;
	String nombReporteTer = null;
	String successView = null;
	
	public static interface Enum_Con_TipRepor {
		  int  ReporPDF= 1 ;
		  int  ReporExcel= 2 ;
		  int  ReporPDF2= 3 ;
		  int  ReporExcel2= 4 ;
		  int  ReporPDF3= 5 ;
		  int  ReporExcel3= 6 ;
		}
	public ReqtosCobranzaRepControlador () {
		setCommandClass(CreditosBean.class);
		setCommandName("creditosBean");
	}

	   
	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors)throws Exception {
		
	CreditosBean creditosBean = (CreditosBean) command;

	int tipoReporte =(request.getParameter("tipoReporte")!=null)?
			Integer.parseInt(request.getParameter("tipoReporte")):
		0;
	int tipoLista =(request.getParameter("tipoLista")!=null)?
			Integer.parseInt(request.getParameter("tipoLista")):
		0;
			
	String htmlString= "";
			
		switch(tipoReporte){
			case Enum_Con_TipRepor.ReporPDF:
				ByteArrayOutputStream htmlStringPDF = RepPrimerReqtoPDF(creditosBean, nomReportePrim, response);
			break;
//			case Enum_Con_TipRepor.ReporExcel:		
//				 List listaReportes = estimacionesCredPrevExcel(tipoLista,creditosBean,response);
//			break;
			case Enum_Con_TipRepor.ReporPDF2:
				ByteArrayOutputStream htmlStringPDF2 = RepSegundoReqtoPDF(creditosBean, nombReporteSeg, response);
			break;
//			case Enum_Con_TipRepor.ReporExcel2:		
//				 List listaReportes2 = calificacionesPorcResExcel(tipoLista,creditosBean,response);
//			break;
			case Enum_Con_TipRepor.ReporPDF3:
				ByteArrayOutputStream htmlStringPDF3 = RepTercerReqtoPDF(creditosBean, nombReporteTer, response);
			break;
//			case Enum_Con_TipRepor.ReporExcel3:		
//				 List listaReportes3 = calificacionesPorcResExcel(tipoLista,creditosBean,response);
//			break;
		}
		
		if(tipoReporte == CreditosBean.ReporPantalla ){
				return new ModelAndView(getSuccessView(), "reporte", htmlString);
		}else {
			return null;
		}
			
	}

		
	// Reporte de saldos de capital en pdf
	public ByteArrayOutputStream RepPrimerReqtoPDF(CreditosBean creditosBean, String nomReportePrim, HttpServletResponse response){
		ByteArrayOutputStream htmlStringPDF = null;
		try {
			htmlStringPDF = creditosServicio.creaPrimReqtosConbranzaPDF(creditosBean, nomReportePrim);
			response.addHeader("Content-Disposition","inline; filename=PrimerRequerimiento.pdf");
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
	// Reporte de saldos de capital en pdf
		public ByteArrayOutputStream RepSegundoReqtoPDF(CreditosBean creditosBean, String nombReporteSeg, HttpServletResponse response){
			ByteArrayOutputStream htmlStringPDF2 = null;
			try {
				htmlStringPDF2 = creditosServicio.creaSegReqtosConbranzaPDF(creditosBean, nombReporteSeg);
				response.addHeader("Content-Disposition","inline; filename=SegundoRequerimiento.pdf");
				response.setContentType("application/pdf");
				byte[] bytes = htmlStringPDF2.toByteArray();
				response.getOutputStream().write(bytes,0,bytes.length);
				response.getOutputStream().flush();
				response.getOutputStream().close();
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}		
		return htmlStringPDF2;
		}	
	
		// Reporte de saldos de capital en pdf
				public ByteArrayOutputStream RepTercerReqtoPDF(CreditosBean creditosBean, String nombReporteTer, HttpServletResponse response){
					ByteArrayOutputStream htmlStringPDF3 = null;
					try {
						htmlStringPDF3 = creditosServicio.creaTerReqtosConbranzaPDF(creditosBean, nombReporteTer);
						response.addHeader("Content-Disposition","inline; filename=TercerRequerimiento.pdf");
						response.setContentType("application/pdf");
						byte[] bytes = htmlStringPDF3.toByteArray();
						response.getOutputStream().write(bytes,0,bytes.length);
						response.getOutputStream().flush();
						response.getOutputStream().close();
					} catch (Exception e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}		
				return htmlStringPDF3;
				}

	public void setCreditosServicio(CreditosServicio creditosServicio) {
		this.creditosServicio = creditosServicio;
	}

	public String getSuccessView() {
		return successView;
	}
	
	public void setSuccessView(String successView) {
		this.successView = successView;
	}


	public CreditosServicio getCreditosServicio() {
		return creditosServicio;
	}


	public String getNomReportePrim() {
		return nomReportePrim;
	}


	public String getNombReporteSeg() {
		return nombReporteSeg;
	}


	public String getNombReporteTer() {
		return nombReporteTer;
	}


	public void setNomReportePrim(String nomReportePrim) {
		this.nomReportePrim = nomReportePrim;
	}


	public void setNombReporteSeg(String nombReporteSeg) {
		this.nombReporteSeg = nombReporteSeg;
	}


	public void setNombReporteTer(String nombReporteTer) {
		this.nombReporteTer = nombReporteTer;
	}

}
