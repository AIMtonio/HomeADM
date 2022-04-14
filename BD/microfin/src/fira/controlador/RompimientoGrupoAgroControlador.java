package fira.controlador;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import credito.bean.RompimientoGrupoBean;

import fira.servicio.RompimientoGrupoAgroServicio;
import general.bean.MensajeTransaccionBean;

public class RompimientoGrupoAgroControlador extends SimpleFormController {

	RompimientoGrupoAgroServicio rompimientoGrupoAgroServicio = null;
	
	public RompimientoGrupoAgroControlador() {
		setCommandClass(RompimientoGrupoBean.class); 
		setCommandName("rompimientoGrupoBean");	
	}

	protected ModelAndView onSubmit(HttpServletRequest request, HttpServletResponse response, Object command,BindException errors) 
			throws Exception {	

		rompimientoGrupoAgroServicio.getRompimientoGrupoAgroDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		RompimientoGrupoBean rompimientoGrupoBean = (RompimientoGrupoBean) command;
		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null) ? Integer.parseInt(request.getParameter("tipoTransaccion")): 0;

		MensajeTransaccionBean mensajeTransaccionBean = null;		
		mensajeTransaccionBean = rompimientoGrupoAgroServicio.grabaTransaccion(tipoTransaccion ,rompimientoGrupoBean);
		return new ModelAndView(getSuccessView(), "mensaje", mensajeTransaccionBean);
	}

	public RompimientoGrupoAgroServicio getRompimientoGrupoAgroServicio() {
		return rompimientoGrupoAgroServicio;
	}

	public void setRompimientoGrupoAgroServicio(
			RompimientoGrupoAgroServicio rompimientoGrupoAgroServicio) {
		this.rompimientoGrupoAgroServicio = rompimientoGrupoAgroServicio;
	}
}
