package soporte.controlador;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.FileUtils;
import org.springframework.validation.BindException;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import general.bean.MensajeTransaccionArchivoBean;
import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;
import general.servicio.ParametrosAplicacionServicio;
import herramientas.Constantes;
import herramientas.Utileria;
import soporte.bean.CargaArchPlanosBean;
import soporte.servicio.ArchUploadGenServicio;
import soporte.servicio.GeneracionArchPlanosServicio;
import tesoreria.bean.ResOrdPagoSantaBean;
import tesoreria.servicio.ResOrdPagoSantaServicio;
/**
 * Controlador para la pantalla de subida de archivos.
 * @author jduque
 *
 */
public class CargaArchPlanosControlador extends SimpleFormController {
	
	GeneracionArchPlanosServicio generacionArchPlanosServicio =null;
	ParametrosAplicacionServicio parametrosAplicacionServicio = null;
	ResOrdPagoSantaServicio resOrdPagoSantaServicio = null;
	
	public CargaArchPlanosControlador() {
		setCommandClass(CargaArchPlanosBean.class);
		setCommandName("cargaArchPlanosBean");
	}

	public static interface Enum_Tra_Upload {
		int	cargaArchivoCtasActivas= 1; 		// Cuentas activas santander
		int	cargaArchivoCtasPendientes= 2; 		// Cuentas activas santander
		int	cargaArchivoTransferSantan=3;		// Carga de archivo de transferencia
		int	cargaArchivoOrdenPago=4;			// Carga archivo Orden de pago
		int cargaArchivoDispMasiva = 5;			// Carga de archivo de dispersionMasiva
	}

	protected ModelAndView onSubmit(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws ServletException, IOException {
		generacionArchPlanosServicio.getCuentasSantanderDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		int tipoTransaccion = 0;
		int tipoArchivo = Utileria.convierteEntero(request.getParameter("tipo"));
		CargaArchPlanosBean cargaArcPlano = (CargaArchPlanosBean) command;
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		MensajeTransaccionArchivoBean cargaArchivo = new MensajeTransaccionArchivoBean();
		ResOrdPagoSantaBean resNombreArchivo = new ResOrdPagoSantaBean();
		
		ModelAndView modelAndView = null;
		ParametrosSesionBean parametros = parametrosAplicacionServicio.consultaParametrosSessionLocal();
		String rutaDestino ="";
		String controlID = "";
		
		switch(tipoArchivo){
			case  Enum_Tra_Upload.cargaArchivoCtasPendientes:
				rutaDestino = parametros.getRutaArchivos() + "Dispersiones/CtasPendientes/";
				controlID = "rutaArchCtasPendientes";
				tipoTransaccion=1;
				break;
			case Enum_Tra_Upload.cargaArchivoCtasActivas:
				rutaDestino = parametros.getRutaArchivos() + "Dispersiones/CtasActivas/";
				controlID = "rutaArchCtasActivas";
				tipoTransaccion=1;
				break;
			case Enum_Tra_Upload.cargaArchivoTransferSantan:
				rutaDestino = parametros.getRutaArchivos() + "Dispersiones/TransferenciaSanta/";
				controlID = "rutaArchivo";
				tipoTransaccion=1;
				break;
			case Enum_Tra_Upload.cargaArchivoOrdenPago:
				rutaDestino = parametros.getRutaArchivos() + "Dispersiones/OrdenPagos/";
				controlID = "rutaArchOrdPago";
				tipoTransaccion=1;
				break;
			case Enum_Tra_Upload.cargaArchivoDispMasiva:
				rutaDestino = parametros.getRutaArchivos() + "Dispersiones/cargaMasiva/";
				controlID = "rutaArchivo";
				cargaArchivo =  cargaArchivoDispMasiva(cargaArcPlano,rutaDestino,controlID);
				modelAndView = new ModelAndView("resultadoTransaccionCargaArchivoVista");
				modelAndView.addObject("mensaje", cargaArchivo);
				
				
		}

		switch (tipoTransaccion) {
		case Enum_Tra_Upload.cargaArchivoCtasActivas :
			FileOutputStream outputStream = null;
			String nombreArchivo = cargaArcPlano.getFile().getOriginalFilename();
			String rutaFinal = rutaDestino + nombreArchivo;
			String tDoc = "";
			String extension = "";
	
			int i = nombreArchivo.lastIndexOf('.');
			String NombreArchivo ="";
			
			if (i > 0) {
				extension = nombreArchivo.substring(i + 1);
			}

			String directorio = "";
			directorio = rutaDestino;
			Date f = new Date();
			SimpleDateFormat formatoFecha = new SimpleDateFormat("dd-MM-yyyy-hh:mm:ss");
			String fecha = formatoFecha.format(f);
			try {
				boolean exists = (new File(directorio)).exists();
				boolean existsArch = (new File(rutaFinal)).exists();
				
				MultipartFile file = cargaArcPlano.getFile();
				NombreArchivo = file.getOriginalFilename().replace(" ", "_");
				nombreArchivo = directorio +NombreArchivo;
				resNombreArchivo.setArchivo(NombreArchivo);
				
				resNombreArchivo = resOrdPagoSantaServicio.consultaArchvio(resNombreArchivo, tipoArchivo);
				
				if(resNombreArchivo.getArchivo() !=null){
					if(!resNombreArchivo.getArchivo().equals("")){
						cargaArchivo.setNumero(999);
						cargaArchivo.setDescripcion("Error: El archivo <b>"+cargaArcPlano.getFile().getOriginalFilename()+"</b> ya fue procesado.");
						cargaArchivo.setNombreControl(controlID);
						cargaArchivo.setConsecutivoString("");
						throw new Exception(cargaArchivo.getDescripcion());
					}
					
				}
				
				//VALIDACION SI EXISTE LA RUTA DESTINO
				if (exists) {
					//VALIDACION QUE NO EXISTA EL MISMO ARCHIVO
					if (file != null && !(existsArch)) {
						File filespring = new File(nombreArchivo);
						FileUtils.writeByteArrayToFile(filespring, file.getBytes());
					}					
				} else {
					File aDir = new File(directorio);
					aDir.mkdir();
					
					if (file != null) {
						File filespring = new File(nombreArchivo);
						FileUtils.writeByteArrayToFile(filespring, file.getBytes());
					}

				}
				
				rutaFinal = rutaFinal.replace(" ", "_");
				cargaArchivo.setDescripcion("Archivo cargado exitosamente.");
				cargaArchivo.setNumero(0);
				cargaArchivo.setNombreControl(controlID);
				cargaArchivo.setConsecutivoString(rutaFinal);
				
			} catch (Exception e) {
				e.printStackTrace();
				cargaArchivo.setNumero(999);
			}
			
			modelAndView = new ModelAndView("resultadoTransaccionCargaArchivoVista");
			modelAndView.addObject("mensaje", cargaArchivo);
			break;
		}
	
		return modelAndView;
	}
	
	
	
	
	public MensajeTransaccionArchivoBean cargaArchivoDispMasiva(CargaArchPlanosBean cargaArcPlano,String rutaDestino,String controlID){
		MensajeTransaccionArchivoBean cargaArchivo = new MensajeTransaccionArchivoBean();
		FileOutputStream outputStream = null;
		String nombreArchivo = cargaArcPlano.getFile().getOriginalFilename();
		String rutaFinal = rutaDestino + nombreArchivo;
		String tDoc = "";
		String extension = "";

		int i = nombreArchivo.lastIndexOf('.');
		String NombreArchivo ="";
		try {
			if (i > 0) {
				extension = nombreArchivo.substring(i + 1);
				System.out.println("Extencion: "+extension);
				if(!extension.equalsIgnoreCase("xls") && !extension.equalsIgnoreCase("xlsx")){
					cargaArchivo.setNumero(999);
					cargaArchivo.setDescripcion("Error: Solo se permite carga de archivos Excel");
					cargaArchivo.setNombreControl(controlID);
					cargaArchivo.setConsecutivoString("");
					throw new Exception(cargaArchivo.getDescripcion());
				}
			}
		
		String directorio = "";
		directorio = rutaDestino;
		Date f = new Date();
		SimpleDateFormat formatoFecha = new SimpleDateFormat("dd-MM-yyyy-hh:mm:ss");
		String fecha = formatoFecha.format(f);
		
			boolean exists = (new File(directorio)).exists();
			boolean existsArch = (new File(rutaFinal)).exists();
			
			MultipartFile file = cargaArcPlano.getFile();
			NombreArchivo = file.getOriginalFilename();
			nombreArchivo = directorio +NombreArchivo;
			rutaFinal = nombreArchivo;
			//VALIDACION SI EXISTE LA RUTA DESTINO
			if (exists) {
				//VALIDACION QUE NO EXISTA EL MISMO ARCHIVO
				if (file != null && !(existsArch)) {
					File filespring = new File(nombreArchivo);
					FileUtils.writeByteArrayToFile(filespring, file.getBytes());
				}
				else{
					cargaArchivo.setNumero(999);
					cargaArchivo.setDescripcion("Error: El archivo <b>"+cargaArcPlano.getFile().getOriginalFilename()+"</b> ya fue cargado.");
					cargaArchivo.setNombreControl(controlID);
					cargaArchivo.setConsecutivoString("");
					throw new Exception(cargaArchivo.getDescripcion());
				}
				
			} else {
				File aDir = new File(directorio);
				aDir.mkdir();
				
				if (file != null) {
					File filespring = new File(nombreArchivo);
					FileUtils.writeByteArrayToFile(filespring, file.getBytes());
				}

			}
			
			
			cargaArchivo.setDescripcion("Archivo cargado exitosamente.");
			cargaArchivo.setNumero(0);
			cargaArchivo.setNombreControl(controlID);
			cargaArchivo.setConsecutivoString(rutaFinal);
			 
			
		} catch (Exception e) {
			e.printStackTrace();
			cargaArchivo.setNumero(999);
		}
		return cargaArchivo;
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	public GeneracionArchPlanosServicio getGeneracionArchPlanosServicio() {
		return generacionArchPlanosServicio;
	}

	public void setGeneracionArchPlanosServicio(
			GeneracionArchPlanosServicio generacionArchPlanosServicio) {
		this.generacionArchPlanosServicio = generacionArchPlanosServicio;
	}

	public ParametrosAplicacionServicio getParametrosAplicacionServicio() {
		return parametrosAplicacionServicio;
	}

	public void setParametrosAplicacionServicio(
			ParametrosAplicacionServicio parametrosAplicacionServicio) {
		this.parametrosAplicacionServicio = parametrosAplicacionServicio;
	}

	public ResOrdPagoSantaServicio getResOrdPagoSantaServicio() {
		return resOrdPagoSantaServicio;
	}

	public void setResOrdPagoSantaServicio(
			ResOrdPagoSantaServicio resOrdPagoSantaServicio) {
		this.resOrdPagoSantaServicio = resOrdPagoSantaServicio;
	}
	
	
	

}
