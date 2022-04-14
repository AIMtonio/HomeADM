package regulatorios.reporte;

import herramientas.Constantes;
import java.io.BufferedWriter;
import java.io.FileInputStream;
import java.io.FileWriter;
import java.io.File;
import java.io.IOException;
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

import regulatorios.bean.RepRegCatalogoMinimoBean;
import regulatorios.servicio.RepRegCatalogoMinimoServicio;
import regulatorios.servicio.RepRegCatalogoMinimoServicio.Enum_Lis_RepRegCatalogoMinimo;

public class ReporteRegCatalogoMinimoControlador extends AbstractCommandController{
	

	RepRegCatalogoMinimoServicio repRegCatalogoMinimoServicio = null;
	String nombreReporte = null;
	String successView = null;	
	String nomTipoReporte = "";
	
	public static interface Enum_Tip_RepRegCatalogoMinimo{
		  
		  int  reporteExcel		= 1 ;
		  int  reporteTxt		= 2 ;
		  int  reportePantalla	= 3 ;
		  int  reportePDF		= 4 ;
	}
	
	public static interface Enum_Tip_RepRegCatalogoMinimoVer2015{
		  int  Excel		= 1 ;
		  int  CVS			= 2 ;
	}
	

 	public ReporteRegCatalogoMinimoControlador(){
 		setCommandClass(RepRegCatalogoMinimoBean.class);
 		setCommandName("repRegCatalogoMinimoBean");
 	}

	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response, Object command, BindException errors)
			throws Exception {
		try {
			RepRegCatalogoMinimoBean repRegCatalogoMinimoBean = (RepRegCatalogoMinimoBean) command;
	
			int tipoReporte = (request.getParameter("tipoReporte") != null) ? Integer.parseInt(request.getParameter("tipoReporte")) : 0;
			int version = (request.getParameter("version") != null) ? Integer.parseInt(request.getParameter("version")) : 0;
			
			int tipoEntidad = (request.getParameter("tipoEntidad") != null)
					? Integer.parseInt(request.getParameter("tipoEntidad"))
					: 0;
	
			String htmlString = "";
			List listaReportes;
			
			repRegCatalogoMinimoServicio.listaReportesVer2015(tipoReporte,tipoEntidad, repRegCatalogoMinimoBean, version, response);
		
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

	public RepRegCatalogoMinimoServicio getRepRegCatalogoMinimoServicio() {
		return repRegCatalogoMinimoServicio;
	}

	public void setRepRegCatalogoMinimoServicio(
			RepRegCatalogoMinimoServicio repRegCatalogoMinimoServicio) {
		this.repRegCatalogoMinimoServicio = repRegCatalogoMinimoServicio;
	}

}
