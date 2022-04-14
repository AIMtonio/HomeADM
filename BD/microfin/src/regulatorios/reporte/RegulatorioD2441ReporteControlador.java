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

import regulatorios.bean.RegulatorioD2441Bean;
import regulatorios.servicio.RegulatorioD2441Servicio;


public class RegulatorioD2441ReporteControlador extends AbstractCommandController{
	RegulatorioD2441Servicio regulatorioD2441Servicio = null;
	String successView = null;
	
	public static interface Enum_Con_TipReporte {
		  int  ReporExcel= 1;
		  int  ReporCsv= 2;
	}
	
	public RegulatorioD2441ReporteControlador () {
		setCommandClass(RegulatorioD2441Bean.class);
		setCommandName("regulatorioD2441Bean");
	}

	protected ModelAndView handle(HttpServletRequest request,HttpServletResponse response, Object command, BindException errors)throws Exception {
		try {
			MensajeTransaccionBean mensaje = null;
			RegulatorioD2441Bean regulatorioD2441Bean = (RegulatorioD2441Bean) command;

			regulatorioD2441Servicio.getRegulatorioD2441DAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
			
			int tipoReporte = (request.getParameter("tipoReporte") != null)
					? Integer.parseInt(request.getParameter("tipoReporte"))
					: 0;
					
			int tipoEntidad = (request.getParameter("tipoEntidad") != null)
					? Integer.parseInt(request.getParameter("tipoEntidad"))
					: 0;
			
					
			regulatorioD2441Servicio.listaReporteRegulatorioD2441(tipoReporte, tipoEntidad, regulatorioD2441Bean, response);

		
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return null;
	}
	
	
		

	public RegulatorioD2441Servicio getRegulatorioD2441Servicio() {
		return regulatorioD2441Servicio;
	}
	public void setRegulatorioD2441Servicio(
			RegulatorioD2441Servicio regulatorioD2441Servicio) {
		this.regulatorioD2441Servicio = regulatorioD2441Servicio;
	}
	public String getSuccessView() {
		return successView;
	}
	public void setSuccessView(String successView) {
		this.successView = successView;
	}
	
}

