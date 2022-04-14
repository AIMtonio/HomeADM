package crowdfunding.controlador;

import java.io.ByteArrayOutputStream;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import crowdfunding.bean.FondeoSolicitudBean;
import crowdfunding.servicio.FondeoSolicitudServicio;

public class DetalleInversionRepPDFControlador extends AbstractCommandController {

	FondeoSolicitudServicio fondeoSolicitudServicio = null;
	String nombreReporte = null;

	public DetalleInversionRepPDFControlador(){
		setCommandClass(FondeoSolicitudBean.class);
		setCommandName("fondeoSolicitudBean");
	}

	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
		FondeoSolicitudBean fondeoSolicitudBean = (FondeoSolicitudBean) command;
		ByteArrayOutputStream htmlStringPDF = imprimeDetalleInvCRW(fondeoSolicitudBean, response);
		return null;
	}

	public ByteArrayOutputStream imprimeDetalleInvCRW(FondeoSolicitudBean fondeoSolicitudBean, HttpServletResponse response) {
		ByteArrayOutputStream htmlString = null;
		try {
			htmlString = fondeoSolicitudServicio.reporteDetalleInversionPDF(fondeoSolicitudBean , nombreReporte);
			response.addHeader("Content-Disposition","inline; filename=DetalleInversion_"+fondeoSolicitudBean.getSolicitudCreditoID().trim()+".pdf");
			response.setContentType("application/pdf");
			byte[] bytes = htmlString.toByteArray();
			response.getOutputStream().write(bytes,0,bytes.length);
			response.getOutputStream().flush();
			response.getOutputStream().close();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return htmlString;
	}
	public void setFondeoSolicitudServicio(
			FondeoSolicitudServicio fondeoSolicitudServicio) {
		this.fondeoSolicitudServicio = fondeoSolicitudServicio;
	}

	public void setNombreReporte(String nombreReporte) {
		this.nombreReporte = nombreReporte;
	}
}