package originacion.reporte;

import java.io.ByteArrayOutputStream;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;
import org.springframework.web.servlet.mvc.SimpleFormController;

import originacion.bean.RatiosBean;
import originacion.servicio.RatiosServicio;

public class ImprimirCalculoRatiosControlador extends AbstractCommandController{
	
	RatiosServicio ratiosServicio =null;
	String nomReporte= null;
	String successView = null;
	
	public ImprimirCalculoRatiosControlador () {
		setCommandClass(RatiosBean.class);
		setCommandName("ratiosBean");
	}

	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors)throws Exception {
	
		RatiosBean bean = (RatiosBean) command;
		ByteArrayOutputStream htmlStringPDF = CalculoRatiosPDF(bean, nomReporte, response);
		return null;
	
	}
	
	public ByteArrayOutputStream CalculoRatiosPDF(RatiosBean ratios, String nomReporte, HttpServletResponse response){
		ByteArrayOutputStream htmlStringPDF = null;
		try {
			htmlStringPDF = ratiosServicio.imprimeCalculoRatios(ratios, nomReporte);
			response.addHeader("Content-Disposition","inline; filename=CalculoRatios.pdf");
			response.setContentType("application/pdf");
			byte[] bytes = htmlStringPDF.toByteArray();
			response.getOutputStream().write(bytes,0,bytes.length);
			response.getOutputStream().flush();
			response.getOutputStream().close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return htmlStringPDF;
	}
	//---------------gettter y setter ----------------
	public RatiosServicio getRatiosServicio() {
		return ratiosServicio;
	}
	public String getNomReporte() {
		return nomReporte;
	}
	public String getSuccessView() {
		return successView;
	}
	public void setRatiosServicio(RatiosServicio ratiosServicio) {
		this.ratiosServicio = ratiosServicio;
	}
	public void setNomReporte(String nomReporte) {
		this.nomReporte = nomReporte;
	}
	public void setSuccessView(String successView) {
		this.successView = successView;
	}
	
	
	
	
}
