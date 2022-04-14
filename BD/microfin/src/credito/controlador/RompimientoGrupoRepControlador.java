package credito.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import credito.bean.RompimientoGrupoBean;
import credito.servicio.RompimientoGrupoServicio;


public class RompimientoGrupoRepControlador extends SimpleFormController {

	RompimientoGrupoServicio rompimientoGrupoServicio = null;

	public RompimientoGrupoRepControlador(){
		setCommandClass(RompimientoGrupoBean.class);
		setCommandName("rompimientoGrupoBean");
	}

	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse response,
									Object command,
									BindException errors) throws Exception {
	
		MensajeTransaccionBean mensaje = null;
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	//Getter y Setter
	public RompimientoGrupoServicio getRompimientoGrupoServicio() {
		return rompimientoGrupoServicio;
	}

	public void setRompimientoGrupoServicio(
			RompimientoGrupoServicio rompimientoGrupoServicio) {
		this.rompimientoGrupoServicio = rompimientoGrupoServicio;
	}
}
	