package fondeador.controlador;

import general.bean.MensajeTransaccionArchivoBean;
import general.bean.MensajeTransaccionBean;
import herramientas.Constantes;
import java.io.File;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.springframework.validation.BindException;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;
import org.apache.commons.io.FileUtils;
import soporte.bean.ParamGeneralesBean;
import soporte.servicio.ParamGeneralesServicio;
import credito.bean.CarCambioFondeoBitBean;
import credito.servicio.CarCambioFondeoBitServicio;

public class CambioFuenteFondeoArchivoControlador extends SimpleFormController{
	ParamGeneralesServicio paramGeneralesServicio=null;
	CarCambioFondeoBitServicio carCambioFondeoBitServicio = null;
	
	public CambioFuenteFondeoArchivoControlador() {
		setCommandClass(CarCambioFondeoBitBean.class);
		setCommandName("carCambioFondeoBitBean");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,	HttpServletResponse response, Object command, BindException errors) throws Exception {
		
		MensajeTransaccionBean mensajeTransaccionBean = new MensajeTransaccionBean();
		MensajeTransaccionArchivoBean mensaje = new MensajeTransaccionArchivoBean();
		
		CarCambioFondeoBitBean carCambioFondeoBitBean = (CarCambioFondeoBitBean) command;

		String control = request.getParameter("control");
		String fechaHoraCarga = request.getParameter("fechaHoraCarga");
		
		boolean creado = false;
		
		//Validamos el archivo
		MultipartFile archivo = carCambioFondeoBitBean.getFile();
		if (archivo == null) {
			mensaje.setNumero(1);
			mensaje.setDescripcion("Especifique el archivo");
			mensaje.setRecursoOrigen(Constantes.STRING_VACIO);
			return new ModelAndView(getSuccessView(), "mensaje", mensaje);
		}
		
		String nombreArchivo = archivo.getOriginalFilename();
		String extension = nombreArchivo.substring(nombreArchivo.lastIndexOf("."));
			   nombreArchivo = nombreArchivo.substring(0, nombreArchivo.lastIndexOf("."));
		
		carCambioFondeoBitBean.setNombreArchivo(nombreArchivo + extension);
		
		//consultamos la Ruta de la carpeta donde se guardara el archivo
		int consultaRutaArchivos = 42;
		ParamGeneralesBean paramGeneralesBeanEntrada = new ParamGeneralesBean();
		ParamGeneralesBean paramGeneralesBeanRespuesta = paramGeneralesServicio.consulta(consultaRutaArchivos, paramGeneralesBeanEntrada);
		
		if (paramGeneralesBeanRespuesta == null) {
			mensaje.setNumero(2);
			mensaje.setDescripcion("Configure la ruta de Archivos para el modulo de Fondeo de Crédito.");
			mensaje.setRecursoOrigen(Constantes.STRING_VACIO);
			return new ModelAndView(getSuccessView(), "mensaje", mensaje);
		}	   
			   
		String directorio = paramGeneralesBeanRespuesta.getValorParametro();
		
		File directorioArchivosETL = new File(directorio);
		
		if (!directorioArchivosETL.exists()) {
			directorioArchivosETL.mkdirs();
			mensaje.setNumero(3);
			mensaje.setDescripcion("No se encontró la ruta para los Archivos de Fondeo de Crédito.");
			mensaje.setRecursoOrigen(Constantes.STRING_VACIO);
		}   
			   
		String directorioFondeo = directorio + "Archivo" + System.getProperty("file.separator") + "FondeoCredito" + System.getProperty("file.separator");	   
		directorioArchivosETL = new File(directorioFondeo);	   
		
		if (!directorioArchivosETL.exists()) {
			creado = directorioArchivosETL.mkdirs();
			if(!creado) {
				mensaje.setNumero(4);
				mensaje.setDescripcion("Error al intentar crear el Directorio para los Archivos de Fondeo de Crédito.");
				mensaje.setRecursoOrigen(Constantes.STRING_VACIO);
				return new ModelAndView(getSuccessView(), "mensaje", mensaje);
			}
		}
		
		if (!directorioArchivosETL.isDirectory() || !directorioArchivosETL.exists()) {
			mensaje.setNumero(5);
			mensaje.setDescripcion("Configure el Directorio para los Archivos de Fondeo de Crédito.");
			mensaje.setRecursoOrigen(Constantes.STRING_VACIO);
			return new ModelAndView(getSuccessView(), "mensaje", mensaje);
		}
		
		//Copiamos el archivo al directorio configurado
		nombreArchivo = nombreArchivo.replace(" ", "_") + "_" + fechaHoraCarga + extension;
		String rutaArchivoFinal = directorioFondeo  + nombreArchivo;
		File archivoFinal = new File(rutaArchivoFinal);
		FileUtils.writeByteArrayToFile(archivoFinal, archivo.getBytes());
			   
		// Se realiza la actualizacion del Estatus del reporte
		int tipoTransaccion = CarCambioFondeoBitServicio.Enum_Tra_CarCambioFondeo.cargaArchivoFondeo;
		int tipoActualizacion = 0;
		
		carCambioFondeoBitBean.setUrlArchivo(rutaArchivoFinal);
		
		mensajeTransaccionBean = carCambioFondeoBitServicio.grabaTransaccion(tipoTransaccion, tipoActualizacion, carCambioFondeoBitBean);
		
		if(mensajeTransaccionBean.getNumero() != Constantes.ENTERO_CERO) {
			mensaje.setNumero(mensajeTransaccionBean.getNumero());
			mensaje.setDescripcion(mensajeTransaccionBean.getDescripcion());
			mensaje.setRecursoOrigen(Constantes.STRING_VACIO);
			return new ModelAndView(getSuccessView(), "mensaje", mensaje);
		}
		
		// Finaliza la seccion de actualizacion del estatu cuando se procesa el archivo de respuesta
		mensaje.setNombreControl(carCambioFondeoBitBean.getNumeroTransacion());
		mensaje.setNumero(mensajeTransaccionBean.getNumero());
		mensaje.setDescripcion(mensajeTransaccionBean.getDescripcion());
		mensaje.setRecursoOrigen(carCambioFondeoBitBean.getNombreArchivo());
		
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public ParamGeneralesServicio getParamGeneralesServicio() {
		return paramGeneralesServicio;
	}

	public void setParamGeneralesServicio(
			ParamGeneralesServicio paramGeneralesServicio) {
		this.paramGeneralesServicio = paramGeneralesServicio;
	}

	public CarCambioFondeoBitServicio getCarCambioFondeoBitServicio() {
		return carCambioFondeoBitServicio;
	}

	public void setCarCambioFondeoBitServicio(
			CarCambioFondeoBitServicio carCambioFondeoBitServicio) {
		this.carCambioFondeoBitServicio = carCambioFondeoBitServicio;
	}	
	
}
