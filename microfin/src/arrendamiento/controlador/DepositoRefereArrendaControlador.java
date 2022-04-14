package arrendamiento.controlador;

import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;
import general.servicio.ParametrosAplicacionServicio;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import arrendamiento.bean.DepositoRefereArrendaBean;
import arrendamiento.bean.ResultadoCargaArchivosArrendaBean;
import arrendamiento.servicio.DepositoRefereArrendaServicio;

public class DepositoRefereArrendaControlador extends  SimpleFormController {	
	
	DepositoRefereArrendaServicio depositoRefereArrendaServicio;
	ParametrosAplicacionServicio	parametrosAplicacionServicio	= null;
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws ServletException, IOException  {
		depositoRefereArrendaServicio.getDepositoRefereArrendaDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		DepositoRefereArrendaBean depReferencia = (DepositoRefereArrendaBean) command;
		FileOutputStream outputStream = null;
		ParametrosSesionBean parametros = parametrosAplicacionServicio.consultaParametrosSessionLocal();
		String rutaDestino = parametros.getRutaArchivos()+"Tesoreria/";
		String nombreArchivo = depReferencia.getFile().getOriginalFilename();
		String rutaFinal = rutaDestino + nombreArchivo;
		String bancoEstandar = request.getParameter("bancoEstandar");
		File fichero = new File(rutaDestino);
		if (!fichero.exists()){
			File aDir = new File(rutaDestino);
			aDir.mkdirs();
		}
		
		outputStream = new FileOutputStream(new File(rutaFinal));
		outputStream.write(depReferencia.getFile().getFileItem().get());	
		outputStream.close();
		ResultadoCargaArchivosArrendaBean cargaArchivo =null;
		cargaArchivo = depositoRefereArrendaServicio.cargaArchivoDepRefere(rutaFinal, depReferencia);
	
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean(); 
		mensaje.setNumero(cargaArchivo.getNumero());
		mensaje.setConsecutivoInt("1");
		mensaje.setConsecutivoString("1");
		mensaje.setDescripcion(cargaArchivo.getDescripcion());			
		mensaje.setNombreControl("institucionID");
		
		ModelAndView modelAndView = new ModelAndView("resultadoTransaccionArchivoVista");
		modelAndView.addObject("mensaje", mensaje);
		
		return modelAndView;
	}


	public DepositoRefereArrendaServicio getDepositoRefereArrendaServicio() {
		return depositoRefereArrendaServicio;
	}


	public void setDepositoRefereArrendaServicio(
			DepositoRefereArrendaServicio depositoRefereArrendaServicio) {
		this.depositoRefereArrendaServicio = depositoRefereArrendaServicio;
	}


	public ParametrosAplicacionServicio getParametrosAplicacionServicio() {
		return parametrosAplicacionServicio;
	}
	public void setParametrosAplicacionServicio(
			ParametrosAplicacionServicio parametrosAplicacionServicio) {
		this.parametrosAplicacionServicio = parametrosAplicacionServicio;
	}

	
}
