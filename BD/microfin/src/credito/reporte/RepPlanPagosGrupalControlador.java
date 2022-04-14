package credito.reporte;

import java.io.ByteArrayOutputStream;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import contabilidad.bean.ReportePolizaBean;

import credito.bean.RepPlanPagosGrupalBean;
import credito.servicio.CreditosServicio;


public class RepPlanPagosGrupalControlador extends AbstractCommandController{
	CreditosServicio creditosServicio = new CreditosServicio ();
	String nombreReporte = null;
	
	public RepPlanPagosGrupalControlador(){
		setCommandClass(RepPlanPagosGrupalBean.class);
		setCommandName("repPlanPagosGrupalBean");
	}

	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
	
		RepPlanPagosGrupalBean repPlanPagosGrupalBean= (RepPlanPagosGrupalBean) command;
		 
		ByteArrayOutputStream htmlStringPDF = null;
		try {
			htmlStringPDF = creditosServicio.reportePlanPagoPDF(repPlanPagosGrupalBean, nombreReporte);
			response.setContentType("application/pdf");
			response.addHeader("Content-Disposition", "inline; filename=PlanDePagoGrupal.pdf");
			
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

	public String getNombreReporte() {
		return nombreReporte;
	}

	public void setCreditosServicio(CreditosServicio creditosServicio) {
		this.creditosServicio = creditosServicio;
	}

	public void setNombreReporte(String nombreReporte) {
		this.nombreReporte = nombreReporte;
	}

	

}
