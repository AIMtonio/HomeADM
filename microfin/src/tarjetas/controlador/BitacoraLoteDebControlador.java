package tarjetas.controlador;

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

import tarjetas.bean.BitacoraLoteDebBean;
import tarjetas.servicio.BitacoraLoteDebServicio;
import tesoreria.bean.ResultadoCargaArchivosTesoreriaBean;

public class BitacoraLoteDebControlador extends SimpleFormController{
	BitacoraLoteDebServicio bitacoraLoteDebServicio = null;
	ParametrosAplicacionServicio	parametrosAplicacionServicio	= null;
	String nombreArchivo = "";
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws ServletException, IOException  {
		
		BitacoraLoteDebBean bitacoraLoteDebBean = (BitacoraLoteDebBean) command;
		ResultadoCargaArchivosTesoreriaBean mensajeCarga = new ResultadoCargaArchivosTesoreriaBean();
		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
				Integer.parseInt(request.getParameter("tipoTransaccion")):
			0;
		FileOutputStream outputStream = null;
		
		ParametrosSesionBean parametros = parametrosAplicacionServicio.consultaParametrosSessionLocal();
		
		String rutaDestino = parametros.getRutaArchivos()+"TarjetaDebito/";
		String nombreArchivo = bitacoraLoteDebBean.getFile().getOriginalFilename();;
		String rutaFinal = "";
		

		File fichero = new File(rutaDestino);
		MensajeTransaccionBean mensaje = null; 
		
		if(creaDirectorioSiNoExis(fichero)!=null){
			rutaFinal	=	creaArchivoConciliacion(  rutaDestino,  nombreArchivo);
		
			if(!rutaFinal.isEmpty()){
				outputStream = new FileOutputStream(new File(rutaFinal));
				outputStream.write(bitacoraLoteDebBean.getFile().getFileItem().get());	
				outputStream.close();
				

			

				mensajeCarga = bitacoraLoteDebServicio.grabaTransaccion(tipoTransaccion, bitacoraLoteDebBean,rutaFinal);

				mensaje = new MensajeTransaccionBean(); 
				mensaje.setNumero(mensajeCarga.getNumero());
				mensaje.setConsecutivoInt(mensajeCarga.getConsecutivoInt());
				mensaje.setConsecutivoString(mensajeCarga.getConsecutivoString());
				mensaje.setDescripcion(mensajeCarga.getDescripcion());
				mensaje.setNombreControl(mensajeCarga.getNombreControl());
			}
		}
		
		ModelAndView modelAndView = new ModelAndView("resultadoTransaccionArchivoMensajeVista");
		modelAndView.addObject("mensaje", mensaje);

		return modelAndView;
	
	}
	public File creaDirectorioSiNoExis(File directorioTeso){
		if(!directorioTeso.exists()){
			try{
				directorioTeso.mkdir();
			}catch (Exception e){
				directorioTeso=null;
			}
		}
		return directorioTeso;

	}
	public String creaArchivoConciliacion(String rutaDestino,String nombreArchivo){

		File fichero = null; // new File(rutaDestino);
		String rutaFinal="";
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
			}
			else{
		
			}
		}
		catch(Exception e){
			rutaFinal= "";
		}
		return rutaFinal;
	}
	public BitacoraLoteDebServicio getBitacoraLoteDebServicio() {
		return bitacoraLoteDebServicio;
	}
	public void setBitacoraLoteDebServicio(
			BitacoraLoteDebServicio bitacoraLoteDebServicio) {
		this.bitacoraLoteDebServicio = bitacoraLoteDebServicio;
	}
	public String getNombreArchivo() {
		return nombreArchivo;
	}
	public void setNombreArchivo(String nombreArchivo) {
		this.nombreArchivo = nombreArchivo;
	}
	public ParametrosAplicacionServicio getParametrosAplicacionServicio() {
		return parametrosAplicacionServicio;
	}
	public void setParametrosAplicacionServicio(
			ParametrosAplicacionServicio parametrosAplicacionServicio) {
		this.parametrosAplicacionServicio = parametrosAplicacionServicio;
	}
	
	
}
