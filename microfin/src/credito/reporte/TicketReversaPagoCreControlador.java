package credito.reporte;

import java.io.ByteArrayOutputStream;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;



import credito.bean.ReversaPagoCreditoBean;
import credito.servicio.ReversaPagoCreditoServicio;

public class TicketReversaPagoCreControlador extends AbstractCommandController{
	
	ReversaPagoCreditoServicio reversaPagoCreditoServicio = null;
	String nombreReporte = null;
	String successView = null;
	
	public String getSuccessView() {
		return successView;
	}


	public void setSuccessView(String successView) {
		this.successView = successView;
	}


	public TicketReversaPagoCreControlador() {
		setCommandClass(ReversaPagoCreditoBean.class);
		setCommandName("reversaPagoCreditoBean");
	}
	
	
	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {

		ReversaPagoCreditoBean reversaPagoCreditoBean = (ReversaPagoCreditoBean) command;
				
		String htmlString= "";
		
		
	    ByteArrayOutputStream htmlStringPDF = reportePDF(reversaPagoCreditoBean, getNombreReporte(),  response);
			
		
		
		return null;	
	}
	
	public ByteArrayOutputStream reportePDF(ReversaPagoCreditoBean reversaPagoCreditoBean, String nomRep, HttpServletResponse response){
		ByteArrayOutputStream htmlStringPDF = null;
		try {
			htmlStringPDF = reversaPagoCreditoServicio.ticketReversaPagoCre(reversaPagoCreditoBean, nomRep);
			response.addHeader("Content-Disposition","inline; filename= Ticket.pdf");
			
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
	public ReversaPagoCreditoServicio getReversaPagoCreditoServicio() {
		return reversaPagoCreditoServicio;
	}
	public void setReversaPagoCreditoServicio(
			ReversaPagoCreditoServicio reversaPagoCreditoServicio) {
		this.reversaPagoCreditoServicio = reversaPagoCreditoServicio;
	}
	public String getNombreReporte() {
		return nombreReporte;
	}
	public void setNombreReporte(String nombreReporte) {
		this.nombreReporte = nombreReporte;
	}		
	
	
}

