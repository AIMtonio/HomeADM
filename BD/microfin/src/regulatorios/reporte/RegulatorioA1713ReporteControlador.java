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

import regulatorios.bean.RegulatorioA1713Bean;
import regulatorios.servicio.RegulatorioA1713Servicio;
import regulatorios.servicio.RegulatorioA1713Servicio.Enum_Lis_ReportesA1713;

public class RegulatorioA1713ReporteControlador extends AbstractCommandController{
	RegulatorioA1713Servicio regulatorioA1713Servicio = null;
	String successView = null;

	
	public RegulatorioA1713ReporteControlador () {
		setCommandClass(RegulatorioA1713Bean.class);
		setCommandName("RegulatorioA1713Bean");
	}

	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors)throws Exception {
		RegulatorioA1713Bean reporteBean = (RegulatorioA1713Bean) command;
		int tipoReporte =(request.getParameter("tipoReporte")!=null)?Integer.parseInt(request.getParameter("tipoReporte")):0;
		int tipoEntidad =(request.getParameter("tipoEntidad")!=null)?Integer.parseInt(request.getParameter("tipoEntidad")):0;
				
		
		regulatorioA1713Servicio.listaReporteRegulatorioA1713(tipoReporte,tipoEntidad, reporteBean, response); ;
		return null;	
	}



	public String getSuccessView() {
		return successView;
	}
	public void setSuccessView(String successView) {
		this.successView = successView;
	}

	public RegulatorioA1713Servicio getRegulatorioA1713Servicio() {
		return regulatorioA1713Servicio;
	}

	public void setRegulatorioA1713Servicio(
			RegulatorioA1713Servicio RegulatorioA1713Servicio) {
		this.regulatorioA1713Servicio = RegulatorioA1713Servicio;
	}
	
}