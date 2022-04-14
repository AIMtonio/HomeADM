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

import regulatorios.bean.RegulatorioB1522Bean;
import regulatorios.servicio.RegulatorioB1522Servicio;

public class RegulatorioB1522ReporteControlador extends AbstractCommandController{
	RegulatorioB1522Servicio regulatorioB1522Servicio = null;
	String successView = null;
	

	public RegulatorioB1522ReporteControlador () {
		setCommandClass(RegulatorioB1522Bean.class);
		setCommandName("regulatorioB1522Bean");
	}

	protected ModelAndView handle(HttpServletRequest request,HttpServletResponse response, Object command, BindException errors)throws Exception {
		try {
			MensajeTransaccionBean mensaje = null;
			RegulatorioB1522Bean regulatorioB1522Bean = (RegulatorioB1522Bean) command;

			int tipoReporte = (request.getParameter("tipoReporte") != null)
					? Integer.parseInt(request.getParameter("tipoReporte"))
					: 0;
					
			int tipoEntidad = (request.getParameter("tipoEntidad") != null)
					? Integer.parseInt(request.getParameter("tipoEntidad"))
					: 0;
			
			

			regulatorioB1522Servicio.listaReporteRegulatorioB1522(tipoReporte,tipoEntidad, regulatorioB1522Bean, response);

		    	
					
			
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return null;
	}
	
	
	
	
	
	

	public RegulatorioB1522Servicio getRegulatorioB1522Servicio() {
		return regulatorioB1522Servicio;
	}

	public void setRegulatorioB1522Servicio(
			RegulatorioB1522Servicio regulatorioB1522Servicio) {
		this.regulatorioB1522Servicio = regulatorioB1522Servicio;
	}

	public String getSuccessView() {
		return successView;
	}
	public void setSuccessView(String successView) {
		this.successView = successView;
	}

	
	
}

