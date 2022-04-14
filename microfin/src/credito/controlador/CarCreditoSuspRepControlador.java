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

import activos.bean.AplicacionDepreciacionBean;

import credito.bean.CarCreditoSuspendidoBean;
import credito.bean.CreditosBean;
import credito.servicio.CarCreditoSuspendidoServicio;

public class CarCreditoSuspRepControlador extends SimpleFormController {
	
	CarCreditoSuspendidoServicio carCreditoSuspendidoServicio = null;
	String nombreReporte = null;
	String successView = null;
	
	public CarCreditoSuspRepControlador(){
		setCommandClass(CarCreditoSuspendidoBean.class);
		setCommandName("CarCreditoSuspendidoBean");
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
	
	public CarCreditoSuspendidoServicio getCarCreditoSuspendidoServicio() {
		return carCreditoSuspendidoServicio;
	}

	public void setCarCreditoSuspendidoServicio(
			CarCreditoSuspendidoServicio carCreditoSuspendidoServicio) {
		this.carCreditoSuspendidoServicio = carCreditoSuspendidoServicio;
	}
	
}
