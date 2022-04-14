package soporte.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import soporte.bean.GrupoMenuBean;
import soporte.bean.OpcionMenuBean;
import soporte.servicio.GrupoMenuServicio;
import soporte.servicio.OpcionMenuServico;

public class GrupoMenuControlador extends SimpleFormController {

	GrupoMenuServicio grupoMenuServicio = null;
	
	public GrupoMenuControlador() {
		setCommandClass(GrupoMenuBean.class);
		setCommandName("grupos");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse response,
									Object command,							
									BindException errors) throws Exception {
		
		
		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
		GrupoMenuBean grupoMenu = (GrupoMenuBean) command;
		MensajeTransaccionBean mensaje = null;
		mensaje = grupoMenuServicio.grabaTransaccion(tipoTransaccion, grupoMenu);
								
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public void setGrupoMenuServicio(GrupoMenuServicio grupoMenuServicio) {
		this.grupoMenuServicio = grupoMenuServicio;
	}
		
}

