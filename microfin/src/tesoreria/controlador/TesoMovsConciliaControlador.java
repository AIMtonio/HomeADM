package tesoreria.controlador;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;

import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;
import general.servicio.ParametrosAplicacionServicio;
import herramientas.Constantes;
import herramientas.Utileria;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import tesoreria.bean.ResultadoCargaArchivosTesoreriaBean;
import tesoreria.bean.TesoMovsArchConciliaBean;
import tesoreria.servicio.TesoMovsConciliaServicio;

public class TesoMovsConciliaControlador extends  SimpleFormController {	

	TesoMovsConciliaServicio tesoMovsConciliaServicio = null;
	ParametrosAplicacionServicio parametrosAplicacionServicio = null;
	String archivoNombre="";

	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws ServletException, IOException  {

		TesoMovsArchConciliaBean tesoMovsArch = (TesoMovsArchConciliaBean) command;
		ResultadoCargaArchivosTesoreriaBean mensajeCarga = new ResultadoCargaArchivosTesoreriaBean();

		FileOutputStream outputStream = null;

		ParametrosSesionBean parametros = parametrosAplicacionServicio.consultaParametrosSessionLocal();
		
		String rutaDestino = parametros.getRutaArchivos()+"Tesoreria/";
		String nombreArchivo = tesoMovsArch.getFile().getOriginalFilename();
		int institucionID = Utileria.convierteEntero(tesoMovsArch.getInstitucionID());
		String rutaFinal = "";
		String bancoEstandar = request.getParameter("bancoEstandar");
		
		File fichero = new File(rutaDestino);
		MensajeTransaccionBean mensaje = null; 

		if(creaDirectorioSiNoExis(fichero)!=null){
			mensajeCarga = creaArchivoConciliacion(  rutaDestino,  nombreArchivo);
			rutaFinal = mensajeCarga.getRuta();
			if(!rutaFinal.isEmpty() ||rutaFinal != Constantes.STRING_VACIO ){
				outputStream = new FileOutputStream(new File(rutaFinal));
				outputStream.write(tesoMovsArch.getFile().getFileItem().get());	
				outputStream.close();

				tesoMovsArch.setNumCtaInstit(request.getParameter("cuentaBancaria"));
				mensajeCarga = tesoMovsConciliaServicio.grabaTransaccion(institucionID, tesoMovsArch,rutaFinal,bancoEstandar);

				mensaje = new MensajeTransaccionBean(); 
				mensaje.setNumero(mensajeCarga.getNumero());
				mensaje.setConsecutivoInt(mensajeCarga.getConsecutivoInt());
				mensaje.setConsecutivoString(mensajeCarga.getConsecutivoString());
				mensaje.setDescripcion(mensajeCarga.getDescripcion());
				mensaje.setNombreControl(mensajeCarga.getNombreControl());
			}else{
				mensaje = new MensajeTransaccionBean(); 
				mensaje.setNumero(995);
				mensaje.setConsecutivoInt(mensajeCarga.getConsecutivoInt());
				mensaje.setConsecutivoString(mensajeCarga.getConsecutivoString());
				mensaje.setDescripcion(mensajeCarga.getDescripcion());
				mensaje.setNombreControl(mensajeCarga.getNombreControl());
			}
		}else{
			mensaje = new MensajeTransaccionBean(); 
			mensaje.setNumero(995);
			mensaje.setConsecutivoInt("0");
			mensaje.setConsecutivoString("0");
			mensaje.setDescripcion("Error al crear el directorio.");
			mensaje.setNombreControl("institucionID");
		}
		ModelAndView modelAndView = new ModelAndView("resultadoTransaccionArchivoVista");
		modelAndView.addObject("mensaje", mensaje);

		return modelAndView;
	}

	public File creaDirectorioSiNoExis(File directorioTeso){
		if(!directorioTeso.exists()){
			try{
				directorioTeso.mkdirs();
			}catch (Exception e){
				directorioTeso=null;
			}
		}
		return directorioTeso;

	}


	public ResultadoCargaArchivosTesoreriaBean creaArchivoConciliacion(String rutaDestino,String nombreArchivo){
		ResultadoCargaArchivosTesoreriaBean mensajeCarga = new ResultadoCargaArchivosTesoreriaBean();
		File fichero = null; 
		String rutaFinal="";
		mensajeCarga.setNombreControl("institucionID");
		try{
			String nombreOri=nombreArchivo;
			String tokens[] = nombreOri.split("[.]");
			String extension="."+tokens[1];

			if(extension.equals(".txt")){
			
				String extencion = ".txt";

				String NombreSinExt= nombreArchivo.substring(0,nombreArchivo.lastIndexOf(".txt"));//recupera nombre sin extencion

				rutaFinal =  rutaDestino+NombreSinExt+extencion;
				fichero = new File(rutaFinal);
				int i=1;
				while(fichero.exists()){
					rutaFinal =  rutaDestino+NombreSinExt+"("+Integer.toString(i)+")"+extencion;
					fichero = new File(rutaFinal);
					i++;
				}
				mensajeCarga.setNumero(0);
				mensajeCarga.setDescripcion("Archivo Creado");
				mensajeCarga.setRuta(rutaFinal);
			}else{
				if(extension.equals(".exp")){
	
					String extencion = ".exp";

					String NombreSinExt= nombreArchivo.substring(0,nombreArchivo.lastIndexOf(".exp"));//recupera nombre sin extencion

					rutaFinal =  rutaDestino+NombreSinExt+extencion;
					fichero = new File(rutaFinal);
					int i=1;
					while(fichero.exists()){
						rutaFinal =  rutaDestino+NombreSinExt+"("+Integer.toString(i)+")"+extencion;
						fichero = new File(rutaFinal);
						i++;
					}
					mensajeCarga.setNumero(0);
					mensajeCarga.setDescripcion("Archivo Creado");
					mensajeCarga.setRuta(rutaFinal);
				}else{
					if(extension.equals(".csv")){
						String extencion = ".csv";

						String NombreSinExt= nombreArchivo.substring(0,nombreArchivo.lastIndexOf(".csv"));//recupera nombre sin extencion
						rutaFinal =  rutaDestino+NombreSinExt+extencion;
						fichero = new File(rutaFinal);
						int i=1;
						while(fichero.exists()){
							rutaFinal =  rutaDestino+NombreSinExt+"("+Integer.toString(i)+")"+extencion;
							fichero = new File(rutaFinal);
							i++;
						}
						mensajeCarga.setNumero(0);
						mensajeCarga.setDescripcion("Archivo Creado");
						mensajeCarga.setRuta(rutaFinal);
					}else{
						mensajeCarga.setNumero(999);
						mensajeCarga.setConsecutivoInt("0");
						mensajeCarga.setConsecutivoString("0");
						mensajeCarga.setDescripcion("Asegure de seleccionar el archivo correcto ");
						mensajeCarga.setNombreControl("institucionID");
						mensajeCarga.setRuta(Constantes.STRING_VACIO);
						throw new Exception(mensajeCarga.getDescripcion());
					}
				}
			}
		}catch(Exception e){
			e.printStackTrace();
			if(mensajeCarga.getNumero()==0){
				mensajeCarga.setNumero(999);
				mensajeCarga.setDescripcion("Error al cargar el archivo.");
				mensajeCarga.setNombreControl("institucionID");
			}
			mensajeCarga.setRuta(Constantes.STRING_VACIO);
		}
		return mensajeCarga;
	}


	public void setTesoMovsConciliaServicio(TesoMovsConciliaServicio tesoMovsConciliaServicio) {
		this.tesoMovsConciliaServicio = tesoMovsConciliaServicio;
	}

	public ParametrosAplicacionServicio getParametrosAplicacionServicio() {
		return parametrosAplicacionServicio;
	}

	public void setParametrosAplicacionServicio(
			ParametrosAplicacionServicio parametrosAplicacionServicio) {
		this.parametrosAplicacionServicio = parametrosAplicacionServicio;
	}


}