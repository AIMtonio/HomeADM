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

import regulatorios.bean.RegulatorioB1524Bean;
import regulatorios.servicio.RegulatorioB1524Servicio;


public class RegulatorioB1524ReporteControlador extends AbstractCommandController{
	RegulatorioB1524Servicio regulatorioB1524Servicio = null;
	String successView = null;
	

	public RegulatorioB1524ReporteControlador () {
		setCommandClass(RegulatorioB1524Bean.class);
		setCommandName("regulatorioB1524Bean");
	}

	protected ModelAndView handle(HttpServletRequest request,HttpServletResponse response, Object command, BindException errors)throws Exception {
		try {
			MensajeTransaccionBean mensaje = null;
			RegulatorioB1524Bean regulatorioB1524Bean = (RegulatorioB1524Bean) command;

			int tipoReporte = (request.getParameter("tipoReporte") != null)
					? Integer.parseInt(request.getParameter("tipoReporte"))
					: 0;
					
			int tipoEntidad = (request.getParameter("tipoEntidad") != null)
					? Integer.parseInt(request.getParameter("tipoEntidad"))
					: 0;
			
			

			regulatorioB1524Servicio.listaReporteRegulatorioB1524(tipoReporte,tipoEntidad, regulatorioB1524Bean, response);

		    	
					
			
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return null;
	}
	
	
	

	public RegulatorioB1524Servicio getRegulatorioB1524Servicio() {
		return regulatorioB1524Servicio;
	}

	public void setRegulatorioB1524Servicio(
			RegulatorioB1524Servicio regulatorioB1524Servicio) {
		this.regulatorioB1524Servicio = regulatorioB1524Servicio;
	}

	public String getSuccessView() {
		return successView;
	}
	public void setSuccessView(String successView) {
		this.successView = successView;
	}

	
	
}

