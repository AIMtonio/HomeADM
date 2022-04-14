package cliente.reporte;

import java.io.ByteArrayOutputStream;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;


import cliente.bean.ReporteClienteBean;
import cliente.servicio.ClienteServicio;

public class RepSolicitudIngControlador extends AbstractCommandController{
	ClienteServicio clienteServicio = new ClienteServicio ();
	String nombreReporte = null;

	public RepSolicitudIngControlador(){
		setCommandClass(ReporteClienteBean.class);
		setCommandName("reporteClienteBean");
	}

	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {

				ReporteClienteBean reporteClienteBean= (ReporteClienteBean) command;


				ByteArrayOutputStream htmlStringPDF = reporteSolicitudCtePDF(reporteClienteBean, nombreReporte, response);

				return null;
	}

	public ByteArrayOutputStream reporteSolicitudCtePDF(ReporteClienteBean reporteClienteBean, String nomReporte, HttpServletResponse response){
		ByteArrayOutputStream htmlStringPDF = null;
		try {
			htmlStringPDF = clienteServicio.reporteSolicitudIngresoPDF(reporteClienteBean, nomReporte);
			response.addHeader("Content-Disposition","inline; filename=RepSolicitudIngresoCte.pdf");
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

	public ClienteServicio getClienteServicio() {
		return clienteServicio;
	}

	public String getNombreReporte() {
		return nombreReporte;
	}

	public void setClienteServicio(ClienteServicio clienteServicio) {
		this.clienteServicio = clienteServicio;
	}

	public void setNombreReporte(String nombreReporte) {
		this.nombreReporte = nombreReporte;
	}


}
