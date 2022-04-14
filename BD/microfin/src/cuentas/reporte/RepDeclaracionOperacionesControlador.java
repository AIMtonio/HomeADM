package cuentas.reporte;

import java.io.ByteArrayOutputStream;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import cuentas.bean.RepDeclaracionOperacionesBean;
import cuentas.servicio.RepDeclaracionOperacionesServicio;

public class RepDeclaracionOperacionesControlador extends AbstractCommandController{
	
	RepDeclaracionOperacionesServicio repDeclaracionOperacionesServicio = null;
	String nombreReporte = null;
	String successView = null;
	
	public RepDeclaracionOperacionesControlador() {
		setCommandClass(RepDeclaracionOperacionesBean.class);
		setCommandName("repDeclaracionOperacionesBean");
	}
	
	@Override
	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response, Object command, BindException errors)
			throws Exception {
		RepDeclaracionOperacionesBean declaraOpBean = (RepDeclaracionOperacionesBean) command;
		int tipoReporte = 0;
		ByteArrayOutputStream htmlStringPDF = declaracionPersonalPDF(tipoReporte, declaraOpBean, nombreReporte, response);
		return null;
	}

	/* Formato de Declaracion personal de operaciones en PDF */
	public ByteArrayOutputStream declaracionPersonalPDF(int tipoReporte,RepDeclaracionOperacionesBean reporteBean, String nomReporte, HttpServletResponse response){
		ByteArrayOutputStream htmlStringPDF = null;
		try {
			htmlStringPDF = repDeclaracionOperacionesServicio.reporteDecPersonal(tipoReporte,reporteBean, nomReporte);
			response.addHeader("Content-Disposition","inline; filename=FormatoDeclaracionPersonal.pdf");
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

	public RepDeclaracionOperacionesServicio getRepDeclaracionOperacionesServicio() {
		return repDeclaracionOperacionesServicio;
	}

	public void setRepDeclaracionOperacionesServicio(
			RepDeclaracionOperacionesServicio repDeclaracionOperacionesServicio) {
		this.repDeclaracionOperacionesServicio = repDeclaracionOperacionesServicio;
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
