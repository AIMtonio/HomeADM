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
import tesoreria.bean.CuentasSantanderBean;
import tesoreria.servicio.CuentasSantanderServicio;

public class ResCuentasSantanderControlador extends SimpleFormController {
	
	CuentasSantanderServicio cuentasSantanderServicio =null;
		
	public ResCuentasSantanderControlador(){
 		setCommandClass(CuentasSantanderBean.class);
 		setCommandName("cuentasSantander");
 	}	
	
	protected ModelAndView onSubmit(HttpServletRequest request,
				HttpServletResponse response,
				Object command,
				BindException errors) throws Exception {

		cuentasSantanderServicio.getCuentasSantanderDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		
		CuentasSantanderBean cuentasSantanderBean = (CuentasSantanderBean) command;
		
		//SETEAMOS LOS VALORES POR DEFECTOS, EN CASO VENIR NULOS
		cuentasSantanderBean.setRutaArchCtasActivas((request.getParameter("rutaArchCtasActivas")!=null) ? request.getParameter("rutaArchCtasActivas"): "");
		cuentasSantanderBean.setRutaArchCtasPendientes((request.getParameter("rutaArchCtasPendientes")!=null) ? request.getParameter("rutaArchCtasPendientes"): "");
		cuentasSantanderBean.setArchCtasActivas((request.getParameter("archCtasActivas")!=null) ? request.getParameter("archCtasActivas"): "");
		cuentasSantanderBean.setArchCtasPendientes((request.getParameter("archCtasPendientes")!=null) ? request.getParameter("archCtasPendientes"): "");
		cuentasSantanderBean.setExtensionArch1((request.getParameter("extensionArch1")!=null) ? request.getParameter("extensionArch1"): "");
		cuentasSantanderBean.setExtensionArch2((request.getParameter("extensionArch2")!=null) ? request.getParameter("extensionArch2"): "");
		cuentasSantanderBean.setDelimitador1((request.getParameter("delimitador1")!=null) ? request.getParameter("delimitador1"): "");
		cuentasSantanderBean.setDelimitador2((request.getParameter("delimitador2")!=null) ? request.getParameter("delimitador2"): "");
		
		//SE OBTIENE EL NOMBRE DE LOS ARCHIVOS
		if(cuentasSantanderBean.getRutaArchCtasActivas()!=null){
			cuentasSantanderBean.setArchCtasActivas(FilenameUtils.getBaseName(cuentasSantanderBean.getRutaArchCtasActivas())+ "." + 
					FilenameUtils.getExtension(cuentasSantanderBean.getRutaArchCtasActivas()));
			
			int i = cuentasSantanderBean.getRutaArchCtasActivas().lastIndexOf('.');
			cuentasSantanderBean.setExtensionArch1(cuentasSantanderBean.getRutaArchCtasActivas().substring(i+1));
		}else{
			cuentasSantanderBean.setArchCtasActivas("");
			cuentasSantanderBean.setExtensionArch1("");
		}
		
		if(cuentasSantanderBean.getRutaArchCtasPendientes()!=null){
			cuentasSantanderBean.setArchCtasPendientes(FilenameUtils.getBaseName(cuentasSantanderBean.getRutaArchCtasPendientes())+ "." + 
					   FilenameUtils.getExtension(cuentasSantanderBean.getRutaArchCtasPendientes()));
			
			int z = cuentasSantanderBean.getRutaArchCtasPendientes().lastIndexOf('.');
			cuentasSantanderBean.setExtensionArch2(cuentasSantanderBean.getRutaArchCtasPendientes().substring(z+1));
		}else{
			cuentasSantanderBean.setArchCtasPendientes("");
			cuentasSantanderBean.setExtensionArch2("");
			
		}
		
		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
		MensajeTransaccionBean mensaje = null;

		mensaje = cuentasSantanderServicio.grabaRespuestaSantander(tipoTransaccion, cuentasSantanderBean);
		
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
		
	}
	
	public CuentasSantanderServicio getCuentasSantanderServicio() {
		return cuentasSantanderServicio;
	}

	public void setCuentasSantanderServicio(
			CuentasSantanderServicio cuentasSantanderServicio) {
		this.cuentasSantanderServicio = cuentasSantanderServicio;
	}
	
	
	

}
