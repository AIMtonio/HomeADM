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

import tarjetas.bean.TarDebConciliaATMBean;
import tarjetas.servicio.TarDebConciliaATMServicio;

public class CargaConciATMSubArchControlador extends SimpleFormController{

	TarDebConciliaATMServicio tarDebConciliaATMServicio = null;
	ParametrosAplicacionServicio	parametrosAplicacionServicio	= null;
	
	public CargaConciATMSubArchControlador(){
		setCommandClass(TarDebConciliaATMBean.class);
 		setCommandName("cargaConciATM");
	}

	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws ServletException, IOException  {
		
		TarDebConciliaATMBean cargaConciliaATMBean = (TarDebConciliaATMBean) command;
		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
				Integer.parseInt(request.getParameter("tipoTransaccion")):
			0;
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		ParametrosSesionBean parametros = parametrosAplicacionServicio.consultaParametrosSessionLocal();
		
		String directorio = parametros.getRutaArchivos()+"ConciliacionTarjetas/";
		String archivoNombre = "";
		
		archivoNombre =directorio+System.getProperty("file.separator")+cargaConciliaATMBean.getFile().getOriginalFilename();
		mensaje = new MensajeTransaccionBean();
		String tipoArchivo = cargaConciliaATMBean.getFile().getOriginalFilename().substring(0,2);
		try{
			boolean exists = (new File(archivoNombre)).exists();
			if(tipoArchivo.equals("S7")){
				mensaje.setNumero(44);
				mensaje.setDescripcion("Formato de Archivo Incorrecto");
				mensaje.setNombreControl("");			
			}else{
				exists = (new File(directorio)).exists();
				if (exists) {			
					MultipartFile file = cargaConciliaATMBean.getFile();			
					if (file != null) {
						File filespring = new File(archivoNombre);
						FileUtils.writeByteArrayToFile(filespring, file.getBytes());  
					}
				}else {
					File aDir = new File(directorio);
					aDir.mkdir();
					MultipartFile file = cargaConciliaATMBean.getFile();
					archivoNombre =directorio+System.getProperty("file.separator")+cargaConciliaATMBean.getFile().getOriginalFilename();
					if (file != null) {
						File filespring = new File(archivoNombre);
						FileUtils.writeByteArrayToFile(filespring, file.getBytes());				
					}
				}
				
				mensaje.setNumero(0);
				mensaje.setDescripcion("Archivo Cargado Exitósamente ");
				mensaje.setNombreControl(directorio+cargaConciliaATMBean.getFile().getOriginalFilename());
			}
			
				
		}catch(Exception e){
			e.printStackTrace();
			mensaje.setNumero(999);
			mensaje.setDescripcion("No se pudo cargar el Archivo ");
			mensaje.setNombreControl("");
		}
		
		ModelAndView modelAndView = new ModelAndView("resultadoTransaccionArchivoConciliaVista");
		modelAndView.addObject("mensaje", mensaje);

		return modelAndView;
	}
	
	public TarDebConciliaATMServicio getTarDebConciliaATMServicio() {
		return tarDebConciliaATMServicio;
	}

	public void setTarDebConciliaATMServicio(
			TarDebConciliaATMServicio tarDebConciliaATMServicio) {
		this.tarDebConciliaATMServicio = tarDebConciliaATMServicio;
	}

	public ParametrosAplicacionServicio getParametrosAplicacionServicio() {
		return parametrosAplicacionServicio;
	}

	public void setParametrosAplicacionServicio(
			ParametrosAplicacionServicio parametrosAplicacionServicio) {
		this.parametrosAplicacionServicio = parametrosAplicacionServicio;
	}
	
	
}
