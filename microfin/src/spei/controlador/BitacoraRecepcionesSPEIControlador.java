package spei.controlador;

import herramientas.Utileria;

import java.io.ByteArrayOutputStream;
import java.util.Calendar;
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
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.util.CellRangeAddress;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;
import org.springframework.web.servlet.mvc.SimpleFormController;

import cliente.bean.RepoteClientesMenoresBean;
import cliente.reporte.PDFClientesMenoresControlador.Enum_Con_TipRepor;
import general.bean.MensajeTransaccionBean;
import spei.bean.RepRecepcionesSpeiiBean;
import spei.servicio.RepRecepcionesSpeiiServicio;


public class BitacoraRecepcionesSPEIControlador extends SimpleFormController{
	

	RepRecepcionesSpeiiServicio repRecepcionesSpeiiServicio = null;
	

	public BitacoraRecepcionesSPEIControlador() {
		setCommandClass(RepRecepcionesSpeiiBean.class);
		setCommandName("repRecepcionesSpeiiBean");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse response,
									Object command,							
									BindException errors) throws Exception {
		
	
		RepoteClientesMenoresBean repoteClientesMenoresBean= (RepoteClientesMenoresBean) command;
		MensajeTransaccionBean mensaje = null;
			
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public RepRecepcionesSpeiiServicio getRepRecepcionesSpeiiServicio() {
		return repRecepcionesSpeiiServicio;
	}

	public void setRepRecepcionesSpeiiServicio(
			RepRecepcionesSpeiiServicio repRecepcionesSpeiiServicio) {
		this.repRecepcionesSpeiiServicio = repRecepcionesSpeiiServicio;
	}
}