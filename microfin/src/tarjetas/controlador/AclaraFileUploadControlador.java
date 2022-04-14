package tarjetas.controlador;

import general.bean.MensajeTransaccionBean;

import java.io.File;
import java.io.FileOutputStream;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.FileUtils;
import org.apache.log4j.Logger;
import org.springframework.validation.BindException;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;
import tarjetas.bean.TarDebArchAclaBean;
import tarjetas.bean.TarDebParamBean;
import tarjetas.servicio.TarDebArchAclaServicio;
import tarjetas.servicio.TarDebParamServicio;

public class AclaraFileUploadControlador extends SimpleFormController{
	TarDebArchAclaServicio tarDebArchAclaServicio= null;
	TarDebParamServicio tarDebParamServicio=null;
	protected final Logger loggerSAFI = Logger.getLogger("SAFI");
	
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception{
		TarDebArchAclaBean tarDebArchAclaBean = (TarDebArchAclaBean) command;
		tarDebArchAclaServicio.getTarDebArchAclaDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		int tipoTransaccion = (request.getParameter("tipoTransaccion") != null)?
				Integer.parseInt(request.getParameter("tipoTransaccion")):
					0;		
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		TarDebParamBean tardebParam = new TarDebParamBean();
		int numConsulta = 2;
		tardebParam = tarDebParamServicio.consulta(numConsulta, tardebParam);
		String directorio = tardebParam.getRutaAclaracion();
		String archivoNombre ="";
		

		boolean exists = (new File(directorio)).exists();
		if (exists) {
			MultipartFile file = tarDebArchAclaBean.getFile();
			archivoNombre =directorio+tarDebArchAclaBean.getReporteID()+System.getProperty("file.separator")+tarDebArchAclaBean.getFile().getOriginalFilename();
			if (file != null) {
				File filespring = new File(archivoNombre);  
				FileUtils.writeByteArrayToFile(filespring, file.getBytes());  
			}
		}else {
			File aDir = new File(directorio);
			aDir.mkdir();
			MultipartFile file = tarDebArchAclaBean.getFile();
			//archivoNombre =directorio+tarDebArchAclaBean.getNumero()+System.getProperty("file.separator")+tarDebArchAclaBean.getNumero();
			archivoNombre =directorio+tarDebArchAclaBean.getReporteID()+System.getProperty("file.separator")+tarDebArchAclaBean.getFile().getOriginalFilename();
			if (file != null) {
				File filespring = new File(archivoNombre);
				FileUtils.writeByteArrayToFile(filespring, file.getBytes());				
			}
		}
		mensaje = new MensajeTransaccionBean();
	
		mensaje.setNumero(0);
		mensaje.setDescripcion("Archivo Cargado Exitósamente ");
		mensaje.setNombreControl(tarDebArchAclaBean.getConsecutivo()+"|"+tarDebArchAclaBean.getFolioID()+"|"+directorio+"|"+tarDebArchAclaBean.getTipoArchivo()+"|"+tarDebArchAclaBean.getFile().getOriginalFilename());
	
		
		ModelAndView modelAndView = new ModelAndView("resultadoTransaccionArchivoAclaraVista");
		modelAndView.addObject("mensaje", mensaje);

		return modelAndView;
		
		//return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}
	public TarDebArchAclaServicio getTarDebArchAclaServicio() {
		return tarDebArchAclaServicio;
	}

	public void setTarDebArchAclaServicio(
			TarDebArchAclaServicio tarDebArchAclaServicio) {
		this.tarDebArchAclaServicio = tarDebArchAclaServicio;
	}
	
	public TarDebParamServicio getTarDebParamServicio() {
		return tarDebParamServicio;
	}

	public void setTarDebParamServicio(TarDebParamServicio tarDebParamServicio) {
		this.tarDebParamServicio = tarDebParamServicio;
	}

}

