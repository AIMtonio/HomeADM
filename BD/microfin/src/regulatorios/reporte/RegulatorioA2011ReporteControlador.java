package regulatorios.reporte;

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

import regulatorios.bean.RegulatorioA2011Bean;
import regulatorios.servicio.RegulatorioA2011Servicio;
import regulatorios.servicio.RegulatorioA2011Servicio.Enum_Lis_ReportesA2011;
import regulatorios.servicio.RegulatorioA2011Servicio.Enum_Lis_ReportesA2011Ver2015;

public class RegulatorioA2011ReporteControlador extends AbstractCommandController{
	RegulatorioA2011Servicio regulatorioA2011Servicio = null;
	String successView = null;
		
	
	public RegulatorioA2011ReporteControlador () {
		setCommandClass(RegulatorioA2011Bean.class);
		setCommandName("regulatoriosCarteraBean");
	}

	protected ModelAndView handle(HttpServletRequest request,HttpServletResponse response,Object command,BindException errors)throws Exception {
		RegulatorioA2011Bean reporteBean = (RegulatorioA2011Bean) command;
		
		regulatorioA2011Servicio.getRegulatorioA2011DAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI());

		int tipoReporte =(request.getParameter("tipoReporte")!=null)?Integer.parseInt(request.getParameter("tipoReporte")):0;
		int tipoEntidad =(request.getParameter("tipoEntidad")!=null)?Integer.parseInt(request.getParameter("tipoEntidad")):0;
		int version=(request.getParameter("version")!=null)?Integer.parseInt(request.getParameter("version")):0;
		
		
		regulatorioA2011Servicio.generaReporteRegulatorioA2011(tipoReporte,tipoEntidad,reporteBean, response, version);
			
	
		return null;	
	}



	

	public String getSuccessView() {
		return successView;
	}
	public void setSuccessView(String successView) {
		this.successView = successView;
	}

	public RegulatorioA2011Servicio getRegulatorioA2011Servicio() {
		return regulatorioA2011Servicio;
	}

	public void setRegulatorioA2011Servicio(
			RegulatorioA2011Servicio regulatorioA2011Servicio) {
		this.regulatorioA2011Servicio = regulatorioA2011Servicio;
	}

	
}