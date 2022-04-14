package regulatorios.reporte;

import general.bean.MensajeTransaccionBean;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.DataFormat;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.streaming.SXSSFSheet;
import org.apache.poi.xssf.streaming.SXSSFWorkbook;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import regulatorios.bean.RegulatorioA2610Bean;
import regulatorios.servicio.RegulatorioA2610Servicio;
import regulatorios.servicio.RegulatorioInsServicio;
import regulatorios.servicio.RegulatorioInsServicio.Enum_Lis_TiposInstitucion;


public class RegulatorioA2610ReporteControlador extends AbstractCommandController{
	RegulatorioA2610Servicio regulatorioA2610Servicio = null;
	String successView = null;
	

	public RegulatorioA2610ReporteControlador () {
		setCommandClass(RegulatorioA2610Bean.class);
		setCommandName("regulatorioA2610Bean");
	}

	protected ModelAndView handle(HttpServletRequest request,HttpServletResponse response, Object command, BindException errors)throws Exception {
		try {
			MensajeTransaccionBean mensaje = null;
			RegulatorioA2610Bean regulatorioA2610Bean = (RegulatorioA2610Bean) command;

			int tipoReporte = (request.getParameter("tipoReporte") != null)
					? Integer.parseInt(request.getParameter("tipoReporte"))
					: 0;
					
			int tipoEntidad = (request.getParameter("tipoEntidad") != null)
					? Integer.parseInt(request.getParameter("tipoEntidad"))
					: 0;
			
			

			regulatorioA2610Servicio.listaReporteRegulatorioA2610(tipoReporte,tipoEntidad, regulatorioA2610Bean, response);

		    	
					
			
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return null;
	}
	
	
	
	
	
	public RegulatorioA2610Servicio getRegulatorioA2610Servicio() {
		return regulatorioA2610Servicio;
	}

	public void setRegulatorioA2610Servicio(
			RegulatorioA2610Servicio regulatorioA2610Servicio) {
		this.regulatorioA2610Servicio = regulatorioA2610Servicio;
	}

	public String getSuccessView() {
		return successView;
	}
	public void setSuccessView(String successView) {
		this.successView = successView;
	}

	
	
}

