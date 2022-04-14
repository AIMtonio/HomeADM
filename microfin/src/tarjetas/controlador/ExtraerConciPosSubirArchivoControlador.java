package tarjetas.controlador;

import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;
import general.servicio.ParametrosAplicacionServicio;

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

public class ExtraerConciPosSubirArchivoControlador extends SimpleFormController {

	ParametrosAplicacionServicio	parametrosAplicacionServicio	= null;
	
	public ExtraerConciPosSubirArchivoControlador(){
		setCommandClass(CargaArchivosTarjetaBean.class);
 		setCommandName("cargaArchivosTarjetaBean");
	}
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws ServletException, IOException  {
		
		CargaArchivosTarjetaBean extraArchivoBean = (CargaArchivosTarjetaBean) command;
		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
				Integer.parseInt(request.getParameter("tipoTransaccion")):
			0;
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		
		ParametrosSesionBean parametros = parametrosAplicacionServicio.consultaParametrosSessionLocal();
		
		String directorio = parametros.getRutaArchivos()+"ExtraerTarjetas/";
		String archivoNombre = "";
		try{
		boolean exists = (new File(directorio)).exists();
		if (exists) {
			MultipartFile file = extraArchivoBean.getFile();
			archivoNombre =directorio+System.getProperty("file.separator")+extraArchivoBean.getFile().getOriginalFilename();
			if (file != null) {
				File filespring = new File(archivoNombre);
				FileUtils.writeByteArrayToFile(filespring, file.getBytes());  
			}
		}else {
			File aDir = new File(directorio);
			aDir.mkdir();
			MultipartFile file = extraArchivoBean.getFile();
			archivoNombre =directorio+System.getProperty("file.separator")+extraArchivoBean.getFile().getOriginalFilename();
			if (file != null) {
				File filespring = new File(archivoNombre);
				FileUtils.writeByteArrayToFile(filespring, file.getBytes());				
			}
		}
		}catch(Exception e){
			e.printStackTrace();
		}
		mensaje = new MensajeTransaccionBean();
		mensaje.setNumero(0);
		mensaje.setDescripcion("Archivo Cargado Exitósamente ");
		mensaje.setNombreControl(directorio+extraArchivoBean.getFile().getOriginalFilename());
		ModelAndView modelAndView = new ModelAndView("resultadoTransaccionArchivoConciliaVista");
		modelAndView.addObject("mensaje", mensaje);

		return modelAndView;
	}
	
	public ParametrosAplicacionServicio getParametrosAplicacionServicio() {
		return parametrosAplicacionServicio;
	}

	public void setParametrosAplicacionServicio(
			ParametrosAplicacionServicio parametrosAplicacionServicio) {
		this.parametrosAplicacionServicio = parametrosAplicacionServicio;
	}
}
