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

import tesoreria.bean.DepositosRefeBean;
import tesoreria.bean.ResultadoCargaArchivosTesoreriaBean;
import tesoreria.servicio.DepositosRefeServicio;

public class DepRefeCargaArrendaControlador extends  SimpleFormController {	
	
	DepositosRefeServicio depositosRefeServicio;
	ParametrosAplicacionServicio	parametrosAplicacionServicio	= null;
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws ServletException, IOException  {
		depositosRefeServicio.getDepositosRefeDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		DepositosRefeBean depReferencia = (DepositosRefeBean) command;
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
		ResultadoCargaArchivosTesoreriaBean cargaArchivo =null;
		cargaArchivo = depositosRefeServicio.cargaArchivoDepRefere(rutaFinal, depReferencia,bancoEstandar);
	
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

	public void setDepositosRefeServicio(DepositosRefeServicio depositosRefeServicio) {
		this.depositosRefeServicio = depositosRefeServicio;
	}

	public ParametrosAplicacionServicio getParametrosAplicacionServicio() {
		return parametrosAplicacionServicio;
	}

	public void setParametrosAplicacionServicio(
			ParametrosAplicacionServicio parametrosAplicacionServicio) {
		this.parametrosAplicacionServicio = parametrosAplicacionServicio;
	}
	
}
