 
package credito.reporte;

import java.io.ByteArrayOutputStream;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;
import org.springframework.web.servlet.mvc.SimpleFormController;

import cliente.bean.ReporteClienteBean;
import cliente.reporte.ReportePerfilCteControlador.Enum_Con_TipRepor;
import cliente.servicio.ClienteServicio;

import credito.bean.CreditosBean;
import credito.servicio.CreditosServicio;

public class RepExigibleCarteraClienteControlador extends AbstractCommandController {
	CreditosServicio creditosServicio = null;
	String nombreReporte = null;
	String successView = null;		

	public static interface Enum_Con_TipRepor {
		  int  ReporPantalla= 1 ;
		  int  ReporPDF= 2 ;
	}
	public RepExigibleCarteraClienteControlador(){
		setCommandClass(CreditosBean.class);
		setCommandName("creditosBean");
	}
   
	protected ModelAndView handle(HttpServletRequest request,
				HttpServletResponse response,
				Object command,
				BindException errors) throws Exception {

		CreditosBean creditosBean = (CreditosBean) command;
		 
		int tipoReporte =(request.getParameter("tipoReporte")!=null)?
			Integer.parseInt(request.getParameter("tipoReporte")):0;
	
		int tipoLista =(request.getParameter("tipoLista")!=null)?
			Integer.parseInt(request.getParameter("tipoLista")):0;
			
			String htmlString= "";
			
				switch(tipoReporte){
				case Enum_Con_TipRepor.ReporPantalla:
					 htmlString = creditosServicio.reporteExigibleCarteraCtePantalla(creditosBean, nombreReporte);
				break;
					
				case Enum_Con_TipRepor.ReporPDF:
					ByteArrayOutputStream htmlStringPDF = reporteExigibleCarteraCtePDF(creditosBean, nombreReporte, response);
				break;
					
				 
			}
				
				if(tipoReporte ==Enum_Con_TipRepor.ReporPantalla ){
					return new ModelAndView(getSuccessView(), "reporte", htmlString);
				}else {
					return null;
				}
	
	}
	// Reporte  de  ministraciones  en PDF
		public ByteArrayOutputStream reporteExigibleCarteraCtePDF(CreditosBean creditosBean, String nomReporte, HttpServletResponse response){
			ByteArrayOutputStream htmlStringPDF = null;
			try {
				htmlStringPDF = creditosServicio.reporteExigibleCarteraCtePDF(creditosBean, nomReporte);
				response.addHeader("Content-Disposition","inline; filename=RepExigleCartera.pdf");
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


	public CreditosServicio getCreditosServicio() {
		return creditosServicio;
	}

	public void setCreditosServicio(CreditosServicio creditosServicio) {
		this.creditosServicio = creditosServicio;
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
