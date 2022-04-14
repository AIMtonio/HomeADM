package tesoreria.reporte;

import java.io.ByteArrayOutputStream;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import tesoreria.bean.RepAsignarChequesBean;
import tesoreria.bean.ReporteChequesEmitidosBean;
import tesoreria.servicio.RepAsignarChequesServicio;
import tesoreria.servicio.ReporteChequesEmitidosServicio;

public class ChequesAsignadosRepControlador extends AbstractCommandController {
	
	RepAsignarChequesServicio repAsignarChequesServicio = null;
	String successView = null;	
	String nomReporte = null;
	
	public ChequesAsignadosRepControlador(){
 		setCommandClass(RepAsignarChequesBean.class);
 		setCommandName("chequesAsignadosRep");
 	}

	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response, Object command, BindException errors)
			throws Exception {
		RepAsignarChequesBean imprimeChequeBean = (RepAsignarChequesBean) command;
		ByteArrayOutputStream htmlStringPDF = ImprimeChequesAsignados(imprimeChequeBean, response);
		return null;
	}
			
	// Reporte de Impresión de Cheques
	public ByteArrayOutputStream ImprimeChequesAsignados(RepAsignarChequesBean imprimeChequeBean, HttpServletResponse response) {
		ByteArrayOutputStream htmlStringPDF = null;
		try {
			htmlStringPDF = repAsignarChequesServicio.reporteChequesAsignados(imprimeChequeBean, nomReporte);
			response.addHeader("Content-Disposition", "inline; filename=ReporteChequesAsignados.pdf");
			response.setContentType("application/pdf");
			byte[] bytes = htmlStringPDF.toByteArray();
			response.getOutputStream().write(bytes, 0, bytes.length);
			response.getOutputStream().flush();
			response.getOutputStream().close();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return htmlStringPDF;
	}

	public String getSuccessView() {
		return successView;
	}

	public void setSuccessView(String successView) {
		this.successView = successView;
	}

	public RepAsignarChequesServicio getRepAsignarChequesServicio() {
		return repAsignarChequesServicio;
	}

	public void setRepAsignarChequesServicio(
			RepAsignarChequesServicio repAsignarChequesServicio) {
		this.repAsignarChequesServicio = repAsignarChequesServicio;
	}

	public String getNomReporte() {
		return nomReporte;
	}

	public void setNomReporte(String nomReporte) {
		this.nomReporte = nomReporte;
	}

}
