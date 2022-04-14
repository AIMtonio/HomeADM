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

import regulatorios.bean.RegulatorioB2612Bean;
import regulatorios.servicio.RegulatorioB2612Servicio;
import regulatorios.servicio.RegulatorioInsServicio;


public class RegulatorioB2612ReporteControlador extends AbstractCommandController{
	RegulatorioB2612Servicio regulatorioB2612Servicio = null;
	String successView = null;
	
	public static interface Enum_Con_TipReporte {
		  int  ReporExcel= 1;
		  int  ReporCsv= 2;
	}
	
	public RegulatorioB2612ReporteControlador () {
		setCommandClass(RegulatorioB2612Bean.class);
		setCommandName("regulatorioB2612Bean");
	}

	protected ModelAndView handle(HttpServletRequest request,HttpServletResponse response, Object command, BindException errors)throws Exception {
		try {
			MensajeTransaccionBean mensaje = null;
			RegulatorioB2612Bean regulatorioB2612Bean = (RegulatorioB2612Bean) command;

			int tipoReporte = (request.getParameter("tipoReporte") != null)
					? Integer.parseInt(request.getParameter("tipoReporte"))
					: 0;
					
			int tipoEntidad = (request.getParameter("tipoEntidad") != null)
					? Integer.parseInt(request.getParameter("tipoEntidad"))
					: 0;
					
		
			regulatorioB2612Servicio.listaReporteRegulatorioB2612(
								tipoReporte,tipoEntidad, regulatorioB2612Bean, response);

			
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return null;
	}
	
	
	
	

	public RegulatorioB2612Servicio getRegulatorioB2612Servicio() {
		return regulatorioB2612Servicio;
	}

	public void setRegulatorioB2612Servicio(
			RegulatorioB2612Servicio regulatorioB2612Servicio) {
		this.regulatorioB2612Servicio = regulatorioB2612Servicio;
	}

	public String getSuccessView() {
		return successView;
	}
	public void setSuccessView(String successView) {
		this.successView = successView;
	}
	
}

