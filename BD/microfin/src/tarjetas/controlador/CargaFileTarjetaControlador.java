package tarjetas.controlador;

import general.bean.MensajeTransaccionArchivoBean;

import java.io.File;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.commons.io.FileUtils;
import org.springframework.validation.BindException;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import tarjetas.bean.CargaArchivosTarjetaBean;
import tarjetas.servicio.CargaArchivosTarjetaServicio;

public class CargaFileTarjetaControlador extends  SimpleFormController{
	
	CargaArchivosTarjetaServicio cargaArchivosTarjetaServicio = null;
	
	public CargaFileTarjetaControlador(){
 		setCommandClass(CargaArchivosTarjetaBean.class);
 		setCommandName("cargaArchivosTarjetaBean");
 	}

	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws ServletException, IOException  {
		
		CargaArchivosTarjetaBean bean = (CargaArchivosTarjetaBean) command;
		String recurso ="";
        String directorio ="";
        String nombreArchivo ="";
        String tipoCarga= "";
        cargaArchivosTarjetaServicio.getCargaArchivosTarjetaDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
		recurso = request.getParameter("recurso");
		nombreArchivo = request.getParameter("nombreArchivo");
		tipoCarga = request.getParameter("tipoCarga");
		bean.setTipoCarga(tipoCarga);
		directorio =	recurso+"TarjetaCredito/";
		String ruta = directorio+nombreArchivo;
		String MXN ="MXN";
        boolean resultado = nombreArchivo.contains(MXN);
        if(resultado){
           bean.setTipoArchivo("L");
        }else{
        	bean.setTipoArchivo("I");
        }
		MensajeTransaccionArchivoBean mensaje = null;
		if(tipoTransaccion==1){
			boolean exists = (new File(directorio)).exists();
    		if (exists) {	
    			MultipartFile file = bean.getFile();
    			if (file != null) {
    				File filespring = new File(ruta);
    				FileUtils.writeByteArrayToFile(filespring, file.getBytes());  
    			}
    		}else {
    			File aDir = new File(directorio);
    			aDir.mkdir();
    			MultipartFile file = bean.getFile();
    			if (file != null) {
    				File filespring = new File(ruta);
                  	FileUtils.writeByteArrayToFile(filespring, file.getBytes());  
    			}
    		} 
			mensaje = cargaArchivosTarjetaServicio.grabaArchivo(tipoTransaccion, bean);
			mensaje.setRecursoOrigen(ruta);
			mensaje.setNombreControl(ruta+"|"+mensaje.getConsecutivoString());
		}

 		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
		
	}

	public CargaArchivosTarjetaServicio getCargaArchivosTarjetaServicio() {
		return cargaArchivosTarjetaServicio;
	}

	public void setCargaArchivosTarjetaServicio(
			CargaArchivosTarjetaServicio cargaArchivosTarjetaServicio) {
		this.cargaArchivosTarjetaServicio = cargaArchivosTarjetaServicio;
	}
	
}