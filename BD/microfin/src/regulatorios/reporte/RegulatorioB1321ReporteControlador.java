package regulatorios.reporte;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import regulatorios.bean.RegulatorioB1321Bean;
import regulatorios.servicio.RegulatorioB1321Servicio;

public class RegulatorioB1321ReporteControlador extends AbstractCommandController{
	
	RegulatorioB1321Servicio regulatorioB1321Servicio = null;
	String successView = null;
	
	public RegulatorioB1321ReporteControlador () {
		setCommandClass(RegulatorioB1321Bean.class);
		setCommandName("regulatorioB1321Bean");
	}
	
	protected ModelAndView handle(HttpServletRequest request,HttpServletResponse response, Object command, BindException errors)throws Exception {
		try {
			MensajeTransaccionBean mensaje = null;
			RegulatorioB1321Bean regulatorioB1321Bean = (RegulatorioB1321Bean) command;

			int tipoReporte = (request.getParameter("tipoReporte") != null)
					? Integer.parseInt(request.getParameter("tipoReporte"))
					: 0;
					
			int tipoEntidad = (request.getParameter("tipoEntidad") != null)
					? Integer.parseInt(request.getParameter("tipoEntidad"))
					: 0;
					
					regulatorioB1321Servicio.listaReporteRegulatorioB1321(tipoReporte,tipoEntidad, regulatorioB1321Bean, response);
	
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return null;
	}
	public RegulatorioB1321Servicio getRegulatorioB1321Servicio() {
		return regulatorioB1321Servicio;
	}

	public void setRegulatorioB1321Servicio(
			RegulatorioB1321Servicio regulatorioB1321Servicio) {
		this.regulatorioB1321Servicio = regulatorioB1321Servicio;
	}

	public String getSuccessView() {
		return successView;
	}

	public void setSuccessView(String successView) {
		this.successView = successView;
	}
}
