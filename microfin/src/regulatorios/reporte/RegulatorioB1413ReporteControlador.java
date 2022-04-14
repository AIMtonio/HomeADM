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

import regulatorios.bean.RegulatorioB1413Bean;
import regulatorios.servicio.RegulatorioB1413Servicio;
import regulatorios.servicio.RegulatorioInsServicio;
import regulatorios.servicio.RegulatorioInsServicio.Enum_Lis_TiposInstitucion;


public class RegulatorioB1413ReporteControlador extends AbstractCommandController{
	RegulatorioB1413Servicio regulatorioB1413Servicio = null;
	String successView = null;
	

	public RegulatorioB1413ReporteControlador () {
		setCommandClass(RegulatorioB1413Bean.class);
		setCommandName("regulatorioB1413Bean");
	}

	protected ModelAndView handle(HttpServletRequest request,HttpServletResponse response, Object command, BindException errors)throws Exception {
		try {
			MensajeTransaccionBean mensaje = null;
			RegulatorioB1413Bean regulatorioB1413Bean = (RegulatorioB1413Bean) command;

			int tipoReporte = (request.getParameter("tipoReporte") != null)
					? Integer.parseInt(request.getParameter("tipoReporte"))
					: 0;
					
			int tipoEntidad = (request.getParameter("tipoEntidad") != null)
					? Integer.parseInt(request.getParameter("tipoEntidad"))
					: 0;
			
			

			regulatorioB1413Servicio.listaReporteRegulatorioB1413(tipoReporte,tipoEntidad, regulatorioB1413Bean, response);

		    	
					
			
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return null;
	}
	
	
	public RegulatorioB1413Servicio getRegulatorioB1413Servicio() {
		return regulatorioB1413Servicio;
	}

	public void setRegulatorioB1413Servicio(
			RegulatorioB1413Servicio regulatorioB1413Servicio) {
		this.regulatorioB1413Servicio = regulatorioB1413Servicio;
	}

	public String getSuccessView() {
		return successView;
	}
	public void setSuccessView(String successView) {
		this.successView = successView;
	}

	
	
}

