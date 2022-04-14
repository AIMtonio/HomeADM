package regulatorios.reporte;

import general.bean.MensajeTransaccionBean;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import regulatorios.bean.RegulatorioB1523Bean;
import regulatorios.servicio.RegulatorioB1523Servicio;


public class RegulatorioB1523ReporteControlador extends AbstractCommandController{
	RegulatorioB1523Servicio regulatorioB1523Servicio = null;
	String successView = null;
	

	public RegulatorioB1523ReporteControlador () {
		setCommandClass(RegulatorioB1523Bean.class);
		setCommandName("regulatorioB1523Bean");
	}

	protected ModelAndView handle(HttpServletRequest request,HttpServletResponse response, Object command, BindException errors)throws Exception {
		try {
			MensajeTransaccionBean mensaje = null;
			RegulatorioB1523Bean regulatorioB1523Bean = (RegulatorioB1523Bean) command;

			int tipoReporte = (request.getParameter("tipoReporte") != null)
					? Integer.parseInt(request.getParameter("tipoReporte"))
					: 0;
					
			int tipoEntidad = (request.getParameter("tipoEntidad") != null)
					? Integer.parseInt(request.getParameter("tipoEntidad"))
					: 0;
			
			

			regulatorioB1523Servicio.listaReporteRegulatorioB1523(tipoReporte,tipoEntidad, regulatorioB1523Bean, response);

		    	
					
			
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return null;
	}
	
	
	

	public RegulatorioB1523Servicio getRegulatorioB1523Servicio() {
		return regulatorioB1523Servicio;
	}

	public void setRegulatorioB1523Servicio(
			RegulatorioB1523Servicio regulatorioB1523Servicio) {
		this.regulatorioB1523Servicio = regulatorioB1523Servicio;
	}

	public String getSuccessView() {
		return successView;
	}
	public void setSuccessView(String successView) {
		this.successView = successView;
	}

	
	
}

