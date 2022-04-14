package ventanilla.reporte;

import herramientas.Utileria;

import java.io.ByteArrayOutputStream;
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

import credito.bean.CreditosBean;
import fondeador.bean.CreditoFondeoBean;
import fondeador.bean.RepVencimiPasBean;
import fondeador.reporte.RepVencimienPasivosControlador.Enum_Con_TipRepor;

import ventanilla.bean.CajasVentanillaBean;
import ventanilla.bean.CatalogoGastosAntBean;
import ventanilla.servicio.CajasVentanillaServicio;
import ventanilla.servicio.CatalogoGastosAntServicio;

public class MovGastosAntRepControlador extends AbstractCommandController{
	
	CatalogoGastosAntServicio catalogoGastosAntServicio = null;
	String nombreReporte = null;
	String successView = null;
	
	
public static interface Enum_Con_TipRepor {
		  
		  int  ReporPDF= 1 ;
		  int  ReporExcel= 3 ;
		  
		}
public MovGastosAntRepControlador(){
	setCommandClass(CatalogoGastosAntBean.class);
	setCommandName("catalogoGastosAntBean");	
	
}

protected ModelAndView handle(HttpServletRequest request,
		HttpServletResponse response,
		Object command,
		BindException errors)throws Exception {
	
	CatalogoGastosAntBean catalogoGastosAntBean = (CatalogoGastosAntBean) command;

int tipoReporte =(request.getParameter("tipoReporte")!=null)?
		Integer.parseInt(request.getParameter("tipoReporte")):
	0;
		
String htmlString= "";
		
	switch(tipoReporte){
		
		case Enum_Con_TipRepor.ReporPDF:
			ByteArrayOutputStream htmlStringPDF = gastosAnticiposRepPDF(catalogoGastosAntBean, nombreReporte, response);
		break;	
	}
	return null;		
}

//Reporte de Gastos y Anticipos en pdf
	public ByteArrayOutputStream gastosAnticiposRepPDF(CatalogoGastosAntBean catalogoGastosAntBean, String nombreReporte, HttpServletResponse response){
		ByteArrayOutputStream htmlStringPDF = null;
		try {
			htmlStringPDF = catalogoGastosAntServicio.creaRepGastosAnticiposPDF(catalogoGastosAntBean, nombreReporte);
			response.addHeader("Content-Disposition","inline; filename=RepMovGastosAnticipos.pdf");
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



	public CatalogoGastosAntServicio getCatalogoGastosAntServicio() {
		return catalogoGastosAntServicio;
	}

	public String getNombreReporte() {
		return nombreReporte;
	}

	public String getSuccessView() {
		return successView;
	}

	public void setCatalogoGastosAntServicio(CatalogoGastosAntServicio catalogoGastosAntServicio) {
		this.catalogoGastosAntServicio = catalogoGastosAntServicio;
	}

	public void setNombreReporte(String nombreReporte) {
		this.nombreReporte = nombreReporte;
	}

	public void setSuccessView(String successView) {
		this.successView = successView;
	}
	
	
}
