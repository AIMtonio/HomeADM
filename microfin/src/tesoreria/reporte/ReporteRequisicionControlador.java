

package tesoreria.reporte;

import java.io.ByteArrayOutputStream;
import java.util.List;

import general.bean.MensajeTransaccionBean;
import herramientas.Utileria;

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


import tesoreria.servicio.ReqGastosSucServicio;
import tesoreria.bean.ReqGastosSucBean;


public class ReporteRequisicionControlador extends AbstractCommandController {
	ReqGastosSucServicio reqGastosSucServicio = null;
	String nombreReporte = null;
	String successView = null;		

	public static interface Enum_Con_TipRepor {
		  int  ReporPantalla= 1 ;
		  int  ReporPDF= 2 ;
		  int  ReporExcel= 3 ;
	}
	public ReporteRequisicionControlador(){
		setCommandClass(ReqGastosSucBean.class);
		setCommandName("requisicionBean");
	}
    
	protected ModelAndView handle(HttpServletRequest request,
				HttpServletResponse response,
				Object command,
				BindException errors) throws Exception {

		ReqGastosSucBean reqGastosSucBean = (ReqGastosSucBean) command;
		 
		int tipoReporte =(request.getParameter("tipoReporte")!=null)?
			Integer.parseInt(request.getParameter("tipoReporte")):0;
	
		int tipoLista =(request.getParameter("tipoLista")!=null)?
			Integer.parseInt(request.getParameter("tipoLista")):0;
			
			String htmlString= "";
			
				switch(tipoReporte){
				case Enum_Con_TipRepor.ReporPantalla:
					 htmlString = reqGastosSucServicio.reporteRequisicionPantalla(reqGastosSucBean, nombreReporte);
				break;
					
				case Enum_Con_TipRepor.ReporPDF:
					ByteArrayOutputStream htmlStringPDF = reporterequisicionPDF(reqGastosSucBean, nombreReporte, response);
				break;
					
				case Enum_Con_TipRepor.ReporExcel:		
					// List listaReportes = reporteMinistracionesCreditoExcel(tipoLista,creditosBean,response);
				break;
			}
				
				if(tipoReporte ==Enum_Con_TipRepor.ReporPantalla ){
					return new ModelAndView(getSuccessView(), "reporte", htmlString);
				}else {
					return null;
				}
	}
	
	
// Reporte  de  ministraciones  en PDF
	public ByteArrayOutputStream reporterequisicionPDF(ReqGastosSucBean reqGastosSucBean, String nomReporte, HttpServletResponse response){
		ByteArrayOutputStream htmlStringPDF = null;
		try {
			htmlStringPDF = reqGastosSucServicio.reporteRequisicionGastPDF(reqGastosSucBean, nomReporte);
			response.addHeader("Content-Disposition","inline; filename=ReporteReqGastos.pdf");
			response.setContentType("application/pdf");
			byte[] bytes = htmlStringPDF.toByteArray();
			response.getOutputStream().write(bytes,0,bytes.length);
			response.getOutputStream().flush();
			response.getOutputStream().close();
		} catch (Exception e) {
			e.printStackTrace();
			// TODO Auto-generated catch block
			e.printStackTrace();
		}		
	return htmlStringPDF;
	}


	public void setReqGastosSucServicio(ReqGastosSucServicio reqGastosSucServicio ) {
		this.reqGastosSucServicio = reqGastosSucServicio;
	}

	public String getNombreReporte() {
		return nombreReporte;
	}

	public void setNombreReporte(String nombreReporte) {
		this.nombreReporte = nombreReporte;
	}


	public String getSuccessView() {
		return successView;
	}
	
	public void setSuccessView(String successView) {
		this.successView = successView;
	}

}

