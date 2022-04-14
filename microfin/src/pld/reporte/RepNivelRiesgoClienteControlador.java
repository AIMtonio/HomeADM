package pld.reporte;

import java.io.ByteArrayOutputStream;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import pld.bean.NivelRiesgoClienteBean;
import pld.servicio.NivelRiesgoClienteServicio;


@SuppressWarnings("deprecation")
public class RepNivelRiesgoClienteControlador extends AbstractCommandController{

	NivelRiesgoClienteServicio nivelRiesgoClienteServicio =null;
	String nombreReporte= null;
	String successView = null;	

	public RepNivelRiesgoClienteControlador () {
		setCommandClass(NivelRiesgoClienteBean.class);
		setCommandName("nivelRiesgoCliente");
	}

	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors)throws Exception {
		
		///crear reporte pdf
		NivelRiesgoClienteBean nivelRiesgoClienteRepBean = (NivelRiesgoClienteBean) command;
				
		String htmlString= "";

		ByteArrayOutputStream htmlStringPDF =reporteRiesgosClientePDF(nivelRiesgoClienteRepBean, nombreReporte, response);
		return null;

	}


	// Reporte de nive de risgo actual en PDF
	public ByteArrayOutputStream reporteRiesgosClientePDF(NivelRiesgoClienteBean nivelRiesgoClienteRepBean, String nomReporte, HttpServletResponse response){
		ByteArrayOutputStream htmlStringPDF = null;

		try {
			htmlStringPDF = nivelRiesgoClienteServicio.reporteRiesgoPLDCliente(nivelRiesgoClienteRepBean, nomReporte);
			response.addHeader("Content-Disposition","inline; filename=ReporteRiesgoPLDCliente.pdf");
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
	public NivelRiesgoClienteServicio getNivelRiesgoClienteServicio() {
		return nivelRiesgoClienteServicio;
	}

	public void setNivelRiesgoClienteServicio(
			NivelRiesgoClienteServicio nivelRiesgoClienteServicio) {
		this.nivelRiesgoClienteServicio = nivelRiesgoClienteServicio;
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
