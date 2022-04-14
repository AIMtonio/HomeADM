package pld.reporte;
import general.bean.ParametrosAuditoriaBean;
import herramientas.Utileria;

import java.io.ByteArrayOutputStream;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
 
import org.apache.log4j.Logger;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;








//import cliente.bean.ClienteBean;
//import cliente.servicio.ClienteServicio;
//import cliente.reporte.ReportePerfilCteControlador.Enum_Con_TipRepor;
import pld.bean.FormatoVerificaDomBean;
import pld.bean.SociosSinActCrediticiaRepBean;
import reporte.ParametrosReporte;
import reporte.Reporte;


public class FormatoVerificaDomControlador extends AbstractCommandController {
	
	private ParametrosAuditoriaBean parametrosAuditoriaBean=null;
	String successView = null;
	String nombreReporte= null;
	protected final Logger loggerSAFI = Logger.getLogger("SAFI");
	
	
	public FormatoVerificaDomControlador(){
		setCommandClass(FormatoVerificaDomBean.class);
		setCommandName("formatoVerificaDomBean");
	}
    
	protected ModelAndView handle(HttpServletRequest request,
				HttpServletResponse response,
				Object command,
				BindException errors) throws Exception {

					FormatoVerificaDomBean formatoVerificaDomBean = (FormatoVerificaDomBean) command;
					ByteArrayOutputStream htmlStringPDF = formatoVerificaDomPDF(formatoVerificaDomBean, nombreReporte, response);
				
					return null;	
		}
	
	// Reporte de Socios sin Actividad Crediticia 
	public ByteArrayOutputStream formatoVerificaDomPDF(FormatoVerificaDomBean formatoVerificaDomBean, String nombreReporte, HttpServletResponse response){
		ByteArrayOutputStream htmlStringPDF = null;
		try {
			htmlStringPDF = creaRepFormatoVerificaDomPDF(formatoVerificaDomBean, nombreReporte);
			response.addHeader("Content-Disposition","inline; filename=FormatoVerificaDom.pdf");
			response.setContentType("application/pdf");
			byte[] bytes = htmlStringPDF.toByteArray();
			response.getOutputStream().write(bytes,0,bytes.length);
			response.getOutputStream().flush();
			response.getOutputStream().close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return htmlStringPDF;
	}
	
	public ByteArrayOutputStream creaRepFormatoVerificaDomPDF(FormatoVerificaDomBean formtatoVerificaDom,String nombreReporte) throws Exception{
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		
		parametrosReporte.agregaParametro("Par_ClienteID",Utileria.convierteEntero(formtatoVerificaDom.getClienteID()));
		
		return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}


	public String getSuccessView() {
		return successView;
	}

	public void setSuccessView(String successView) {
		this.successView = successView;
	}

	public void setNombreReporte(String nombreReporte) {
		this.nombreReporte = nombreReporte;
	}

	public ParametrosAuditoriaBean getParametrosAuditoriaBean() {
		return parametrosAuditoriaBean;
	}

	public void setParametrosAuditoriaBean(
			ParametrosAuditoriaBean parametrosAuditoriaBean) {
		this.parametrosAuditoriaBean = parametrosAuditoriaBean;
	}
		

}
