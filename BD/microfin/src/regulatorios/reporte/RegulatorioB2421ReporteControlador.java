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

import regulatorios.bean.RegulatorioB2421Bean;
import regulatorios.servicio.RegulatorioB2421Servicio;


public class RegulatorioB2421ReporteControlador extends AbstractCommandController{
	RegulatorioB2421Servicio regulatorioB2421Servicio = null;
	String successView = null;
	
	public static interface Enum_Con_TipReporte {
		  int  ReporExcel= 1;
		  int  ReporCsv= 2;
	}
	
	public RegulatorioB2421ReporteControlador () {
		setCommandClass(RegulatorioB2421Bean.class);
		setCommandName("regulatorioB2421Bean");
	}

	protected ModelAndView handle(HttpServletRequest request,HttpServletResponse response, Object command, BindException errors)throws Exception {
		try {
			MensajeTransaccionBean mensaje = null;
			RegulatorioB2421Bean regulatorioB2421Bean = (RegulatorioB2421Bean) command;
			
			regulatorioB2421Servicio.getRegulatorioB2421DAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI());
			
			int tipoReporte = (request.getParameter("tipoReporte") != null)
					? Integer.parseInt(request.getParameter("tipoReporte"))
					: 0;
			

			int tipoEntidad = (request.getParameter("tipoEntidad") != null)
					? Integer.parseInt(request.getParameter("tipoEntidad"))
					: 0;

		  
			regulatorioB2421Servicio.listaReporteRegulatorioB2421(tipoReporte, tipoEntidad, regulatorioB2421Bean, response);
			
			
			
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return null;
	}
	


	
	public RegulatorioB2421Servicio getRegulatorioB2421Servicio() {
		return regulatorioB2421Servicio;
	}

	public void setRegulatorioB2421Servicio(
			RegulatorioB2421Servicio regulatorioB2421Servicio) {
		this.regulatorioB2421Servicio = regulatorioB2421Servicio;
	}

	public String getSuccessView() {
		return successView;
	}
	public void setSuccessView(String successView) {
		this.successView = successView;
	}
	
}

