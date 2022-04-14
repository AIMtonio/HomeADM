package regulatorios.reporte;

import general.bean.MensajeTransaccionBean;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFDataFormat;
import org.apache.poi.hssf.util.HSSFColor;
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

import regulatorios.bean.RegulatorioC2613Bean;
import regulatorios.servicio.RegulatorioC2613Servicio;


public class RegulatorioC2613ReporteControlador extends AbstractCommandController{
	RegulatorioC2613Servicio regulatorioC2613Servicio = null;
	String successView = null;
	
	public static interface Enum_Con_TipReporte {
		  int  ReporExcel= 1;
		  int  ReporCsv= 2;
	}
	
	public RegulatorioC2613ReporteControlador () {
		setCommandClass(RegulatorioC2613Bean.class);
		setCommandName("regulatorioC2613Bean");
	}

	protected ModelAndView handle(HttpServletRequest request,HttpServletResponse response, Object command, BindException errors)throws Exception {
		try {
			MensajeTransaccionBean mensaje = null;
			RegulatorioC2613Bean regulatorioC2613Bean = (RegulatorioC2613Bean) command;

			int tipoReporte = (request.getParameter("tipoReporte") != null)
					? Integer.parseInt(request.getParameter("tipoReporte"))
					: 0;

			int tipoEntidad = (request.getParameter("tipoEntidad") != null)
					? Integer.parseInt(request.getParameter("tipoEntidad"))
					: 0;
					
			regulatorioC2613Servicio.listaReporteRegulatorioC2613(tipoReporte,tipoEntidad, regulatorioC2613Bean, response);

		
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return null;
	}
	
	
		

	
	
	
	public RegulatorioC2613Servicio getRegulatorioC2613Servicio() {
		return regulatorioC2613Servicio;
	}

	public void setRegulatorioC2613Servicio(
			RegulatorioC2613Servicio regulatorioC2613Servicio) {
		this.regulatorioC2613Servicio = regulatorioC2613Servicio;
	}

	public String getSuccessView() {
		return successView;
	}
	public void setSuccessView(String successView) {
		this.successView = successView;
	}
	
}

