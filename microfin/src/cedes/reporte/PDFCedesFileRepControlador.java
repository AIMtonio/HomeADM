package cedes.reporte;



import java.io.ByteArrayOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;
import org.springframework.web.servlet.mvc.SimpleFormController;

import cedes.servicio.CedesFileUploadServicio;
import cedes.bean.CedesArchivosBean;
	

	public class PDFCedesFileRepControlador extends AbstractCommandController{

		CedesFileUploadServicio cedesFileUploadServicio = null;
		String nombreReporte = null;	

	 	public PDFCedesFileRepControlador(){
	 		setCommandClass(CedesArchivosBean.class);
	 		setCommandName("cedesArchivosBean");
	 	}
 
	 	protected ModelAndView handle(HttpServletRequest request,
				  HttpServletResponse response,
				  Object command,
				  BindException errors) throws Exception {

	 		CedesArchivosBean cedesFile = (CedesArchivosBean) command;
	 		String nombreCliente = request.getParameter("nombreCliente");
	 		String cedeID = request.getParameter("cedeID");
	 		ByteArrayOutputStream htmlString = cedesFileUploadServicio.reporteArchivosCuentasPDF(cedesFile, cedeID, nombreCliente, nombreReporte);
	 		
	 		response.addHeader("Content-Disposition","inline; filename=archivoCedes.pdf");
	 		response.setContentType("application/pdf");
	 		byte[] bytes = htmlString.toByteArray();
	 		response.getOutputStream().write(bytes,0,bytes.length);
			response.getOutputStream().flush();
			response.getOutputStream().close();

	 		return null;
	 	}

		public void setCedesFileUploadServicio(CedesFileUploadServicio cedesFileUploadServicio) {
			this.cedesFileUploadServicio = cedesFileUploadServicio;
		}

		public void setNombreReporte(String nombreReporte) {
			this.nombreReporte = nombreReporte;
		}
		
	}


