package regulatorios.reporte;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import regulatorios.bean.RegulatorioA1316Bean;
import regulatorios.servicio.RegulatorioA1316Servicio;

public class RegulatorioA1316ReporteControlador extends AbstractCommandController{
	RegulatorioA1316Servicio regulatorioA1316Servicio = null;
	String successView = null;
	 
	public static interface Enum_Con_TipReporte {
		  int  ReporExcel= 1;
		  int  ReporCsv= 2;
	} 
	
	public RegulatorioA1316ReporteControlador () {
		setCommandClass(RegulatorioA1316Bean.class);
		setCommandName("regulatorioA1316Bean");
	}

	protected ModelAndView handle(HttpServletRequest request,HttpServletResponse response, Object command, BindException errors)throws Exception {
		try {
			MensajeTransaccionBean mensaje = null;
			RegulatorioA1316Bean regulatorioA1316Bean = (RegulatorioA1316Bean) command;

			int tipoReporte = (request.getParameter("tipoReporte") != null)
					? Integer.parseInt(request.getParameter("tipoReporte"))
					: 0;
					
			int tipoEntidad = (request.getParameter("tipoEntidad") != null)
					? Integer.parseInt(request.getParameter("tipoEntidad"))
					: 0;
					
			regulatorioA1316Servicio.listaReporteRegulatorioA1316(
					tipoReporte,tipoEntidad, regulatorioA1316Bean, response);

			
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return null;
	}
	
	public RegulatorioA1316Servicio getRegulatorioA1316Servicio() {
		return regulatorioA1316Servicio;
	}

	public void setRegulatorioA1316Servicio(
			RegulatorioA1316Servicio regulatorioA1316Servicio) {
		this.regulatorioA1316Servicio = regulatorioA1316Servicio;
	}

	public String getSuccessView() {
		return successView;
	}
	public void setSuccessView(String successView) {
		this.successView = successView;
	}
	
}

