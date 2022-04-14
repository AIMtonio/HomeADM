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

import regulatorios.bean.EstimacionPreventivaA419Bean;
import regulatorios.servicio.EstimacionPreventivaA419Servicio;
import general.bean.MensajeTransaccionBean;
import herramientas.Utileria;

public class ReporteEstPrevA419Controlador extends AbstractCommandController  {

 
	public static interface Enum_Con_TipReporte {		
		  int  ReporExcel= 1;
		  int  ReporCsv= 2;
	}
	
	EstimacionPreventivaA419Servicio estimacionPreventivaA419Servicio = null;
	String successView = null;
	
	public ReporteEstPrevA419Controlador () {
		setCommandClass(EstimacionPreventivaA419Bean.class);
		setCommandName("A0419Bean");
	}

	@Override
	protected ModelAndView handle(HttpServletRequest request, HttpServletResponse response,Object command, BindException errors)throws Exception {
		
		MensajeTransaccionBean mensaje = null;
		EstimacionPreventivaA419Bean a0419Bean = (EstimacionPreventivaA419Bean) command;
	
		int tipoReporte =(request.getParameter("tipoReporte")!=null)?Integer.parseInt(request.getParameter("tipoReporte")): 0;

		int tipoEntidad = (request.getParameter("tipoEntidad") != null)
				? Integer.parseInt(request.getParameter("tipoEntidad"))
				: 0;
				
				
		estimacionPreventivaA419Servicio.consultaRegulatorioA0419(tipoReporte,tipoEntidad,a0419Bean,response);
					
		return null;	
		}




	// Setter y Getters
	
	public String getSuccessView() {
		return successView;
	}
	
	public EstimacionPreventivaA419Servicio getEstimacionPreventivaA419Servicio() {
		return estimacionPreventivaA419Servicio;
	}

	public void setEstimacionPreventivaA419Servicio(
			EstimacionPreventivaA419Servicio estimacionPreventivaA419Servicio) {
		this.estimacionPreventivaA419Servicio = estimacionPreventivaA419Servicio;
	}

	public void setSuccessView(String successView) {
		this.successView = successView;
	}

}
