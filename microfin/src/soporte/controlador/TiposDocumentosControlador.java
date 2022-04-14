package soporte.controlador;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import soporte.bean.ClasificaGrpDoctosBean;
import soporte.bean.TiposDocumentosBean;
import soporte.servicio.ClasificaGrpDoctosServicio;
import soporte.servicio.GrupoDocumentosServicio;
import soporte.servicio.TiposDocumentosServicio;

public class TiposDocumentosControlador extends SimpleFormController {
	
	TiposDocumentosServicio tiposDocumentosServicio = null;
 	private ParametrosSesionBean parametrosSesionBean = null;

	public TiposDocumentosControlador() {
		setCommandClass(TiposDocumentosBean.class);
		setCommandName("tiposDocumentosBean");
	}
			
	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse response,
									Object command,
									BindException errors) throws Exception {
		
		tiposDocumentosServicio.getTiposDocumentosDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		
		TiposDocumentosBean tiposDoc = (TiposDocumentosBean) command;
		
		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));	
			
		MensajeTransaccionBean mensaje = null;
		
		mensaje = tiposDocumentosServicio.grabaTransaccion(tipoTransaccion,tiposDoc);		
	
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}

	public TiposDocumentosServicio getTiposDocumentosServicio() {
		return tiposDocumentosServicio;
	}

	public void setTiposDocumentosServicio(
			TiposDocumentosServicio tiposDocumentosServicio) {
		this.tiposDocumentosServicio = tiposDocumentosServicio;
	}



	
}
