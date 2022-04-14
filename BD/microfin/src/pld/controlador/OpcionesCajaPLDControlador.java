package pld.controlador;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import general.bean.MensajeTransaccionBean;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import pld.servicio.OpcionesCajaPLDServicio;

import ventanilla.bean.OpcionesPorCajaBean;

public class OpcionesCajaPLDControlador extends SimpleFormController {
	OpcionesCajaPLDServicio opcionesCajaPLDServicio = null;

	String successView = null;

	public OpcionesCajaPLDControlador() {
		setCommandClass(OpcionesPorCajaBean.class);
		setCommandName("opcionesPorCaja");
	}

	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response, Object command, BindException errors)
			throws Exception {
		opcionesCajaPLDServicio.getOpcionesPorCajaDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		OpcionesPorCajaBean opcionesPorCajaBean = (OpcionesPorCajaBean) command;
		
		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
				Integer.parseInt(request.getParameter("tipoTransaccion")):
			0;
		
		MensajeTransaccionBean mensaje = null;

		mensaje = opcionesCajaPLDServicio.grabaTransaccion(opcionesPorCajaBean, tipoTransaccion); //tipoActualizacion
		
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);		

	}

	public OpcionesCajaPLDServicio getOpcionesCajaPLDServicio() {
		return opcionesCajaPLDServicio;
	}

	public void setOpcionesCajaPLDServicio(
			OpcionesCajaPLDServicio opcionesCajaPLDServicio) {
		this.opcionesCajaPLDServicio = opcionesCajaPLDServicio;
	}

}
