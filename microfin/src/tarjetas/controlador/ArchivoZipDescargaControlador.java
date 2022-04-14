package tarjetas.controlador;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.IOUtils;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;
import org.springframework.web.servlet.mvc.Controller;

public class ArchivoZipDescargaControlador implements Controller {
	
	String successView = null;

	public ModelAndView handleRequest(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		// TODO Auto-generated method stub
		
		try {
			

            String nombreFichero = request.getParameter("nombrezip");
            String unPath = request.getParameter("rutaZip");

            response.setContentType("application/zip");
            response.setHeader("Content-Disposition", "attachment; filename=\""
                    + nombreFichero+ "\"");

            InputStream is = new FileInputStream(unPath);
            
            IOUtils.copy(is, response.getOutputStream());
            
            response.flushBuffer();
            
        } catch (IOException ex) {
            // Sacar log de error.
            throw ex;
        }
		
		
		return null;
	}
	public String getSuccessView() {
		return successView;
	}
	public void setSuccessView(String successView) {
		this.successView = successView;
	}
	
}
