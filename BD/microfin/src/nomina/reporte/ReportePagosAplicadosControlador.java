package nomina.reporte;

import java.io.ByteArrayOutputStream;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import nomina.bean.PagoNominaBean;
import nomina.servicio.PagoNominaServicio;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;


public class ReportePagosAplicadosControlador extends AbstractCommandController {

	PagoNominaServicio pagoNominaServicio= null;
	String nombreReporte = null;
	String successView = null;

	public static interface Enum_Con_TipRepor {
		int ReporPDF	  = 1 ;
		int ReporPantalla = 2;
		int ReporExcel 	  = 3;
	}

	public ReportePagosAplicadosControlador(){
		setCommandClass(PagoNominaBean.class);
		setCommandName("pagoNominaBean");
	}

	protected ModelAndView handle(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse, Object object, BindException bindException) throws Exception {

		PagoNominaBean pagoNominaBean= (PagoNominaBean) object;

		int reporte =(httpServletRequest.getParameter("reporte")!=null)? Integer.parseInt(httpServletRequest.getParameter("reporte")):0;
		int tipoLista =(httpServletRequest.getParameter("tipoLista")!=null)? Integer.parseInt(httpServletRequest.getParameter("tipoLista")):0;
		String htmlString= "";

		switch(reporte){
			case Enum_Con_TipRepor.ReporPDF:
				ByteArrayOutputStream htmlStringPDF = pagoNominaServicio.reportePDF(pagoNominaBean, nombreReporte, httpServletResponse);
			break;
			case Enum_Con_TipRepor.ReporPantalla:
				 htmlString = pagoNominaServicio.reportePantalla(pagoNominaBean, nombreReporte);
			break;
			case Enum_Con_TipRepor.ReporExcel:
				 pagoNominaServicio.reporteExcel(tipoLista, pagoNominaBean, httpServletResponse);
			break;
		}
		if(reporte == Enum_Con_TipRepor.ReporPantalla ){
			return new ModelAndView(getSuccessView(), "reporte", htmlString);
		}else {
			return null;
		}
	}

	public PagoNominaServicio getPagoNominaServicio() {
		return pagoNominaServicio;
	}

	public void setPagoNominaServicio(PagoNominaServicio pagoNominaServicio) {
		this.pagoNominaServicio = pagoNominaServicio;
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