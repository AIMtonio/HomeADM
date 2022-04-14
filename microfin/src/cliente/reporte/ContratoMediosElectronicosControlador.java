package cliente.reporte;

import general.bean.ParametrosSesionBean;
import herramientas.Utileria;

import java.io.ByteArrayOutputStream;
import java.util.List;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.util.Calendar;

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
import herramientas.Constantes;

import cliente.bean.CuentasBCAMovilBean;
import cliente.servicio.CuentasBCAMovilServicio;

public class ContratoMediosElectronicosControlador extends AbstractCommandController{
	
	CuentasBCAMovilServicio cuentasBCAMovilServicio = null;
	
	String nombreReporte= null;
	String successView = null;
	
	public static interface Enum_Con_TipoReporte {
		  int  ReportePDF	= 1;
	}
	
	public  ContratoMediosElectronicosControlador () {
		setCommandClass(CuentasBCAMovilBean.class);
		setCommandName("cuentasBCAMovilBean");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors)throws Exception {
	
	CuentasBCAMovilBean cuentasBCAMovilBean = (CuentasBCAMovilBean) command;

	int tipoReporte =(request.getParameter("tipoReporte")!=null)?
			Integer.parseInt(request.getParameter("tipoReporte")):0;
	
	switch(tipoReporte){
		case Enum_Con_TipoReporte.ReportePDF:
			ByteArrayOutputStream htmlStringPDF = ContratoMediosElectronicos(cuentasBCAMovilBean, nombreReporte, response);
		break;
	}
	return null;
	}
	
	// Reporte de Lineas de Credito por Disposiciones en PDF
	public ByteArrayOutputStream ContratoMediosElectronicos(CuentasBCAMovilBean cuentasBCAMovilBean, String nombreReporte, HttpServletResponse response){
		ByteArrayOutputStream htmlStringPDF = null;
		try {
			htmlStringPDF = cuentasBCAMovilServicio.contratoMediosElectronicos(cuentasBCAMovilBean, nombreReporte);
			response.addHeader("Content-Disposition","inline; filename=ContratoMediosElectronicos.pdf");
			response.setContentType("application/pdf");
			byte[] bytes = htmlStringPDF.toByteArray();
			response.getOutputStream().write(bytes,0,bytes.length);
			response.getOutputStream().flush();
			response.getOutputStream().close();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return htmlStringPDF;
	}

	//* ============== Getter & Setter =============  //*	
	
	public CuentasBCAMovilServicio getCuentasBCAMovilServicio() {
		return cuentasBCAMovilServicio;
	}

	public void setCuentasBCAMovilServicio(
			CuentasBCAMovilServicio cuentasBCAMovilServicio) {
		this.cuentasBCAMovilServicio = cuentasBCAMovilServicio;
	}

	public String getNombreReporte() {
		return nombreReporte;
	}

	public void setNombreReporte(String nombreReporte) {
		this.nombreReporte = nombreReporte;
	}

	public String getSuccessView() {
		return successView;
	}

	public void setSuccessView(String successView) {
		this.successView = successView;
	}

	
}
