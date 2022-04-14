package originacion.controlador;

import java.io.File;

import general.bean.MensajeTransaccionArchivoBean;
import herramientas.Constantes;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.FileUtils;
import org.springframework.validation.BindException;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import originacion.bean.AsignaCartaLiqBean;
import originacion.servicio.AsignaCartaLiqServicio;

public class CartaLiqArchivoAutUploadControlador extends SimpleFormController{
	AsignaCartaLiqServicio asignaCartaLiqServicio;
	
	public CartaLiqArchivoAutUploadControlador(){
		setCommandClass(AsignaCartaLiqBean.class);
		setCommandName("asignaCarta");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,							
			BindException errors) throws Exception {


		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
				Integer.parseInt(request.getParameter("tipoTransaccion")):0;
		
		String controlID = "";
		String directorio="";
		String archivoNombre="";
		String archivoNombreFinal = "";
		String recurso="";
		String archivoTemporal;
		String tipoArchivo;
		
		AsignaCartaLiqBean cartaLiqArchivoBean = (AsignaCartaLiqBean) command;
		controlID = cartaLiqArchivoBean.getRegID();
		
		archivoNombre = "consolidaTemp" +  cartaLiqArchivoBean.getNombreReg();
		archivoNombreFinal = cartaLiqArchivoBean.getNombreReg();
		tipoArchivo = cartaLiqArchivoBean.getTipoArchivo();

		cartaLiqArchivoBean.setRutaFinal(cartaLiqArchivoBean.getRecurso() + 
				 "Consolidaciones"+ System.getProperty("file.separator") +"Consolidacion" + cartaLiqArchivoBean.getConsolidacionID() +
				 System.getProperty("file.separator") + archivoNombreFinal + controlID);
		
		cartaLiqArchivoBean.setRecurso(cartaLiqArchivoBean.getRecurso() + 
					 "Consolidaciones"+ System.getProperty("file.separator") +"Consolidacion" + cartaLiqArchivoBean.getConsolidacionID() +
					 System.getProperty("file.separator") + archivoNombre + controlID);				

		archivoTemporal = cartaLiqArchivoBean.getRecurso();
		
		//Establecemos el Parametros de Auditoria del Nombre del Programa 
		asignaCartaLiqServicio.getAsignaCartaLiqDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		MensajeTransaccionArchivoBean mensaje = null;		
	
		directorio = recurso + "Consolidaciones" + System.getProperty("file.separator") + "Consolidacion" +
									cartaLiqArchivoBean.getConsolidacionID();
		
		boolean exists = (new File(directorio)).exists();		
		MultipartFile file = cartaLiqArchivoBean.getFile();
		try{
			if (!exists) {
				File aDir = new File(directorio);
				aDir.mkdir();		
			}			
			if (file != null) {
				File filespring = new File(archivoTemporal);  
				FileUtils.writeByteArrayToFile(filespring, file.getBytes());  
			}	
		}catch (Exception e){
			
			e.printStackTrace();
			e.getMessage();
			mensaje.setNumero(999);
			mensaje.setDescripcion("Error en la Carga de Archivo");
		}
		mensaje = new MensajeTransaccionArchivoBean();
		mensaje.setNumero(Constantes.ENTERO_CERO);
		mensaje.setDescripcion("Carga de Archivo Exitosamente");
		
		mensaje.setNombreControl(controlID+"|"+archivoNombre+"|"+cartaLiqArchivoBean.getNombreReg()+"|"+
					tipoArchivo+"|"+ cartaLiqArchivoBean.getRecurso()+"|"+cartaLiqArchivoBean.getExtension()+"|" +
					cartaLiqArchivoBean.getComentario()+"|" + cartaLiqArchivoBean.getRutaFinal());

		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}
	
	public AsignaCartaLiqServicio getAsignaCartaLiqServicio(){
		return asignaCartaLiqServicio;
	}
	
	public void setAsignaCartaLiqServicio(AsignaCartaLiqServicio asignaCartaLiqServicio){
		this.asignaCartaLiqServicio = asignaCartaLiqServicio;
	}
}
