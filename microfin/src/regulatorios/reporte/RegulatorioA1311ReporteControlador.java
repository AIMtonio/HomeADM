package regulatorios.reporte;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import regulatorios.bean.RegulatorioA1311Bean;
import regulatorios.servicio.RegulatorioA1311Servicio;


public class RegulatorioA1311ReporteControlador extends AbstractCommandController {

	RegulatorioA1311Servicio regulatorioA1311Servicio = null;
	String successView = null;
	 
	public static interface Enum_Con_TipReporte {
		  int  ReporExcel= 1;
		  int  ReporCsv= 2;
	}
	
	public RegulatorioA1311ReporteControlador () {
		setCommandClass(RegulatorioA1311Bean.class);
		setCommandName("regulatorioA1311Bean");
	}
	
	protected ModelAndView handle(HttpServletRequest request,HttpServletResponse response, Object command, BindException errors)throws Exception {
		try {
			MensajeTransaccionBean mensaje = null;
			RegulatorioA1311Bean regulatorioA1311Bean = (RegulatorioA1311Bean) command;

			int tipoReporte = (request.getParameter("tipoReporte") != null)
					? Integer.parseInt(request.getParameter("tipoReporte"))
					: 0;
					
			int tipoEntidad = (request.getParameter("tipoEntidad") != null)
					? Integer.parseInt(request.getParameter("tipoEntidad"))
					: 0;
					
			regulatorioA1311Servicio.listaReporteRegulatorioA1311(
					tipoReporte,tipoEntidad, regulatorioA1311Bean, response);

			
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return null;
	}
	
	public RegulatorioA1311Servicio getRegulatorioA1311Servicio() {
		return regulatorioA1311Servicio;
	}

	public void setRegulatorioA1311Servicio(
			RegulatorioA1311Servicio regulatorioA1311Servicio) {
		this.regulatorioA1311Servicio = regulatorioA1311Servicio;
	}

	public String getSuccessView() {
		return successView;
	}
	public void setSuccessView(String successView) {
		this.successView = successView;
	}
}
