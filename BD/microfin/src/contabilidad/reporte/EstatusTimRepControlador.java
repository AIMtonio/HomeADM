package contabilidad.reporte;
import herramientas.Utileria;

import java.io.BufferedWriter;
import java.io.OutputStreamWriter;
import java.io.FileOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.List;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.DataFormat;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.streaming.SXSSFSheet;
import org.apache.poi.xssf.streaming.SXSSFWorkbook;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFDataFormat;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.HSSFColor;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import soporte.servicio.ParametrosSisServicio;

import contabilidad.bean.EstatusTimbradoProdBean;
import contabilidad.servicio.EstatusTimbradoProdServicio;

public class EstatusTimRepControlador extends AbstractCommandController  {
	
	public static interface Enum_Con_TipRepor {
		int  ReporExcel= 1 ; 	 
	}	
	
	EstatusTimbradoProdServicio estatusTimbradoProdServicio = null;
	ParametrosSisServicio parametrosSisServicio = null;
	
	String successView = null;
	
	public EstatusTimRepControlador () {
		setCommandClass(EstatusTimbradoProdBean.class);
		setCommandName("estatusTimbradoProdBean");
	}

	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response, Object command, BindException errors)
			throws Exception {
		try {
			
			EstatusTimbradoProdBean estatusTimbradoProd = (EstatusTimbradoProdBean) command;
			int tipoReporte = (request.getParameter("tipoReporte") != null) ? Integer.parseInt(request.getParameter("tipoReporte")) : 0;
			String anio = request.getParameter("anio");;
			
			estatusTimbradoProd.setAnio(anio);
			
			List listaReportes;
			estatusTimbradoProdServicio.listaReportesTimbrado(tipoReporte, estatusTimbradoProd, response);
		
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		
		return null;
	}

	public EstatusTimbradoProdServicio getEstatusTimbradoProdServicio() {
		return estatusTimbradoProdServicio;
	}

	public void setEstatusTimbradoProdServicio(
			EstatusTimbradoProdServicio estatusTimbradoProdServicio) {
		this.estatusTimbradoProdServicio = estatusTimbradoProdServicio;
	}

	public String getSuccessView() {
		return successView;
	}

	public void setSuccessView(String successView) {
		this.successView = successView;
	}

	public ParametrosSisServicio getParametrosSisServicio() {
		return parametrosSisServicio;
	}

	public void setParametrosSisServicio(ParametrosSisServicio parametrosSisServicio) {
		this.parametrosSisServicio = parametrosSisServicio;
	}
	
	

	
}

