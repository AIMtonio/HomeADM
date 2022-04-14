package soporte.controlador;

import general.bean.MensajeTransaccionArchivoBean;
import general.bean.MensajeTransaccionBean;
import herramientas.Constantes;
import herramientas.Utileria;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.FileUtils;
import org.springframework.validation.BindException;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import soporte.bean.CargosBean;
import soporte.bean.CargosObjArchivosBean;
import soporte.bean.ResultadoCargaArchivosObjetadosBean;
import soporte.servicio.CargosObjArchivosServicio;
import soporte.servicio.CargosServicio;
import tesoreria.bean.ResultadoCargaArchivosTesoreriaBean;

public class CargoObjArchivosControlador extends SimpleFormController{
	
	CargosObjArchivosServicio cargosObjArchivosServicio = null;
	

	protected ModelAndView onSubmit(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws ServletException, IOException {
		String recurso ="";
        String directorio ="";
        String nombreArchivo = "";
        String rutaFinal = "";
        String archivoNombre="";
        
        System.out.println("entro al controlador");

    	int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
    	
    	CargosObjArchivosBean cargosObjArchivosBean = (CargosObjArchivosBean) command;
    	ResultadoCargaArchivosObjetadosBean mensajeCarga = new ResultadoCargaArchivosObjetadosBean();
    	FileOutputStream outputStream = null;

    	nombreArchivo = cargosObjArchivosBean.getFile().getOriginalFilename();
		
		recurso = request.getParameter("recurso");
		directorio =	recurso+"CargosObjetados/";
		
		File fichero = new File(directorio);
		
		MensajeTransaccionBean mensaje = null;
		archivoNombre = directorio+nombreArchivo;
		mensajeCarga = validaArchivo(nombreArchivo);
		
		if(mensajeCarga.getNumero() != 0){	
			mensaje = new MensajeTransaccionBean(); 
			mensaje.setNumero(mensajeCarga.getNumero());
			mensaje.setConsecutivoInt(mensajeCarga.getConsecutivoInt());
			mensaje.setConsecutivoString(mensajeCarga.getConsecutivoString());
			mensaje.setDescripcion(mensajeCarga.getDescripcion());
			mensaje.setNombreControl(mensajeCarga.getNombreControl());
			mensaje.setCampoGenerico("");
		}
	else{
		
		 boolean exists = (new File(directorio)).exists();
    		if (exists) {
    			MultipartFile file = cargosObjArchivosBean.getFile();
    			
    			if (file != null) {
    				File filespring = new File(archivoNombre);  
    				FileUtils.writeByteArrayToFile(filespring, file.getBytes());  
    			}
          	   
    		}else {
    			File aDir = new File(directorio);
    			aDir.mkdir();
    			MultipartFile file = cargosObjArchivosBean.getFile();
            
    			if (file != null) {
    				File filespring = new File(archivoNombre);
                  	FileUtils.writeByteArrayToFile(filespring, file.getBytes());  
    			}
    		} 
    		
    		mensaje = new MensajeTransaccionBean(); 
			mensaje.setNumero(0);
			mensaje.setConsecutivoInt("0");
			mensaje.setConsecutivoString(archivoNombre);
			mensaje.setDescripcion("Archivo Ajuntado Exitosamente.");
			mensaje.setNombreControl("");
			mensaje.setCampoGenerico(archivoNombre);
	}
		
		 return new ModelAndView(getSuccessView(), "mensaje", mensaje);
		
	}
   
	public ResultadoCargaArchivosObjetadosBean validaArchivo(String nombreArchivo){
		ResultadoCargaArchivosObjetadosBean mensajeCarga = new ResultadoCargaArchivosObjetadosBean();

		try{
			String nombreOri=nombreArchivo;
			String tokens[] = nombreOri.split("[.]");
			String extension="."+tokens[1];
			if(!extension.equals(".csv")){
				mensajeCarga.setNumero(999);
				mensajeCarga.setConsecutivoInt("0");
				mensajeCarga.setConsecutivoString("");
				mensajeCarga.setDescripcion("Asegurese de Seleccionar el Archivo con extensión .csv ");
				mensajeCarga.setNombreControl("");
				throw new Exception(mensajeCarga.getDescripcion());
			}
			
		}catch(Exception e){
			e.printStackTrace();
			if(mensajeCarga.getNumero()==0){
				mensajeCarga.setNumero(999);
				mensajeCarga.setDescripcion("Error  al cargar el Archivo  ");
				mensajeCarga.setNombreControl("institucionID");
			}
			mensajeCarga.setRuta(Constantes.STRING_VACIO);
		}
		return mensajeCarga;
	}
   
	

	public CargosObjArchivosServicio getCargosObjArchivosServicio() {
		return cargosObjArchivosServicio;
	}

	public void setCargosObjArchivosServicio(
			CargosObjArchivosServicio cargosObjArchivosServicio) {
		this.cargosObjArchivosServicio = cargosObjArchivosServicio;
	}



}
