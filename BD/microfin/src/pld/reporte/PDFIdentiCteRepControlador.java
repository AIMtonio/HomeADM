package pld.reporte;

import java.io.ByteArrayOutputStream;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import cliente.bean.ClienteBean;
import cliente.bean.ReporteClienteBean;
import cliente.reporte.ReportePerfilCteControlador.Enum_Con_TipRepor;
import cliente.servicio.ClienteServicio;


public class PDFIdentiCteRepControlador extends AbstractCommandController {
	ClienteServicio clienteServicio = new ClienteServicio ();
	String nombreReporte = null;
	String successView = null;		

	public static interface Enum_Con_TipRepor {
		  int  ReporPDF= 1 ;
	}
	public PDFIdentiCteRepControlador(){
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
	
			String htmlString= "";
			
				switch(tipoReporte){
				case Enum_Con_TipRepor.ReporPDF:
					ByteArrayOutputStream htmlStringPDF = reporteIdentClientePDF(reporteClienteBean, nombreReporte, response);
				break;
		}
			{
				return null;
			}
					
		}
	
// Reporte  de  fondeo de ucursales en PDF
	public ByteArrayOutputStream reporteIdentClientePDF(ReporteClienteBean reporteClienteBean, String nombreReporte, HttpServletResponse response){
		ByteArrayOutputStream htmlStringPDF = null;
		try {
			htmlStringPDF = clienteServicio.reporteIdentClientePDF(reporteClienteBean, nombreReporte);
			response.addHeader("Content-Disposition","inline; filename=IdentificacionCliente.pdf");
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
	public void setClienteServicio(ClienteServicio clienteServicio) {
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
