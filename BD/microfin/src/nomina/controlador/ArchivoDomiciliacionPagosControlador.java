package nomina.controlador;
import general.bean.MensajeTransaccionBean;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.text.Format;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import soporte.PropiedadesSAFIBean;

import nomina.bean.ProcesaDomiciliacionPagosBean;
import nomina.bean.ResultadoCargaArchivosDomiciliaBean;
import nomina.servicio.ProcesaDomiciliacionPagosServicio;

public class ArchivoDomiciliacionPagosControlador extends SimpleFormController {	
	
	ProcesaDomiciliacionPagosServicio procesaDomiciliacionPagosServicio;
	
	
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws ServletException, IOException  {
		
		ProcesaDomiciliacionPagosBean procesaDomiciliacionPagosBean = (ProcesaDomiciliacionPagosBean) command;
		FileOutputStream outputStream = null;
		
		procesaDomiciliacionPagosServicio.getProcesaDomiciliacionPagosDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());

		String rutaDestino = PropiedadesSAFIBean.propiedadesSAFI.getProperty("RutaTomcat")+"/Archivos/Nomina/Domiciliacion/";
		String nombreArchivo = procesaDomiciliacionPagosBean.getFile().getOriginalFilename();
		
		request.getSession().setAttribute("archivoDomiciliacion", nombreArchivo);

		Format formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		String hora = formatter.format(new Date());
		String rutaFinal = rutaDestino + hora+"_"+nombreArchivo;
		
		File fichero = new File(rutaDestino);
		if (!fichero.exists()){
			File aDir = new File(rutaDestino);
			aDir.mkdirs();
		}
		
		outputStream = new FileOutputStream(new File(rutaFinal));
		outputStream.write(procesaDomiciliacionPagosBean.getFile().getFileItem().get());	
		outputStream.close();
		ResultadoCargaArchivosDomiciliaBean cargaArchivo = null;
		cargaArchivo = procesaDomiciliacionPagosServicio.cargaArchivoDomiciliacion(rutaFinal, procesaDomiciliacionPagosBean);
	
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean(); 
		mensaje.setNumero(cargaArchivo.getNumero());
		mensaje.setConsecutivoInt("1");
		mensaje.setConsecutivoString("1");
		mensaje.setDescripcion(cargaArchivo.getDescripcion());			
		mensaje.setNombreControl("0");
		
		ModelAndView modelAndView = new ModelAndView("nomina/resultadoTransaccionArchivoDomiciliaVista");
		modelAndView.addObject("mensaje", mensaje);
		
		
		return modelAndView;
	}

	// =============== GETTER & SETTER ===================

	public ProcesaDomiciliacionPagosServicio getProcesaDomiciliacionPagosServicio() {
		return procesaDomiciliacionPagosServicio;
	}


	public void setProcesaDomiciliacionPagosServicio(ProcesaDomiciliacionPagosServicio procesaDomiciliacionPagosServicio) {
		this.procesaDomiciliacionPagosServicio = procesaDomiciliacionPagosServicio;
	}

}