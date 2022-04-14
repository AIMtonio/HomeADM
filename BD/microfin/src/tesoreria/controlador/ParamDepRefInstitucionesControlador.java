package tesoreria.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import soporte.bean.InstitucionesBean;
import soporte.servicio.InstitucionesServicio;

public class ParamDepRefInstitucionesControlador extends SimpleFormController {
	private InstitucionesServicio institucionesServicio = null;
	
	public ParamDepRefInstitucionesControlador(){
		setCommandClass(InstitucionesBean.class);
		setCommandName("institucionesBean");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
		
		InstitucionesBean institucion = (InstitucionesBean) command;
		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));	
		
		MensajeTransaccionBean mensaje = null;
		mensaje = institucionesServicio.grabaTransaccion(tipoTransaccion,institucion);
																
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public InstitucionesServicio getInstitucionesServicio() {
		return institucionesServicio;
	}

	public void setInstitucionesServicio(InstitucionesServicio institucionesServicio) {
		this.institucionesServicio = institucionesServicio;
	}

}
