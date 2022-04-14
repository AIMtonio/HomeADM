package credito.reporte;

import java.io.ByteArrayOutputStream;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import credito.bean.CreditosBean;
import credito.servicio.CreditosServicio;

public class PDFRepCreditosMov extends AbstractCommandController{
	
	CreditosServicio creditosServicio = null;
	String nomReporMovCred = null;
	
 	public PDFRepCreditosMov(){
 		setCommandClass(CreditosBean.class);
 		setCommandName("creditos");
 	}
	

	@Override
	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response, Object command, BindException errors)
			throws Exception {
		
 		CreditosBean creditos = (CreditosBean) command;
 		
	   ByteArrayOutputStream htmlString = creditosServicio.reporMovsCreditoPDF(creditos, nomReporMovCred);
 		
 		response.addHeader("Content-Disposition","inline; filename=ReporteCreditMov.pdf");
 		response.setContentType("application/pdf");
 		byte[] bytes = htmlString.toByteArray();
 		response.getOutputStream().write(bytes,0,bytes.length);
		response.getOutputStream().flush();
		response.getOutputStream().close();
	
		return null;
	}


	public CreditosServicio getCreditosServicio() {
		return creditosServicio;
	}


	public void setCreditosServicio(CreditosServicio creditosServicio) {
		this.creditosServicio = creditosServicio;
	}


	public String getNomReporMovCred() {
		return nomReporMovCred;
	}


	public void setNomReporMovCred(String nomReporMovCred) {
		this.nomReporMovCred = nomReporMovCred;
	}

	
	
}
