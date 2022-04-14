
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

import regulatorios.bean.RegulatorioA2111Bean;
import regulatorios.servicio.RegulatorioA2111Servicio;
import regulatorios.servicio.RegulatorioA2111Servicio.Enum_Lis_ReportesA2111;

public class RegulatorioA2111ReporteControlador extends AbstractCommandController{
	RegulatorioA2111Servicio regulatorioA2111Servicio = null;
	String successView = null;
	
	
	public RegulatorioA2111ReporteControlador () {
		setCommandClass(RegulatorioA2111Bean.class);
		setCommandName("regulatorioA2111Bean");
	}

	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors)throws Exception {
		RegulatorioA2111Bean reporteBean = (RegulatorioA2111Bean) command;
		
		regulatorioA2111Servicio.getRegulatorioA2111DAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI());
		
		int tipoReporte =(request.getParameter("tipoReporte")!=null)?
			Integer.parseInt(request.getParameter("tipoReporte")):
			0;
			
		int tipoEntidad =(request.getParameter("tipoEntidad")!=null)?
				Integer.parseInt(request.getParameter("tipoEntidad")):
				0;
		
	

		regulatorioA2111Servicio.listaReporteRegulatorioA2111(tipoReporte,tipoEntidad, reporteBean, response); 

		return null;	
	}

	

	


	public String getSuccessView() {
		return successView;
	}
	public void setSuccessView(String successView) {
		this.successView = successView;
	}

	public RegulatorioA2111Servicio getRegulatorioA2111Servicio() {
		return regulatorioA2111Servicio;
	}

	public void setRegulatorioA2111Servicio(
			RegulatorioA2111Servicio regulatorioA2111Servicio) {
		this.regulatorioA2111Servicio = regulatorioA2111Servicio;
	}

	
	
}
