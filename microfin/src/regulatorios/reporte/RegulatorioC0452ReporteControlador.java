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

import regulatorios.bean.RegulatorioA2611Bean;
import regulatorios.bean.RegulatorioC0452Bean;
import regulatorios.servicio.RegulatorioC0452Servicio;
import regulatorios.servicio.RegulatorioInsServicio;
import regulatorios.servicio.RegulatorioA2611Servicio;


public class RegulatorioC0452ReporteControlador extends AbstractCommandController{
	RegulatorioC0452Servicio regulatorioC0452Servicio = null;
	String successView = null;
	 
	public static interface Enum_Con_TipReporte {
		  int  ReporExcel= 1;
		  int  ReporCsv= 2;
	} 
	
	public RegulatorioC0452ReporteControlador () {
		setCommandClass(RegulatorioC0452Bean.class);
		setCommandName("regulatorioC0452Bean");
	}

	protected ModelAndView handle(HttpServletRequest request,HttpServletResponse response, Object command, BindException errors)throws Exception {
		try {
			MensajeTransaccionBean mensaje = null;
			RegulatorioC0452Bean regulatorioC0452Bean = (RegulatorioC0452Bean) command;

			int tipoReporte = (request.getParameter("tipoReporte") != null)
					? Integer.parseInt(request.getParameter("tipoReporte"))
					: 0;
					
			int tipoEntidad = (request.getParameter("tipoEntidad") != null)
					? Integer.parseInt(request.getParameter("tipoEntidad"))
					: 0;
			
			
	
			regulatorioC0452Servicio.listaReporteRegulatorioC0452(
					tipoReporte,tipoEntidad, regulatorioC0452Bean, response);


			
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return null;
	}
	
		

	

	public RegulatorioC0452Servicio getRegulatorioC0452Servicio() {
		return regulatorioC0452Servicio;
	}

	public void setRegulatorioC0452Servicio(
			RegulatorioC0452Servicio regulatorioC0452Servicio) {
		this.regulatorioC0452Servicio = regulatorioC0452Servicio;
	}

	public String getSuccessView() {
		return successView;
	}
	public void setSuccessView(String successView) {
		this.successView = successView;
	}
	
}

