package credito.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import credito.bean.RompimientoGrupoBean;
import credito.servicio.RompimientoGrupoServicio;


public class RompimientoGrupoControlador  extends SimpleFormController {
	

	RompimientoGrupoServicio rompimientoGrupoServicio = null;


	public RompimientoGrupoControlador() {
		setCommandClass(RompimientoGrupoBean.class); 
		setCommandName("rompimientoGrupoBean");	
	}
	
	
	protected ModelAndView onSubmit(HttpServletRequest request, HttpServletResponse response, Object command,BindException errors) 
	throws Exception {	

		rompimientoGrupoServicio.getRompimientoGrupoDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());

		RompimientoGrupoBean bean = (RompimientoGrupoBean) command;

		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null) ?
					Integer.parseInt(request.getParameter("tipoTransaccion")): 0;
					

		MensajeTransaccionBean mensaje = null;		
		mensaje = rompimientoGrupoServicio.grabaTransaccion(tipoTransaccion ,bean);
										
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}//fin del onSubmit


	
	//* ============== GETTER & SETTER =============  //*	
	public RompimientoGrupoServicio getRompimientoGrupoServicio() {
		return rompimientoGrupoServicio;
	}
	public void setRompimientoGrupoServicio(
			RompimientoGrupoServicio rompimientoGrupoServicio) {
		this.rompimientoGrupoServicio = rompimientoGrupoServicio;
	}

}
