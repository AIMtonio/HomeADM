package tesoreria.controlador;

import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;
import general.servicio.ParametrosAplicacionServicio;
import herramientas.Utileria;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import soporte.servicio.CorreoServicio;
import tesoreria.bean.DepositosRefeBean;
import tesoreria.bean.ResultadoCargaArchivosTesoreriaBean;
import tesoreria.servicio.DepositosRefeServicio;

public class DepositosRefeControlador extends  SimpleFormController {	

	DepositosRefeServicio depositosRefeServicio;
	ParametrosAplicacionServicio parametrosAplicacionServicio = null;
	CorreoServicio correoServicio = null;

	public static interface  Enum_Tra_deposito{
		int cargaArchivo = 1;
		int guardaGrid = 3;
	}

	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws ServletException, IOException  {

		depositosRefeServicio.getDepositosRefeDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());

		int tipoTransaccion = Utileria.convierteEntero(request.getParameter("tipoTransaccion"));
		String transaccionAnt = request.getParameter("numTranAnt");
		String bancoEstandar = request.getParameter("bancoEstandar");

		DepositosRefeBean depReferencia = (DepositosRefeBean) command;
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		ResultadoCargaArchivosTesoreriaBean cargaArchivo = new ResultadoCargaArchivosTesoreriaBean();
		ModelAndView modelAndView = null;

		switch(tipoTransaccion){
		case Enum_Tra_deposito.cargaArchivo:
			FileOutputStream outputStream = null;
			ParametrosSesionBean parametros = parametrosAplicacionServicio.consultaParametrosSessionLocal();
			String rutaDestino = parametros.getRutaArchivos()+"Tesoreria/";
			String nombreArchivo = depReferencia.getFile().getOriginalFilename();
			String rutaFinal = rutaDestino + nombreArchivo;

			depReferencia.setNumTranAnt(transaccionAnt);

			File fichero = new File(rutaDestino);

			if (!fichero.exists()){
				File aDir = new File(rutaDestino);
				aDir.mkdirs();
			}

			outputStream = new FileOutputStream(new File(rutaFinal));
			outputStream.write(depReferencia.getFile().getFileItem().get());	
			outputStream.close();

			cargaArchivo = depositosRefeServicio.cargaArchivoDepRefere(rutaFinal, depReferencia, bancoEstandar);
			cargaArchivo.setDescripcion(cargaArchivo.getDescripcion());			
			modelAndView = new ModelAndView("resultadoTransaccionCargaArchivoVista");
			modelAndView.addObject("mensaje", cargaArchivo);
			break;

		case Enum_Tra_deposito.guardaGrid:
			mensaje = depositosRefeServicio.grabaTransaccion(tipoTransaccion, depReferencia, bancoEstandar);
			modelAndView = new ModelAndView("resultadoTransaccionVista");
			modelAndView.addObject("mensaje", mensaje);

	 		/** Proceso de envío de correo para operaciones PLD.*/
			try {
				correoServicio.EjecutaEnvioCorreo();
			} catch (Exception e) {
				e.printStackTrace();
			}
			break;

		}
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

	public CorreoServicio getCorreoServicio() {
		return correoServicio;
	}

	public void setCorreoServicio(CorreoServicio correoServicio) {
		this.correoServicio = correoServicio;
	}
	
}