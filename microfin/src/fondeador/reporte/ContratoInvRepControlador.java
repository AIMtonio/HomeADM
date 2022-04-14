package fondeador.reporte;

import fondeador.bean.CreditoFondeoBean;
import fondeador.servicio.CreditoFondeoServicio;
import inversiones.reporte.AperturasInvRepControlador.Enum_Con_TipRepor;
import java.io.ByteArrayOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

public class ContratoInvRepControlador extends AbstractCommandController{
	
	CreditoFondeoServicio creditoFondeoServicio = null;
	String nombreReporte = null;
	String successView = null;		   
	
	public static interface Enum_Con_TipRepor {
		int ReporPantalla =1;  
		int  ReporPDF= 2 ;
		  
	}
	
	public ContratoInvRepControlador() {
		setCommandClass(CreditoFondeoBean.class);
		setCommandName("creditoFondeoBean");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {

		CreditoFondeoBean creditoFondeoBean = (CreditoFondeoBean) command;
		
		int tipoReporte =(request.getParameter("tipoReporte")!=null)?
				Integer.parseInt(request.getParameter("tipoReporte")):0;
		
		String htmlString= "";
		
		switch(tipoReporte){	
		case Enum_Con_TipRepor.ReporPDF:
			ByteArrayOutputStream htmlStringPDF = reporteContratoInvPDF(creditoFondeoBean, nombreReporte, response);
		break;
		}
		return null;
		
	}
	public ByteArrayOutputStream reporteContratoInvPDF(CreditoFondeoBean creditoFondeoBean, String nombreReporte, HttpServletResponse response){
		ByteArrayOutputStream htmlStringPDF = null;
		try {
			htmlStringPDF = creditoFondeoServicio.repContratoPDF(creditoFondeoBean, nombreReporte);
			response.addHeader("Content-Disposition","inline; filename=PagareFondeador.pdf");
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
	public CreditoFondeoServicio getCreditoFondeoServicio() {
		return creditoFondeoServicio;
	}

	public String getNombreReporte() {
		return nombreReporte;
	}

	public String getSuccessView() {
		return successView;
	}

	public void setCreditoFondeoServicio(
			CreditoFondeoServicio creditoFondeoServicio) {
		this.creditoFondeoServicio = creditoFondeoServicio;
	}

	public void setNombreReporte(String nombreReporte) {
		this.nombreReporte = nombreReporte;
	}

	public void setSuccessView(String successView) {
		this.successView = successView;
	}
	
}