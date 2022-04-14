package regulatorios.reporte;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import regulatorios.bean.RegulatorioB1322Bean;
import regulatorios.servicio.RegulatorioB1322Servicio;



public class RegulatorioB1322ReporteControlador extends AbstractCommandController{
	
	RegulatorioB1322Servicio regulatorioB1322Servicio = null;
	String successView = null;
	
	public RegulatorioB1322ReporteControlador () {
		setCommandClass(RegulatorioB1322Bean.class);
		setCommandName("regulatorioB1322Bean");
	}
	
	protected ModelAndView handle(HttpServletRequest request,HttpServletResponse response, Object command, BindException errors)throws Exception {
		try {
			MensajeTransaccionBean mensaje = null;
			RegulatorioB1322Bean regulatorioB1322Bean = (RegulatorioB1322Bean) command;

			int tipoReporte = (request.getParameter("tipoReporte") != null)
					? Integer.parseInt(request.getParameter("tipoReporte"))
					: 0;
					
			int tipoEntidad = (request.getParameter("tipoEntidad") != null)
					? Integer.parseInt(request.getParameter("tipoEntidad"))
					: 0;
					
					regulatorioB1322Servicio.listaReporteRegulatorioB1322(tipoReporte,tipoEntidad, regulatorioB1322Bean, response);
	
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return null;
	}
	
	public RegulatorioB1322Servicio getRegulatorioB1322Servicio() {
		return regulatorioB1322Servicio;
	}

	public void setRegulatorioB1322Servicio(
			RegulatorioB1322Servicio regulatorioB1322Servicio) {
		this.regulatorioB1322Servicio = regulatorioB1322Servicio;
	}

	public String getSuccessView() {
		return successView;
	}

	public void setSuccessView(String successView) {
		this.successView = successView;
	}
	
}