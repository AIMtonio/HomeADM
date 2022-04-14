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
import regulatorios.servicio.RegulatorioInsServicio;
import regulatorios.servicio.RegulatorioA2611Servicio;


public class RegulatorioA2611ReporteControlador extends AbstractCommandController{
	RegulatorioA2611Servicio regulatorioA2611Servicio = null;
	String successView = null;
	 
	public static interface Enum_Con_TipReporte {
		  int  ReporExcel= 1;
		  int  ReporCsv= 2;
	}
	
	public RegulatorioA2611ReporteControlador () {
		setCommandClass(RegulatorioA2611Bean.class);
		setCommandName("regulatorioA2611Bean");
	}

	protected ModelAndView handle(HttpServletRequest request,HttpServletResponse response, Object command, BindException errors)throws Exception {
		try {
			MensajeTransaccionBean mensaje = null;
			RegulatorioA2611Bean regulatorioA2611Bean = (RegulatorioA2611Bean) command;

			int tipoReporte = (request.getParameter("tipoReporte") != null)
					? Integer.parseInt(request.getParameter("tipoReporte"))
					: 0;
					
			int tipoEntidad = (request.getParameter("tipoEntidad") != null)
					? Integer.parseInt(request.getParameter("tipoEntidad"))
					: 0;
			
			
	
			regulatorioA2611Servicio.listaReporteRegulatorioA2611(
					tipoReporte,tipoEntidad, regulatorioA2611Bean, response);


			
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return null;
	}
	
		

	public RegulatorioA2611Servicio getRegulatorioA2611Servicio() {
		return regulatorioA2611Servicio;
	}

	public void setRegulatorioA2611Servicio(
			RegulatorioA2611Servicio regulatorioA2611Servicio) {
		this.regulatorioA2611Servicio = regulatorioA2611Servicio;
	}

	public String getSuccessView() {
		return successView;
	}
	public void setSuccessView(String successView) {
		this.successView = successView;
	}
	
}

