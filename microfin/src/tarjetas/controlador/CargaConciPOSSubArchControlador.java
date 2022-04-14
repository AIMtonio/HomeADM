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

import tarjetas.bean.TarDebConciEncabezaBean;
import tarjetas.servicio.TarDebConciliaPosServicio;

public class CargaConciPOSSubArchControlador extends SimpleFormController{
	
	TarDebConciliaPosServicio tarDebConciliaPosServicio = null;
	
	ParametrosAplicacionServicio	parametrosAplicacionServicio	= null;
	
	public CargaConciPOSSubArchControlador(){
		setCommandClass(TarDebConciEncabezaBean.class);
 		setCommandName("cargaConciPOS");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws ServletException, IOException  {
		
		TarDebConciEncabezaBean cargaConciliaBean = (TarDebConciEncabezaBean) command;
		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
				Integer.parseInt(request.getParameter("tipoTransaccion")):
			0;
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		
		ParametrosSesionBean parametros = parametrosAplicacionServicio.consultaParametrosSessionLocal();
		
		String directorio = parametros.getRutaArchivos()+"ConciliacionTarjetas/";
		String archivoNombre = "";
		try{
		boolean exists = (new File(directorio)).exists();
		if (exists) {
			MultipartFile file = cargaConciliaBean.getFile();
			archivoNombre =directorio+System.getProperty("file.separator")+cargaConciliaBean.getFile().getOriginalFilename();
			if (file != null) {
				File filespring = new File(archivoNombre);
				FileUtils.writeByteArrayToFile(filespring, file.getBytes());  
			}
		}else {
			File aDir = new File(directorio);
			aDir.mkdir();
			MultipartFile file = cargaConciliaBean.getFile();
			//archivoNombre =directorio+tarDebArchAclaBean.getNumero()+System.getProperty("file.separator")+tarDebArchAclaBean.getNumero();
			archivoNombre =directorio+System.getProperty("file.separator")+cargaConciliaBean.getFile().getOriginalFilename();
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
		mensaje.setNombreControl(directorio+cargaConciliaBean.getFile().getOriginalFilename());
		ModelAndView modelAndView = new ModelAndView("resultadoTransaccionArchivoConciliaVista");
		modelAndView.addObject("mensaje", mensaje);

		return modelAndView;
	}
	
	public TarDebConciliaPosServicio getTarDebConciliaPosServicio() {
		return tarDebConciliaPosServicio;
	}

	public void setTarDebConciliaPosServicio(
			TarDebConciliaPosServicio tarDebConciliaPosServicio) {
		this.tarDebConciliaPosServicio = tarDebConciliaPosServicio;
	}

	public ParametrosAplicacionServicio getParametrosAplicacionServicio() {
		return parametrosAplicacionServicio;
	}

	public void setParametrosAplicacionServicio(
			ParametrosAplicacionServicio parametrosAplicacionServicio) {
		this.parametrosAplicacionServicio = parametrosAplicacionServicio;
	}


}
