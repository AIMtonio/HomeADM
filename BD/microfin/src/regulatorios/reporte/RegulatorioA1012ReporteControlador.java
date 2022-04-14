package regulatorios.reporte;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import regulatorios.bean.RegulatorioA1012Bean;
import regulatorios.servicio.RegulatorioA1012Servicio;

public class RegulatorioA1012ReporteControlador extends AbstractCommandController{

	RegulatorioA1012Servicio regulatorioA1012Servicio = null;
	String successView = null;
	
	public RegulatorioA1012ReporteControlador () {
		setCommandClass(RegulatorioA1012Bean.class);
		setCommandName("regulatorioA1012Bean");
	}

	protected ModelAndView handle(HttpServletRequest request,HttpServletResponse response, Object command, BindException errors)throws Exception {
		try {
			MensajeTransaccionBean mensaje = null;
			RegulatorioA1012Bean regulatorioA1012Bean = (RegulatorioA1012Bean) command;

			int tipoReporte = (request.getParameter("tipoReporte") != null)
					? Integer.parseInt(request.getParameter("tipoReporte"))
					: 0;
					
			int tipoEntidad = (request.getParameter("tipoEntidad") != null)
					? Integer.parseInt(request.getParameter("tipoEntidad"))
					: 0;
					
					regulatorioA1012Servicio.listaReporteRegulatorioA1012(tipoReporte,tipoEntidad, regulatorioA1012Bean, response);
	
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return null;
	}

	public RegulatorioA1012Servicio getRegulatorioA1012Servicio() {
		return regulatorioA1012Servicio;
	}

	public void setRegulatorioA1012Servicio(
			RegulatorioA1012Servicio regulatorioA1012Servicio) {
		this.regulatorioA1012Servicio = regulatorioA1012Servicio;
	}

	public String getSuccessView() {
		return successView;
	}

	public void setSuccessView(String successView) {
		this.successView = successView;
	}	
}
