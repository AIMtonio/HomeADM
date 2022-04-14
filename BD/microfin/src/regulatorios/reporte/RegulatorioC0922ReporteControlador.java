
	package regulatorios.reporte;

import herramientas.Utileria;

import java.util.List;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFDataFormat;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.ss.util.CellRangeAddress;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import regulatorios.bean.RegulatorioC0922Bean;
import regulatorios.servicio.RegulatorioC0922Servicio;
import regulatorios.servicio.RegulatorioC0922Servicio.Enum_Lis_ReportesC0922;

public class RegulatorioC0922ReporteControlador extends AbstractCommandController{
	RegulatorioC0922Servicio regulatorioC0922Servicio = null;
	String successView = null;

	
	public RegulatorioC0922ReporteControlador () {
		setCommandClass(RegulatorioC0922Bean.class);
		setCommandName("RegulatorioC0922Bean");
	}

	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors)throws Exception {
		RegulatorioC0922Bean reporteBean = (RegulatorioC0922Bean) command;
		int tipoReporte =(request.getParameter("tipoReporte")!=null)?Integer.parseInt(request.getParameter("tipoReporte")):0;
		int tipoEntidad =(request.getParameter("tipoEntidad")!=null)?Integer.parseInt(request.getParameter("tipoEntidad")):0;
				
		
		regulatorioC0922Servicio.listaReporteRegulatorioC0922(tipoReporte,tipoEntidad, reporteBean, response); ;
		return null;	
	}
 


	public String getSuccessView() {
		return successView;
	}
	public void setSuccessView(String successView) {
		this.successView = successView;
	}

	public RegulatorioC0922Servicio getRegulatorioC0922Servicio() {
		return regulatorioC0922Servicio;
	}

	public void setRegulatorioC0922Servicio(
			RegulatorioC0922Servicio RegulatorioC0922Servicio) {
		this.regulatorioC0922Servicio = RegulatorioC0922Servicio;
	}
	
}