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
import tesoreria.bean.ResOrdPagoSantaBean;
import tesoreria.servicio.ResOrdPagoSantaServicio;


public class ResOrdPagoSantaControlador extends SimpleFormController {
	
	
	ResOrdPagoSantaServicio resOrdPagoSantaServicio = null;
	public ResOrdPagoSantaControlador(){
 		setCommandClass(ResOrdPagoSantaBean.class);
 		setCommandName("resOrdPagoSantaBean");
 	}	
	
	protected ModelAndView onSubmit(HttpServletRequest request,
				HttpServletResponse response,
				Object command,
				BindException errors) throws Exception {

		resOrdPagoSantaServicio.getResOrdPagoSantaDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		ResOrdPagoSantaBean resOrdPagoSantaBean = (ResOrdPagoSantaBean) command;
		
		
		//SETEAMOS LOS VALORES POR DEFECTOS, EN CASO VENIR NULOS
		resOrdPagoSantaBean.setRutaArchivo((request.getParameter("rutaArchOrdPago")!=null) ? request.getParameter("rutaArchOrdPago"): "");	
		resOrdPagoSantaBean.setArchivo((request.getParameter("archivo")!=null) ? request.getParameter("archivo"): "");		
		resOrdPagoSantaBean.setExtensionArchivo((request.getParameter("extensionArchivo")!=null) ? request.getParameter("extensionArchivo"): "");

		
		//SE OBTIENE EL NOMBRE DE LOS ARCHIVOS
		if(resOrdPagoSantaBean.getRutaArchivo()!=null){
			resOrdPagoSantaBean.setArchivo(FilenameUtils.getBaseName(resOrdPagoSantaBean.getRutaArchivo())+ "." + 
					FilenameUtils.getExtension(resOrdPagoSantaBean.getRutaArchivo()));
			
			int i = resOrdPagoSantaBean.getRutaArchivo().lastIndexOf('.');
			resOrdPagoSantaBean.setExtensionArchivo(resOrdPagoSantaBean.getRutaArchivo().substring(i+1));
		}else{
			resOrdPagoSantaBean.setArchivo("");
			resOrdPagoSantaBean.setExtensionArchivo("");
		}
				
		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
		MensajeTransaccionBean mensaje = null;

		mensaje = resOrdPagoSantaServicio.grabaResOrdPagoSantander(tipoTransaccion, resOrdPagoSantaBean);
		
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
		
	}

	public ResOrdPagoSantaServicio getResOrdPagoSantaServicio() {
		return resOrdPagoSantaServicio;
	}

	public void setResOrdPagoSantaServicio(
			ResOrdPagoSantaServicio resOrdPagoSantaServicio) {
		this.resOrdPagoSantaServicio = resOrdPagoSantaServicio;
	}
}
