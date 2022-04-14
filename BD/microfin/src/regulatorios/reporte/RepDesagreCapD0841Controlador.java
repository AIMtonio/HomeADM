package regulatorios.reporte;

import general.bean.MensajeTransaccionBean;

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

import regulatorios.bean.DesagreCaptaD0841Bean;
import regulatorios.bean.ReporteRegulatorioBean;
import regulatorios.servicio.RegulatorioD0841Servicio;


public class RepDesagreCapD0841Controlador extends AbstractCommandController{
	RegulatorioD0841Servicio regulatorioD841Servicio = null;
	String successView = null;
	
	public static interface Enum_Con_TipReporte {
		  int  ReporExcel= 1;
		  int  ReporCsv= 2;
	}
	
	public RepDesagreCapD0841Controlador () {
		setCommandClass(DesagreCaptaD0841Bean.class);
		setCommandName("desagreCaptaD0841Bean");
	}

	protected ModelAndView handle(HttpServletRequest request,HttpServletResponse response, Object command, BindException errors)throws Exception {
		try {
			MensajeTransaccionBean mensaje = null;
			DesagreCaptaD0841Bean D841RepBean = (DesagreCaptaD0841Bean) command;

			int tipoReporte = (request.getParameter("tipoReporte") != null)
					? Integer.parseInt(request.getParameter("tipoReporte"))
					: 0;
						
			int tipoEntidad =  (request.getParameter("tipoEntidad") != null)
					? Integer.parseInt(request.getParameter("tipoEntidad"))
					: 0;
			
			regulatorioD841Servicio.listaReporteRegulatorioD841(tipoReporte, tipoEntidad, D841RepBean, response);
			
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return null;
	}
	
	

	public String getSuccessView() {
		return successView;
	}
	public void setSuccessView(String successView) {
		this.successView = successView;
	}

	public RegulatorioD0841Servicio getRegulatorioD841Servicio() {
		return regulatorioD841Servicio;
	}

	public void setRegulatorioD841Servicio(
			RegulatorioD0841Servicio regulatorioD841Servicio) {
		this.regulatorioD841Servicio = regulatorioD841Servicio;
	}
	
	
	
}

