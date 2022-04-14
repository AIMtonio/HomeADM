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

import regulatorios.bean.RegulatorioD2442Bean;
import regulatorios.servicio.RegulatorioD2442Servicio;


public class RegulatorioD2442ReporteControlador extends AbstractCommandController{
	RegulatorioD2442Servicio regulatorioD2442Servicio = null;
	String successView = null;
	
	public static interface Enum_Con_TipReporte {
		  int  ReporExcel= 1;
		  int  ReporCsv= 2;
	}
	
	public RegulatorioD2442ReporteControlador () {
		setCommandClass(RegulatorioD2442Bean.class);
		setCommandName("regulatorioD2442Bean");
	}

	protected ModelAndView handle(HttpServletRequest request,HttpServletResponse response, Object command, BindException errors)throws Exception {
		try {
			MensajeTransaccionBean mensaje = null;
			RegulatorioD2442Bean regulatorioD2442Bean = (RegulatorioD2442Bean) command;

			regulatorioD2442Servicio.getRegulatorioD2442DAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
			
			int tipoReporte = (request.getParameter("tipoReporte") != null)
					? Integer.parseInt(request.getParameter("tipoReporte"))
					: 0;
					
			int tipoEntidad = (request.getParameter("tipoEntidad") != null)
					? Integer.parseInt(request.getParameter("tipoEntidad"))
					: 0;
			
					
			regulatorioD2442Servicio.listaReporteRegulatorioD2442(tipoReporte, tipoEntidad, regulatorioD2442Bean, response);


		
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return null;
	}
	
	public RegulatorioD2442Servicio getRegulatorioD2442Servicio() {
		return regulatorioD2442Servicio;
	}
	public void setRegulatorioD2442Servicio(
			RegulatorioD2442Servicio regulatorioD2442Servicio) {
		this.regulatorioD2442Servicio = regulatorioD2442Servicio;
	}
	public String getSuccessView() {
		return successView;
	}
	public void setSuccessView(String successView) {
		this.successView = successView;
	}
	
}

