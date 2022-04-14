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

import regulatorios.bean.RegulatorioA1219Bean;
import regulatorios.servicio.RegulatorioA1219Servicio;
import regulatorios.servicio.RegulatorioInsServicio;
import regulatorios.servicio.RegulatorioInsServicio.Enum_Lis_TiposInstitucion;


public class RegulatorioA1219ReporteControlador extends AbstractCommandController{
	RegulatorioA1219Servicio regulatorioA1219Servicio = null;
	String successView = null;
	

	public RegulatorioA1219ReporteControlador () {
		setCommandClass(RegulatorioA1219Bean.class);
		setCommandName("regulatorioA1219Bean");
	}

	protected ModelAndView handle(HttpServletRequest request,HttpServletResponse response, Object command, BindException errors)throws Exception {
		try {
			MensajeTransaccionBean mensaje = null;
			RegulatorioA1219Bean regulatorioA1219Bean = (RegulatorioA1219Bean) command;

			int tipoReporte = (request.getParameter("tipoReporte") != null)
					? Integer.parseInt(request.getParameter("tipoReporte"))
					: 0;
					
			int tipoEntidad = (request.getParameter("tipoEntidad") != null)
					? Integer.parseInt(request.getParameter("tipoEntidad"))
					: 0;
			
			

			regulatorioA1219Servicio.listaReporteRegulatorioA1219(tipoReporte,tipoEntidad, regulatorioA1219Bean, response);

		    	
					
			
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return null;
	}
	
	
	
	
	
	public RegulatorioA1219Servicio getRegulatorioA1219Servicio() {
		return regulatorioA1219Servicio;
	}

	public void setRegulatorioA1219Servicio(
			RegulatorioA1219Servicio regulatorioA1219Servicio) {
		this.regulatorioA1219Servicio = regulatorioA1219Servicio;
	}

	public String getSuccessView() {
		return successView;
	}
	public void setSuccessView(String successView) {
		this.successView = successView;
	}

	
	
}

