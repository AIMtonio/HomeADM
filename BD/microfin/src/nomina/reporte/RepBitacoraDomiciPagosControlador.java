package nomina.reporte;

import java.io.ByteArrayOutputStream;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import general.bean.MensajeTransaccionBean;
import nomina.bean.BitacoraDomiciPagosBean;
import nomina.servicio.BitacoraDomiciPagosServicio;

public class RepBitacoraDomiciPagosControlador extends AbstractCommandController{
	
	BitacoraDomiciPagosServicio bitacoraDomiciPagosServicio = null;
	String successView = null;
	String nombreReporte = null;
	public static interface Enum_Con_TipRepor {
		  int  ReporPDF= 1 ;
		  int  ReporExcel= 2 ;
	}
	public RepBitacoraDomiciPagosControlador(){
		setCommandClass(BitacoraDomiciPagosBean.class);
		setCommandName("bitacoraDomiciPagosBean");
	}
	
	@Override
	protected ModelAndView handle(HttpServletRequest request, HttpServletResponse response, Object command,
			BindException errors) throws Exception {
		MensajeTransaccionBean mensaje = null;
		BitacoraDomiciPagosBean bitacoraDomiciPagosBean = (BitacoraDomiciPagosBean) command;
		
		int tipoReporte = (request.getParameter("tipoReporte") != null)
				? Integer.parseInt(request.getParameter("tipoReporte"))
				: 0;
		switch(tipoReporte){
			case Enum_Con_TipRepor.ReporPDF:
				ByteArrayOutputStream htmlStringPDF = reporteBitacoraDomiciPDF(bitacoraDomiciPagosBean,nombreReporte,response);
				break;
			case Enum_Con_TipRepor.ReporExcel:
				bitacoraDomiciPagosServicio.generaReporteExcel(bitacoraDomiciPagosBean,response);
				break;
		}

		return null;
	}
	
	public ByteArrayOutputStream reporteBitacoraDomiciPDF(BitacoraDomiciPagosBean bitacoraBean,String nombreReporte,HttpServletResponse response){
		ByteArrayOutputStream htmlStringPDF = null;
		try {
			htmlStringPDF = bitacoraDomiciPagosServicio.repBitacoraPDF(bitacoraBean, nombreReporte);
			response.addHeader("Content-Disposition","inline; filename=RepBitacoraDomiciPagos.pdf");
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
	
	
	
	
	public BitacoraDomiciPagosServicio getBitacoraDomiciPagosServicio() {
		return bitacoraDomiciPagosServicio;
	}

	public void setBitacoraDomiciPagosServicio(BitacoraDomiciPagosServicio bitacoraDomiciPagosServicio) {
		this.bitacoraDomiciPagosServicio = bitacoraDomiciPagosServicio;
	}

	public String getSuccessView() {
		return successView;
	}

	public void setSuccessView(String successView) {
		this.successView = successView;
	}

	public String getNombreReporte() {
		return nombreReporte;
	}

	public void setNombreReporte(String nombreReporte) {
		this.nombreReporte = nombreReporte;
	}
	
	
}
