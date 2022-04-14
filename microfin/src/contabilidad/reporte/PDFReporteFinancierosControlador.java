package contabilidad.reporte;

import java.io.ByteArrayOutputStream;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import contabilidad.bean.ReporteFinancierosBean;
import contabilidad.servicio.ReporteFinancierosServicio;



public class PDFReporteFinancierosControlador extends AbstractCommandController{
	
	
	ReporteFinancierosServicio reporteFinancierosServicio = null;
	String nombreReporte = null;
	String successView = null;	
	String nomTipoReporte = "";
	
	public static interface Enum_Con_TipRepor {
		  int  ReporPantalla= 1 ;
		  int  ReporPDF		= 2 ;
		  int  ReporteExcel  =3 ;
		  
	}
	
	public static interface Enum_Lis_ReportesFinancieros{
		String balanceContable 		= "1";
		String estadoResultado		= "2";
		String estadoFlujoEfec 		= "4";
		String estadoVariacion		= "5";
	}

 	public PDFReporteFinancierosControlador(){
 		setCommandClass(ReporteFinancierosBean.class);
 		setCommandName("reporteFinancierosBean");
 	}

 	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {

 		ReporteFinancierosBean reporteFinancierosBean = (ReporteFinancierosBean) command;
 		
 		int tipoReporte =(request.getParameter("tipoReporte")!=null)?
				Integer.parseInt(request.getParameter("tipoReporte")):
			0;
		int tipoLista =(request.getParameter("tipoLista")!=null)?
				Integer.parseInt(request.getParameter("tipoLista")):
		0;
				
		if(reporteFinancierosBean.getEstadoFinanID().equals(Enum_Lis_ReportesFinancieros.balanceContable)){
			nomTipoReporte="Balance General";
		}
		if(reporteFinancierosBean.getEstadoFinanID().equals(Enum_Lis_ReportesFinancieros.estadoResultado)){
			nomTipoReporte="Estado de Resultados";
		}
		if(reporteFinancierosBean.getEstadoFinanID().equals(Enum_Lis_ReportesFinancieros.estadoFlujoEfec)){
		nomTipoReporte="Estado de Flujos de Efectivo";
		}
		if(reporteFinancierosBean.getEstadoFinanID().equals(Enum_Lis_ReportesFinancieros.estadoVariacion)){
			nomTipoReporte="Estado de Variaciones";
		}
			
		String htmlString= "";
		switch(tipoReporte){
		case Enum_Con_TipRepor.ReporPantalla:
			 htmlString = reporteFinancierosServicio.reporteEstadosFinancierosPantalla(reporteFinancierosBean,  getNombreReporte());
		break;
		case Enum_Con_TipRepor.ReporPDF:
			ByteArrayOutputStream htmlStringPDF = reporteMContablePDF(reporteFinancierosBean,  getNombreReporte(), response);
		break;
		case Enum_Con_TipRepor.ReporteExcel:
			reporteFinancierosServicio.generaReporteExcel(reporteFinancierosBean,getNombreReporte(),response);
		
		}
		if(tipoReporte ==Enum_Con_TipRepor.ReporPantalla ){
			return new ModelAndView(getSuccessView(), "reporte", htmlString);
		}else {
			return null;
		}
 				
  	}
 
	public ByteArrayOutputStream reporteMContablePDF(ReporteFinancierosBean reporteFinancierosBean, String nomReporte, HttpServletResponse response){
			ByteArrayOutputStream htmlStringPDF = null;
			try {
				htmlStringPDF = reporteFinancierosServicio.reporteFinancierosPDF(reporteFinancierosBean, nomReporte);
				response.addHeader("Content-Disposition","inline; filename="+nomTipoReporte+".pdf");
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

	public ReporteFinancierosServicio getReporteFinancierosServicio() {
		return reporteFinancierosServicio;
	}

	public void setReporteFinancierosServicio(
			ReporteFinancierosServicio reporteFinancierosServicio) {
		this.reporteFinancierosServicio = reporteFinancierosServicio;
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
