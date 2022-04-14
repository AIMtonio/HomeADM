package fira.reporte;

import java.io.ByteArrayOutputStream;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import credito.bean.CreditosBean;
import credito.servicio.CreditosServicio;



public class PagoRecCreditoCastAgroControlador extends AbstractCommandController{
	CreditosServicio creditosServicio = null;
	String nombreReporte = null;
	String successView = null;		   
	
	public PagoRecCreditoCastAgroControlador() {
		setCommandClass(CreditosBean.class);
		setCommandName("creditosBean");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
			  					HttpServletResponse response,
			  					Object command,
			  					BindException errors) throws Exception {

		CreditosBean creditosBean = (CreditosBean) command;
		
 	
		ByteArrayOutputStream htmlString = creditosServicio.pagoRecCreditoCastAgro(creditosBean, request, getNombreReporte());
		
		response.addHeader("Content-Disposition","inline; filename=ticketRecuperacionCargoCtaAgro.pdf");
 		response.setContentType("application/pdf");
 		byte[] bytes = htmlString.toByteArray();
 		response.getOutputStream().write(bytes,0,bytes.length);
		response.getOutputStream().flush();
		response.getOutputStream().close();
		
		
		return null;
		
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

	public void setCreditosServicio(CreditosServicio creditosServicio) {
		this.creditosServicio = creditosServicio;
	}

	

	
}



