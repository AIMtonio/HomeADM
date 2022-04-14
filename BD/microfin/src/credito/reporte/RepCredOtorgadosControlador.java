package credito.reporte;

import java.io.ByteArrayOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;
import credito.bean.CreditosBean;
import credito.servicio.CreditosServicio;

public class RepCredOtorgadosControlador extends AbstractCommandController{
	
	CreditosServicio creditosServicio = null;
	String nomReporte = null;
	String successView = null;
	
	

	
	public RepCredOtorgadosControlador() {
		setCommandClass(CreditosBean.class);
		setCommandName("creditos");
	}

	

	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors)throws Exception {
		
		CreditosBean creditosBean = (CreditosBean) command;
		
		ByteArrayOutputStream htmlString = creditosServicio.creaRepCreditosOtorgadosPDF(creditosBean, request, getNomReporte());
		
		response.addHeader("Content-Disposition","inline; filename=CreditosOtorgados.pdf");
 		response.setContentType("application/pdf");
 		byte[] bytes = htmlString.toByteArray();
 		response.getOutputStream().write(bytes,0,bytes.length);
		response.getOutputStream().flush();
		response.getOutputStream().close();
		
		
		return null;
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


	public void setCreditosServicio(CreditosServicio creditosServicio) {
		this.creditosServicio = creditosServicio;
	}



	public String getNomReporte() {
		return nomReporte;
	}



	public void setNomReporte(String nomReporte) {
		this.nomReporte = nomReporte;
	}	




}
