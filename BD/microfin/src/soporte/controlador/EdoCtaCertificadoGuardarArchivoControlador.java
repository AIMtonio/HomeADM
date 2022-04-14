package soporte.controlador;

import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;
import general.servicio.ParametrosAplicacionServicio;

import java.io.File;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.FileUtils;
import org.springframework.validation.BindException;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import soporte.bean.EdoCtaCertificadoBean;
import soporte.servicio.EdoCtaCertificadoServicio;



public class EdoCtaCertificadoGuardarArchivoControlador extends SimpleFormController{
			MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
			EdoCtaCertificadoServicio edoCtaCertificadoServicio=null;
			ParametrosAplicacionServicio	parametrosAplicacionServicio	= null;
			
			
			String directorioCompleto="";
			MultipartFile file;			
			int esKey=1,esCer=2,extension;
						
			protected ModelAndView onSubmit(HttpServletRequest request,HttpServletResponse response,Object command,BindException errors) throws Exception{
		
			EdoCtaCertificadoBean edoCtaCertificadoBean = (EdoCtaCertificadoBean) command;
			ParametrosSesionBean parametros = parametrosAplicacionServicio.consultaParametrosSessionLocal();
			
			String rutaPredeterminada=parametros.getRutaArchivos()+"ArchivosCSD/";
			String directorio =rutaPredeterminada;			
			extension=Integer.parseInt(request.getParameter("ext"));				
			boolean exists = (new File(directorio)).exists();
			if (exists) {
				if(extension==esKey){
					file = edoCtaCertificadoBean.getArchivoKey();						
				}else if(extension==esCer){
					file = edoCtaCertificadoBean.getArchivoCer();					
				}							
				if (file != null) {				
					File filespring = new File(directorio+file.getOriginalFilename());	
					FileUtils.writeByteArrayToFile(filespring, file.getBytes());
					directorioCompleto=directorio+file.getOriginalFilename();
					enviarMesajeExito();
				}else{
					enviarMensajeError();
				}
			}else {
				File aDir = new File(directorio);
				aDir.mkdir();
				if(extension==esKey){
					file = edoCtaCertificadoBean.getArchivoKey();						
				}else if(extension==esCer){
					file = edoCtaCertificadoBean.getArchivoCer();					
				}
				if (file != null) {
					File filespring = new File(directorio+file.getOriginalFilename());
					FileUtils.writeByteArrayToFile(filespring, file.getBytes());
					directorioCompleto=directorio+file.getOriginalFilename();
					enviarMesajeExito();
				}else{
					enviarMensajeError();
				}
			}																		
			return new ModelAndView(getSuccessView(), "mensaje", mensaje);
		}
			
		public void setEdoCtaCertificadoServicio(EdoCtaCertificadoServicio edoCtaCertificadoServicio) {
			this.edoCtaCertificadoServicio = edoCtaCertificadoServicio;
		}
		
		public void enviarMensajeError(){
			mensaje.setNumero(1);
			mensaje.setNombreControl(file.getOriginalFilename());
			mensaje.setDescripcion("Error en la creacion de archivos");
			mensaje.setConsecutivoString("");
			mensaje.setConsecutivoInt(Integer.toString(extension));			
		}
		public void enviarMesajeExito(){
			mensaje.setNumero(0);
			mensaje.setNombreControl(file.getOriginalFilename());
			mensaje.setDescripcion("El archivo con extensión "+file.getOriginalFilename().substring(file.getOriginalFilename().lastIndexOf("."))+" se ha cargado exitosamente");
			mensaje.setConsecutivoString(directorioCompleto);
			mensaje.setConsecutivoInt(Integer.toString(extension));
		}

		public ParametrosAplicacionServicio getParametrosAplicacionServicio() {
			return parametrosAplicacionServicio;
		}

		public void setParametrosAplicacionServicio(
				ParametrosAplicacionServicio parametrosAplicacionServicio) {
			this.parametrosAplicacionServicio = parametrosAplicacionServicio;
		}
		
}
