package credito.reporte;

import java.io.ByteArrayOutputStream;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import credito.bean.RepPlanPagosIndividualBean;
import credito.servicio.CreditosServicio;

public class RepPlanPagosIndividualControlador extends AbstractCommandController{
	CreditosServicio creditosServicio = new CreditosServicio ();
	String nombreReporte = null;
	
	public RepPlanPagosIndividualControlador(){
		setCommandClass(RepPlanPagosIndividualBean.class);
		setCommandName("repPlanPagosIndividualBean");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
	
		RepPlanPagosIndividualBean repPlanPagosIndividualBean= (RepPlanPagosIndividualBean) command;
	
		ByteArrayOutputStream htmlStringPDF = null;
		try {
			htmlStringPDF = creditosServicio.reportePlanPagoIndPDF(repPlanPagosIndividualBean, nombreReporte);
			response.setContentType("application/pdf");
			response.addHeader("Content-Disposition", "inline; filename=PlanDePagoIndividual.pdf");
			
			byte[] bytes = htmlStringPDF.toByteArray();
			response.getOutputStream().write(bytes,0,bytes.length);
			response.getOutputStream().flush();
			response.getOutputStream().close();
		} catch (Exception e) {
			e.printStackTrace();
		}		
		return null;
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
	
}
