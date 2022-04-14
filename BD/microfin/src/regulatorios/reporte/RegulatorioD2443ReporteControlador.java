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

import regulatorios.bean.RegulatorioD2443Bean;
import regulatorios.servicio.RegulatorioD2443Servicio;


public class RegulatorioD2443ReporteControlador extends AbstractCommandController{
	RegulatorioD2443Servicio regulatorioD2443Servicio = null;
	String successView = null;
	
	public static interface Enum_Con_TipReporte {
		  int  ReporExcel= 1;
		  int  ReporCsv= 2;
	}
	
	public RegulatorioD2443ReporteControlador () {
		setCommandClass(RegulatorioD2443Bean.class);
		setCommandName("regulatorioD2443Bean");
	}

	protected ModelAndView handle(HttpServletRequest request,HttpServletResponse response, Object command, BindException errors)throws Exception {
		try {
			MensajeTransaccionBean mensaje = null;
			RegulatorioD2443Bean regulatorioD2443Bean = (RegulatorioD2443Bean) command;

			regulatorioD2443Servicio.getRegulatorioD2443DAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
			
			int tipoReporte = (request.getParameter("tipoReporte") != null)
					? Integer.parseInt(request.getParameter("tipoReporte"))
					: 0;
					
			int tipoEntidad = (request.getParameter("tipoEntidad") != null)
					? Integer.parseInt(request.getParameter("tipoEntidad"))
					: 0;
			
					
			regulatorioD2443Servicio.listaReporteRegulatorioD2443(tipoReporte, tipoEntidad, regulatorioD2443Bean, response);
			
			
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return null;
	}
	
	

	public RegulatorioD2443Servicio getRegulatorioD2443Servicio() {
		return regulatorioD2443Servicio;
	}
	public void setRegulatorioD2443Servicio(
			RegulatorioD2443Servicio regulatorioD2443Servicio) {
		this.regulatorioD2443Servicio = regulatorioD2443Servicio;
	}
	public String getSuccessView() {
		return successView;
	}
	public void setSuccessView(String successView) {
		this.successView = successView;
	}
	
}

