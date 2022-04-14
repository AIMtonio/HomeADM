package tarjetas.controlador;

import java.io.ByteArrayOutputStream;
import java.util.List;

import general.bean.MensajeTransaccionBean;
import herramientas.Utileria;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.apache.poi.hssf.util.HSSFColor;
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

import tarjetas.bean.BitacoraEstatusTarDebBean;
import tarjetas.bean.TarDebMovimientosBean;
import tarjetas.servicio.TarDebMovimientosServicio;

public class ReporteMovtarCtaControlador extends AbstractCommandController{
	TarDebMovimientosServicio tarDebMovimientosServicio = null;
	protected final Logger loggerSAFI = Logger.getLogger("SAFI");
	String successView = null;
	String nomReporte=null;
	

	
	public ReporteMovtarCtaControlador() {
		setCommandClass(TarDebMovimientosBean.class);
		setCommandName("reporteMovtarCta");
	}
	

	protected ModelAndView handle(HttpServletRequest request,HttpServletResponse response,Object command, BindException errors)throws Exception{
		MensajeTransaccionBean mensaje = null;
		TarDebMovimientosBean tarDebMovimientosBean= (TarDebMovimientosBean) command;		
		
		int tipoReporte = Utileria.convierteEntero(request.getParameter("tipoReporte"));
		int tipoPresentacion = Utileria.convierteEntero(request.getParameter("tipoPresentacion"));

		String fechaInicio=request.getParameter("fechaInicio");			
		String fechaFin=request.getParameter("fechaVencimiento");
		String cuentaAho=request.getParameter("cuentaAhoID");			
		String numTarjetaDeb=request.getParameter("tarjetaDebID");
		tarDebMovimientosBean.setFechaInicio(fechaInicio);
		tarDebMovimientosBean.setFechaVencimiento(fechaFin);
		tarDebMovimientosBean.setCuentaAho(cuentaAho);
		tarDebMovimientosBean.setTarjetaDebID(numTarjetaDeb);
		String htmlString= "";
		
	
        mensaje=tarDebMovimientosServicio.generaReporte(tarDebMovimientosBean,response);

		return null;
	}
	
	public TarDebMovimientosServicio getTarDebMovimientosServicio() {
		return tarDebMovimientosServicio;
	}
	public void setTarDebMovimientosServicio(
			TarDebMovimientosServicio tarDebMovimientosServicio) {
		this.tarDebMovimientosServicio = tarDebMovimientosServicio;
	}
	public String getNomReporte() {
		return nomReporte;
	}
	public void setNomReporte(String nomReporte) {
		this.nomReporte = nomReporte;
	}
	public String getSuccessView() {
		return successView;
	}
	public void setSuccessView(String successView) {
		this.successView = successView;
	}
}
