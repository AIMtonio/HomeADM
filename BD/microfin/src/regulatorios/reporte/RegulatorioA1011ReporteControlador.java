package regulatorios.reporte;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import regulatorios.bean.RegulatorioA1011Bean;
import regulatorios.servicio.RegulatorioA1011Servicio;

public class RegulatorioA1011ReporteControlador extends AbstractCommandController{
	
	RegulatorioA1011Servicio regulatorioA1011Servicio = null;
	String successView = null;
	
	public RegulatorioA1011ReporteControlador () {
		setCommandClass(RegulatorioA1011Bean.class);
		setCommandName("regulatorioA1011Bean");
	}

	protected ModelAndView handle(HttpServletRequest request,HttpServletResponse response, Object command, BindException errors)throws Exception {
		try {
			MensajeTransaccionBean mensaje = null;
			RegulatorioA1011Bean regulatorioA1011Bean = (RegulatorioA1011Bean) command;

			int tipoReporte = (request.getParameter("tipoReporte") != null)
					? Integer.parseInt(request.getParameter("tipoReporte"))
					: 0;
					
			int tipoEntidad = (request.getParameter("tipoEntidad") != null)
					? Integer.parseInt(request.getParameter("tipoEntidad"))
					: 0;
					
					regulatorioA1011Servicio.listaReporteRegulatorioA1011(tipoReporte,tipoEntidad, regulatorioA1011Bean, response);
	
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return null;
	}

	public RegulatorioA1011Servicio getRegulatorioA1011Servicio() {
		return regulatorioA1011Servicio;
	}

	public void setRegulatorioA1011Servicio(
			RegulatorioA1011Servicio regulatorioA1011Servicio) {
		this.regulatorioA1011Servicio = regulatorioA1011Servicio;
	}

	public String getSuccessView() {
		return successView;
	}

	public void setSuccessView(String successView) {
		this.successView = successView;
	}
		
}
