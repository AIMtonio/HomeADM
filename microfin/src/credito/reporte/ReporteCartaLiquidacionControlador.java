package credito.reporte;

import java.io.ByteArrayOutputStream;
import java.io.File;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.FileUtils;
import org.apache.log4j.Logger;
import org.springframework.validation.BindException;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import credito.bean.CartaLiquidacionBean;
import credito.bean.CreditosArchivoBean;
import credito.servicio.CartaLiquidacionServicio;
import general.bean.MensajeTransaccionArchivoBean;
import general.bean.MensajeTransaccionBean;

public class ReporteCartaLiquidacionControlador extends AbstractCommandController {
	
	CartaLiquidacionServicio cartaLiquidacionServicio = null;
	String nombreReporte = null;		 
	
	protected final Logger loggerSAFI = Logger.getLogger("SAFI");
  
 	public ReporteCartaLiquidacionControlador(){
 		setCommandClass(CartaLiquidacionBean.class);
 		setCommandName("cartaLiquidacion");
 	}
 	
 	protected ModelAndView handle(HttpServletRequest request,HttpServletResponse response,Object command,BindException errors) throws Exception {
 		CartaLiquidacionBean cartaLiquidacionBean = (CartaLiquidacionBean) command;
	    
		ByteArrayOutputStream htmlStringPDF = reporteCartaLiquidacionPDF(cartaLiquidacionBean, nombreReporte, response);

		return null;	
 	}
 	
 	// método para crear el reporte en PDF
 	public ByteArrayOutputStream reporteCartaLiquidacionPDF(CartaLiquidacionBean cartaLiquidBean, String nombreReporte, HttpServletResponse response){
 		ByteArrayOutputStream htmlStringPDF = null;
 		MensajeTransaccionArchivoBean mensaje = null;
 		
 		mensaje = cartaLiquidacionServicio.altaCredito(cartaLiquidBean);
 		
 		String recurso = mensaje.getRecursoOrigen();
 		try{
 			htmlStringPDF = cartaLiquidacionServicio.reporteCartaLiquidacionPDF(cartaLiquidBean,nombreReporte);
 	 		response.addHeader("Content-Disposition", "inline; filename=CartaLiquidacion.pdf");
 			response.setContentType("application/pdf");
 			
 					
 			byte[] bytes = htmlStringPDF.toByteArray();
 			response.getOutputStream().write(bytes,0,bytes.length);
 			response.getOutputStream().flush();
 			response.getOutputStream().close();	

 			String dir = cartaLiquidBean.getRecurso() + recurso;
 			if(htmlStringPDF != null) {
 				File filespring = new File(recurso);
 				FileUtils.writeByteArrayToFile(filespring, htmlStringPDF.toByteArray());
 			}		
 		}catch (Exception e){
 			e.printStackTrace();
 		}
 		return htmlStringPDF;
 	}

 	public CartaLiquidacionServicio getCartaLiquidacionServicio() {
		return cartaLiquidacionServicio;
	}

	public void setCartaLiquidacionServicio(CartaLiquidacionServicio cartaLiquidacionServicio) {
		this.cartaLiquidacionServicio = cartaLiquidacionServicio;
	}
	
	public String getNombreReporte() {
		return nombreReporte;
	}

	public void setNombreReporte(String nombreReporte) {
		this.nombreReporte = nombreReporte;
	}
}
