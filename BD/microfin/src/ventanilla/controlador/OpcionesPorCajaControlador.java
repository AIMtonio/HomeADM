package ventanilla.controlador;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import general.bean.MensajeTransaccionBean;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;


import ventanilla.bean.OpcionesPorCajaBean;
import ventanilla.servicio.OpcionesPorCajaServicio;

public class OpcionesPorCajaControlador extends SimpleFormController {
	OpcionesPorCajaServicio opcionesPorCajaServicio = null;

	String successView = null;

	public OpcionesPorCajaControlador() {
		setCommandClass(OpcionesPorCajaBean.class);
		setCommandName("opcionesPorCaja");
	}

	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response, Object command, BindException errors)
			throws Exception {
		opcionesPorCajaServicio.getOpcionesPorCajaDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		OpcionesPorCajaBean opcionesPorCajaBean = (OpcionesPorCajaBean) command;
		
		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
				Integer.parseInt(request.getParameter("tipoTransaccion")):
			0;
		
		MensajeTransaccionBean mensaje = null;

		mensaje = opcionesPorCajaServicio.grabaTransaccion(opcionesPorCajaBean, tipoTransaccion); //tipoActualizacion
		
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);		

	}

	public OpcionesPorCajaServicio getOpcionesPorCajaServicio() {
		return opcionesPorCajaServicio;
	}

	public void setOpcionesPorCajaServicio(
			OpcionesPorCajaServicio opcionesPorCajaServicio) {
		this.opcionesPorCajaServicio = opcionesPorCajaServicio;
	}


}
