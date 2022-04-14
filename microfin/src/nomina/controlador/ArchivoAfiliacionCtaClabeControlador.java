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

import nomina.bean.ProcAfiliaBajaCtaClabeBean;
import nomina.bean.ResultadoCargaArchivosAfiliacionBean;
import nomina.servicio.ProcAfiliaBajaCtaClabeServicio;

public class ArchivoAfiliacionCtaClabeControlador extends SimpleFormController {	
	
	ProcAfiliaBajaCtaClabeServicio procAfiliaBajaCtaClabeServicio;
	
	
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws ServletException, IOException  {
		
		ProcAfiliaBajaCtaClabeBean procAfiliaBajaCtaClabeBean = (ProcAfiliaBajaCtaClabeBean) command;
		FileOutputStream outputStream = null;
		
		procAfiliaBajaCtaClabeServicio.getProcAfiliaBajaCtaClabeDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		

		String rutaDestino = PropiedadesSAFIBean.propiedadesSAFI.getProperty("RutaTomcat")+"/Archivos/Nomina/Afiliacion/";
		String nombreArchivo = procAfiliaBajaCtaClabeBean.getFile().getOriginalFilename();
		Format formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		String hora = formatter.format(new Date());
		String rutaFinal = rutaDestino + hora+"_"+nombreArchivo;
		
		File fichero = new File(rutaDestino);
		if (!fichero.exists()){
			File aDir = new File(rutaDestino);
			aDir.mkdirs();
		}
		
		outputStream = new FileOutputStream(new File(rutaFinal));
		outputStream.write(procAfiliaBajaCtaClabeBean.getFile().getFileItem().get());	
		outputStream.close();
		ResultadoCargaArchivosAfiliacionBean cargaArchivo = null;
		cargaArchivo = procAfiliaBajaCtaClabeServicio.cargaArchivoAfiliacion(rutaFinal, procAfiliaBajaCtaClabeBean);
	
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean(); 
		mensaje.setNumero(cargaArchivo.getNumero());
		mensaje.setConsecutivoInt("1");
		mensaje.setConsecutivoString("1");
		mensaje.setDescripcion(cargaArchivo.getDescripcion());			
		mensaje.setNombreControl("0");
		
		ModelAndView modelAndView = new ModelAndView("nomina/resultadoTransaccionArchivoAfiliaVista");
		modelAndView.addObject("mensaje", mensaje);
		
		
		return modelAndView;
	}

	// =============== GETTER & SETTER ===================
	
	public ProcAfiliaBajaCtaClabeServicio getProcAfiliaBajaCtaClabeServicio() {
		return procAfiliaBajaCtaClabeServicio;
	}
	public void setProcAfiliaBajaCtaClabeServicio(ProcAfiliaBajaCtaClabeServicio procAfiliaBajaCtaClabeServicio) {
		this.procAfiliaBajaCtaClabeServicio = procAfiliaBajaCtaClabeServicio;
	}

}
