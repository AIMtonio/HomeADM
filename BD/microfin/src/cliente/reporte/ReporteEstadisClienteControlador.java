package cliente.reporte;

import java.io.ByteArrayOutputStream;
import java.util.List;

import general.bean.MensajeTransaccionBean;
import herramientas.Utileria;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import credito.bean.CreditosBean;
import credito.bean.RepVencimiBean;


import cliente.servicio.ClienteServicio;  
import cliente.bean.ReporteClienteBean;;


public class ReporteEstadisClienteControlador extends AbstractCommandController {
	ClienteServicio clienteServicio = null;
	String nombreReporte = null;
	String successView = null;		

	public static interface Enum_Con_TipRepor {
		  int  ReporPantalla= 1 ;
		  int  ReporPDF= 2 ;
		  int  ReporExcel= 3 ;
	}
	public ReporteEstadisClienteControlador(){
		setCommandClass(ReporteClienteBean.class);
		setCommandName("reporteClienteBean");
	}
   
	protected ModelAndView handle(HttpServletRequest request,
				HttpServletResponse response,
				Object command,
				BindException errors) throws Exception {

		ReporteClienteBean reporteClienteBean = (ReporteClienteBean) command;
		 
		int tipoReporte =(request.getParameter("tipoReporte")!=null)?
			Integer.parseInt(request.getParameter("tipoReporte")):0;
	
		int tipoLista =(request.getParameter("tipoLista")!=null)?
			Integer.parseInt(request.getParameter("tipoLista")):0;
			
			String htmlString= "";
			
				switch(tipoReporte){
				case Enum_Con_TipRepor.ReporPantalla:
					 htmlString = clienteServicio.reporteEstadisticoPantalla(reporteClienteBean, nombreReporte);
				break;
					
				case Enum_Con_TipRepor.ReporPDF:
					ByteArrayOutputStream htmlStringPDF = reporteEstadisCondPDF(reporteClienteBean, nombreReporte, response);
				break;
					
				 
			}
				
				if(tipoReporte ==Enum_Con_TipRepor.ReporPantalla ){
					return new ModelAndView(getSuccessView(), "reporte", htmlString);
				}else {
					return null;
				}
	}
	
	
// Reporte  de  ministraciones  en PDF
	public ByteArrayOutputStream reporteEstadisCondPDF(ReporteClienteBean reporteClienteBean, String nomReporte, HttpServletResponse response){
		ByteArrayOutputStream htmlStringPDF = null;
		try {
			htmlStringPDF = clienteServicio.reporteEstadisticoClientePDF(reporteClienteBean, nomReporte);
			response.addHeader("Content-Disposition","inline; filename=RepEstadisticoCliente.pdf");
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

	
	


	public void setClienteServicio(ClienteServicio clienteServicio ) {
		this.clienteServicio = clienteServicio;
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


 