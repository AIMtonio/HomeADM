package tesoreria.controlador;

import java.io.ByteArrayOutputStream;
import java.util.List;

import general.bean.MensajeTransaccionBean;
import herramientas.Utileria;

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
import org.springframework.web.servlet.mvc.SimpleFormController;


import tesoreria.bean.ReqGastosSucBean;
import tesoreria.servicio.TesoMovimientosServicio;

 
public class FondSucRepVistaControlador extends SimpleFormController {
	
	
	TesoMovimientosServicio tesoMovimientosServicio= null;
	String nombreReporte = null;
	String successView = null;		

 	public FondSucRepVistaControlador(){

		setCommandClass(ReqGastosSucBean.class);
 		setCommandName("reqGastosSucBean");
 		
 	}
    
 	protected ModelAndView onSubmit(HttpServletRequest request,
				HttpServletResponse response,
				Object command,
				BindException errors) throws Exception {

 		ReqGastosSucBean reqGastosSuc= (ReqGastosSucBean) command;
 		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
				Integer.parseInt(request.getParameter("tipoTransaccion")):
			0;
		int tipoActualizacion = (request.getParameter("tipoActualizacion")!=null)?
						   Integer.parseInt(request.getParameter("tipoActualizacion"))	:
							   0;		
						   
		MensajeTransaccionBean mensaje = null;
		mensaje = new MensajeTransaccionBean();
		mensaje.setNumero(0);

		mensaje.setDescripcion("Reporte Fondeo Sucusal");
								
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
 		

}



	public TesoMovimientosServicio getTesoMovimientosServicio() {
		return tesoMovimientosServicio;
	}

	public void setTesoMovimientosServicio(
			TesoMovimientosServicio tesoMovimientosServicio) {
		this.tesoMovimientosServicio = tesoMovimientosServicio;
	}

	


	public String getNombreReporte() {
		return nombreReporte;
	}

	

	public void setNombreReporte(String nombreReporte) {
		this.nombreReporte = nombreReporte;
	}

	




}





	