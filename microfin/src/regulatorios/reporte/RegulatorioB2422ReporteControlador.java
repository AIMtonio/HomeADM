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

import regulatorios.bean.RegulatorioB2422Bean;
import regulatorios.servicio.RegulatorioB2422Servicio;


public class RegulatorioB2422ReporteControlador extends AbstractCommandController{
	RegulatorioB2422Servicio regulatorioB2422Servicio = null;
	String successView = null;
	
	public static interface Enum_Con_TipReporte {
		  int  ReporExcel= 1;
		  int  ReporCsv= 2;
	}
	
	public RegulatorioB2422ReporteControlador () {
		setCommandClass(RegulatorioB2422Bean.class);
		setCommandName("regulatorioB2422Bean");
	}

	protected ModelAndView handle(HttpServletRequest request,HttpServletResponse response, Object command, BindException errors)throws Exception {
		try {
			MensajeTransaccionBean mensaje = null;
			RegulatorioB2422Bean regulatorioB2422Bean = (RegulatorioB2422Bean) command;
			
			regulatorioB2422Servicio.getRegulatorioB2422DAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI());
			
			int tipoReporte = (request.getParameter("tipoReporte") != null)
					? Integer.parseInt(request.getParameter("tipoReporte"))
					: 0;
			

			int tipoEntidad = (request.getParameter("tipoEntidad") != null)
					? Integer.parseInt(request.getParameter("tipoEntidad"))
					: 0;

		  
			regulatorioB2422Servicio.listaReporteRegulatorioB2422(tipoReporte, tipoEntidad, regulatorioB2422Bean, response);
			
			
			
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return null;
	}
	


	public RegulatorioB2422Servicio getRegulatorioB2422Servicio() {
		return regulatorioB2422Servicio;
	}
	public void setRegulatorioB2422Servicio(
			RegulatorioB2422Servicio regulatorioB2422Servicio) {
		this.regulatorioB2422Servicio = regulatorioB2422Servicio;
	}
	public String getSuccessView() {
		return successView;
	}
	public void setSuccessView(String successView) {
		this.successView = successView;
	}
	
}

