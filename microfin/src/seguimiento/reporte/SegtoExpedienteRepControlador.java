package seguimiento.reporte;

import java.io.ByteArrayOutputStream;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import seguimiento.bean.SegtoArchivoBean;
import seguimiento.servicio.SegtoArchivoServicio;
import tarjetas.bean.TarDebArchAclaBean;

public class SegtoExpedienteRepControlador extends AbstractCommandController{
	
	SegtoArchivoServicio segtoArchivoServicio = null;
	String nombreReporte = null;
	
	public SegtoExpedienteRepControlador(){
 		setCommandClass(SegtoArchivoBean.class);
 		setCommandName("segtoArchivoBean");
 	}
	
	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {

		SegtoArchivoBean segtoArchivoBean = (SegtoArchivoBean) command;
		
		ByteArrayOutputStream htmlString = segtoArchivoServicio.reporteArchivosSegtoPDF(segtoArchivoBean, nombreReporte);
		
		response.addHeader("Content-Disposition","inline; filename=ExpArchivoSegto.pdf");
		response.setContentType("application/pdf");
		byte[] bytes = htmlString.toByteArray();
		response.getOutputStream().write(bytes,0,bytes.length);
		response.getOutputStream().flush();
		response.getOutputStream().close();

		return null;
	}

	public void setSegtoArchivoServicio(SegtoArchivoServicio segtoArchivoServicio) {
		this.segtoArchivoServicio = segtoArchivoServicio;
	}
	
	public void setNombreReporte(String nombreReporte) {
		this.nombreReporte = nombreReporte;
	}
}