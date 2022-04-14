package tesoreria.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.FilenameUtils;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import seguridad.bean.ConexionOrigenDatosBean;
import tesoreria.bean.ResTransferenciaSantaBean;
import tesoreria.servicio.ResTransferenciaSantaServicio;


public class ResTransferenciaSantaControlador extends SimpleFormController {
	
	
	ResTransferenciaSantaServicio resTransferenciaSantaServicio = null;
	public ResTransferenciaSantaControlador(){
 		setCommandClass(ResTransferenciaSantaBean.class);
 		setCommandName("resTransferenciaSantaBean");
 	}	
	
	protected ModelAndView onSubmit(HttpServletRequest request,
				HttpServletResponse response,
				Object command,
				BindException errors) throws Exception {

		resTransferenciaSantaServicio.getResTransferenciaSantaDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		ResTransferenciaSantaBean resTransferenciaSantaBean = (ResTransferenciaSantaBean) command;
		
		
		//SETEAMOS LOS VALORES POR DEFECTOS, EN CASO VENIR NULOS
		resTransferenciaSantaBean.setRutaArchivo((request.getParameter("rutaArchivo")!=null) ? request.getParameter("rutaArchivo"): "");	
		resTransferenciaSantaBean.setArchivo((request.getParameter("archivo")!=null) ? request.getParameter("archivo"): "");		
		resTransferenciaSantaBean.setExtensionArchivo((request.getParameter("extensionArchivo")!=null) ? request.getParameter("extensionArchivo"): "");


		
		//SE OBTIENE EL NOMBRE DE LOS ARCHIVOS
		if(resTransferenciaSantaBean.getRutaArchivo()!=null){
			resTransferenciaSantaBean.setArchivo(FilenameUtils.getBaseName(resTransferenciaSantaBean.getRutaArchivo())+ "." + 
					FilenameUtils.getExtension(resTransferenciaSantaBean.getRutaArchivo()));
			
			int i = resTransferenciaSantaBean.getRutaArchivo().lastIndexOf('.');
			resTransferenciaSantaBean.setExtensionArchivo(resTransferenciaSantaBean.getRutaArchivo().substring(i+1));
		}else{
			resTransferenciaSantaBean.setArchivo("");
			resTransferenciaSantaBean.setExtensionArchivo("");
		}
				
		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
		MensajeTransaccionBean mensaje = null;

		mensaje = resTransferenciaSantaServicio.grabaResTranferSantander(tipoTransaccion, resTransferenciaSantaBean);
		
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
		
	}

	public ResTransferenciaSantaServicio getResTransferenciaSantaServicio() {
		return resTransferenciaSantaServicio;
	}

	public void setResTransferenciaSantaServicio(
			ResTransferenciaSantaServicio resTransferenciaSantaServicio) {
		this.resTransferenciaSantaServicio = resTransferenciaSantaServicio;
	}
	
	
	
	
	

}
