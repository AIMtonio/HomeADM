package pld.reporte;

import general.bean.ParametrosSesionBean;
import herramientas.Utileria;

import java.io.ByteArrayOutputStream;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import pld.bean.PersInvListasBean;
import pld.servicio.PersonaReqSeidoServicio;

public class RepBusquedaSEIDOControlador extends AbstractCommandController {
	
	String nombreReporte = null;
	String successView = null;
	PersonaReqSeidoServicio personaReqSeidoServicio	= null;
	ParametrosSesionBean parametrosSesionBean = null;

	public static interface Enum_Con_TipRepor {
		int	PDF		= 1;
	}
	public RepBusquedaSEIDOControlador() {
		setCommandClass(PersInvListasBean.class);
		setCommandName("PersInvListas");
	}
	
	@Override
	protected ModelAndView handle(HttpServletRequest request,HttpServletResponse response,Object command,BindException errors) throws Exception {
		PersInvListasBean persInvListasBean = (PersInvListasBean) command;
		int tipoReporte = Utileria.convierteEntero(request.getParameter("tipoReporte"));
		String htmlString = "";
		switch (tipoReporte) {
			case Enum_Con_TipRepor.PDF:
				reportePDF(persInvListasBean, nombreReporte, response);
				break;
		}

		return new ModelAndView(getSuccessView(), "reporte", htmlString);
	}

	public ByteArrayOutputStream reportePDF(PersInvListasBean persInvListasBean, String nombreReporte, HttpServletResponse response){
		ByteArrayOutputStream htmlStringPDF = null;
		try {
			htmlStringPDF = personaReqSeidoServicio.reportePDF(persInvListasBean, nombreReporte);
			response.addHeader("Content-Disposition","inline; filename=RepBusquedaPosibleRelOpIli.pdf");
			response.setContentType("application/pdf");
			byte[] bytes = htmlStringPDF.toByteArray();
			response.getOutputStream().write(bytes,0,bytes.length);
			response.getOutputStream().flush();
			response.getOutputStream().close();
		} catch (Exception e) {
			e.printStackTrace();
			// TODO Auto-generated catch block
			e.printStackTrace();
		}		
	return htmlStringPDF;
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

	public PersonaReqSeidoServicio getPersonaReqSeidoServicio() {
		return personaReqSeidoServicio;
	}

	public void setPersonaReqSeidoServicio(PersonaReqSeidoServicio personaReqSeidoServicio) {
		this.personaReqSeidoServicio = personaReqSeidoServicio;
	}

}
