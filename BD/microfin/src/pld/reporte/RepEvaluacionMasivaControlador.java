package pld.reporte;

import general.bean.ParametrosSesionBean;
import herramientas.Utileria;

import java.io.ByteArrayOutputStream;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import pld.bean.NivelRiesgoClienteBean;
import pld.servicio.NivelRiesgoClienteServicio;

public class RepEvaluacionMasivaControlador extends AbstractCommandController{

	NivelRiesgoClienteServicio nivelRiesgoClienteServicio = null;
	ParametrosSesionBean parametrosSesionBean = null;
	String nombreReporte= null;
	String successView = null;	

	public static interface Enum_Con_TipRepor {
		int	PDF		= 1;
		int	EXCEL	= 2;
	}
	
	public RepEvaluacionMasivaControlador () {
		setCommandClass(NivelRiesgoClienteBean.class);
		setCommandName("nivelRiesgoCliente");
	}

	protected ModelAndView handle(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors)throws Exception {
		NivelRiesgoClienteBean nivelRiesgoClienteRepBean = (NivelRiesgoClienteBean) command;

		int tipoReporte = Utileria.convierteEntero(request.getParameter("tipoReporte"));
		String htmlString = "";
		switch (tipoReporte) {
			case Enum_Con_TipRepor.PDF:
				reportePDF(nivelRiesgoClienteRepBean, nombreReporte, response);
				break;
		}

		return new ModelAndView(getSuccessView(), "reporte", htmlString);
	}


	// Reporte de nive de risgo actual en PDF
	public ByteArrayOutputStream reportePDF(NivelRiesgoClienteBean nivelRiesgoClienteRepBean, String nomReporte, HttpServletResponse response){
		ByteArrayOutputStream htmlStringPDF = null;

		try {
			htmlStringPDF = nivelRiesgoClienteServicio.reporteEvaluacionMasivaPDF(nivelRiesgoClienteRepBean, nomReporte);
			response.addHeader("Content-Disposition","inline; filename=EvaluacionMasivaRiesgo.pdf");
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

	public ParametrosSesionBean getParametrosSesionBean() {
		return parametrosSesionBean;
	}

	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}

}