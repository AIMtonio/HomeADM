package credito.controlador;

import java.util.Calendar;
import java.util.List;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.apache.poi.xssf.usermodel.XSSFDataFormat;
import org.apache.poi.xssf.usermodel.XSSFFont;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;
import org.springframework.web.servlet.mvc.SimpleFormController;


import credito.bean.CreditosBean;
import credito.bean.NotasCargoRepBean;
import credito.servicio.NotasCargoServicio;

public class NotasCargoRepControlador extends SimpleFormController {
	
	NotasCargoServicio notasCargoServicio = null;
	String nombreReporte = null;
	String successView = null;
	
	public NotasCargoRepControlador(){
		setCommandClass(NotasCargoRepBean.class);
		setCommandName("notasCargoRepBean");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {

		CreditosBean creditosBean = (CreditosBean) command;
		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
			Integer.parseInt(request.getParameter("tipoTransaccion")):
		0;
	int tipoActualizacion = (request.getParameter("tipoActualizacion")!=null)?
					   Integer.parseInt(request.getParameter("tipoActualizacion")):
						   0;		
					   
	MensajeTransaccionBean mensaje = null;
							
	return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	
}

	public NotasCargoServicio getNotasCargoServicio() {
		return notasCargoServicio;
	}

	public void setNotasCargoServicio(NotasCargoServicio notasCargoServicio) {
		this.notasCargoServicio = notasCargoServicio;
	}


	
}
