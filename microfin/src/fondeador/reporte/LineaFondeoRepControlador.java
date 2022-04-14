package fondeador.reporte;

import fondeador.bean.LineaFondeadorBean;
import fondeador.servicio.LineaFondeadorServicio;
import inversiones.bean.InversionBean;
import inversiones.reporte.AperturasInvRepControlador.Enum_Con_TipRepor;
import inversiones.servicio.InversionServicio;

import java.io.ByteArrayOutputStream;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

public class LineaFondeoRepControlador extends AbstractCommandController{
	
	LineaFondeadorServicio lineaFondeadorServicio = null;
	String nombreReporte = null;
	String successView = null;		   
	
	public static interface Enum_Con_TipRepor {
		int ReporPantalla =1;  
		int  ReporPDF= 2 ;
		  
	}
	
	public LineaFondeoRepControlador() {
		setCommandClass(LineaFondeadorBean.class);
		setCommandName("lineaFondeadorBean");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {

		LineaFondeadorBean lineaFondeadorBean = (LineaFondeadorBean) command;
		
		int tipoReporte =(request.getParameter("tipoReporte")!=null)?
				Integer.parseInt(request.getParameter("tipoReporte")):0;
		
		String htmlString= "";
		
		switch(tipoReporte){	
		case Enum_Con_TipRepor.ReporPantalla:
			 htmlString = lineaFondeadorServicio.repLinFonPDF(lineaFondeadorBean, nombreReporte);
		break;
		case Enum_Con_TipRepor.ReporPDF:
			ByteArrayOutputStream htmlStringPDF = reporteLineaFondeoPDF(lineaFondeadorBean, nombreReporte, response);
		break;
		}
		if(tipoReporte ==Enum_Con_TipRepor.ReporPantalla ){
			return new ModelAndView(getSuccessView(), "reporte", htmlString);
		}else {
			return null;
		}
	}
	

	public ByteArrayOutputStream reporteLineaFondeoPDF(LineaFondeadorBean lineaFondeadorBean, String nombreReporte, HttpServletResponse response){
		ByteArrayOutputStream htmlStringPDF = null;
		try {
			htmlStringPDF = lineaFondeadorServicio.repLineaFonPDF(lineaFondeadorBean, nombreReporte);
			response.addHeader("Content-Disposition","inline; filename=DetalleLineaFondeo.pdf");
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

	public LineaFondeadorServicio getLineaFondeadorServicio() {
		return lineaFondeadorServicio;
	}

	public String getNombreReporte() {
		return nombreReporte;
	}

	public String getSuccessView() {
		return successView;
	}

	public void setLineaFondeadorServicio(
			LineaFondeadorServicio lineaFondeadorServicio) {
		this.lineaFondeadorServicio = lineaFondeadorServicio;
	}

	public void setNombreReporte(String nombreReporte) {
		this.nombreReporte = nombreReporte;
	}

	public void setSuccessView(String successView) {
		this.successView = successView;
	}
	
}