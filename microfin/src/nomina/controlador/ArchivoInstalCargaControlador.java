package nomina.controlador;


import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import nomina.bean.ArchivoInstalBean;
import nomina.bean.ResultadoArchivoInstalacionBean;
import nomina.servicio.ArchivoInstalServicio;

import org.apache.commons.io.FileUtils;
import org.springframework.validation.BindException;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import general.bean.ParametrosSesionBean;
import general.servicio.ParametrosAplicacionServicio;


public class ArchivoInstalCargaControlador extends SimpleFormController {

	ArchivoInstalServicio archivoInstalServicio;
	ParametrosAplicacionServicio parametrosAplicacionServicio = null;
	
	public ArchivoInstalCargaControlador() {
		setCommandClass(ArchivoInstalBean.class);
		setCommandName("ArchivoInstalBean");
	}
	

	protected ModelAndView onSubmit(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws ServletException, IOException {
		archivoInstalServicio.getArchivoInstalDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		ArchivoInstalBean archivo = (ArchivoInstalBean) command;
		ResultadoArchivoInstalacionBean cargaArchivo = new ResultadoArchivoInstalacionBean();
		ModelAndView modelAndView = null;

		try {
			ParametrosSesionBean parametros = parametrosAplicacionServicio.consultaParametrosSessionLocal();
			String rutaDestino = parametros.getRutaArchivos() + "Nomina/";
			String nombreArchivo = archivo.getFile().getOriginalFilename();
			String rutaFinal = rutaDestino + nombreArchivo;
			String extension = "";

			int i = nombreArchivo.lastIndexOf('.');
			if (i > 0) {
				extension = nombreArchivo.substring(i + 1);
			}
			if (!extension.equals("xls")) {
				cargaArchivo.setDescripcion("Formato de Archivo no compatible. Solo archivos Excel formato xls.");
				modelAndView = new ModelAndView("resultadoTransaccionCargaArchivoVista");
				modelAndView.addObject("mensaje", cargaArchivo);
				return modelAndView;
			}

			String directorio;
			directorio = parametros.getRutaArchivos() + "Nomina/ArchivoInstalacion";
			

			boolean exists = (new File(directorio)).exists();
			if (exists) {
				MultipartFile file = archivo.getFile();
				nombreArchivo = directorio + "/" + parametros.getNombreUsuario() + "_" +  archivo.getFolioID() + ".xls";
				rutaFinal = nombreArchivo;
				if (file != null) {
					File filespring = new File(nombreArchivo);
					FileUtils.writeByteArrayToFile(filespring, file.getBytes());
				}
			} else {
				File aDir = new File(directorio);
				aDir.mkdir();
				MultipartFile file = archivo.getFile();
				nombreArchivo = directorio + "/" + parametros.getNombreUsuario() + "_" +  archivo.getFolioID() + ".xls";
				rutaFinal = nombreArchivo;
				if (file != null) {
					File filespring = new File(nombreArchivo);
					FileUtils.writeByteArrayToFile(filespring, file.getBytes());
				}
			}
			
			cargaArchivo.setNumero(000);
			cargaArchivo.setDescripcion("Carga del archivo Éxitosa");

		} catch (Exception e) {
			e.printStackTrace();
			cargaArchivo.setDescripcion(e.getMessage());
		}

		return new ModelAndView(getSuccessView(), "mensaje", cargaArchivo);
	}


	public ArchivoInstalServicio getArchivoInstalServicio() {
		return archivoInstalServicio;
	}


	public void setArchivoInstalServicio(ArchivoInstalServicio archivoInstalServicio) {
		this.archivoInstalServicio = archivoInstalServicio;
	}


	public ParametrosAplicacionServicio getParametrosAplicacionServicio() {
		return parametrosAplicacionServicio;
	}


	public void setParametrosAplicacionServicio(
			ParametrosAplicacionServicio parametrosAplicacionServicio) {
		this.parametrosAplicacionServicio = parametrosAplicacionServicio;
	}

	
	
}

