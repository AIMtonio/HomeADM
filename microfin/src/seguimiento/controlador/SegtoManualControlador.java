package seguimiento.controlador;

import general.bean.MensajeTransaccionBean;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;
import org.springframework.web.servlet.mvc.SimpleFormController;

import seguimiento.bean.SegtoManualBean;
import seguimiento.bean.SeguimientoBean;
import seguimiento.servicio.SegtoManualServicio;
import seguimiento.servicio.SeguimientoServicio;

public class SegtoManualControlador extends SimpleFormController{
	
	SegtoManualServicio segtoManualServicio = null;
	
	public SegtoManualControlador() {
		setCommandClass(SegtoManualBean.class);
		setCommandName("segtoManualBean");
	}

	
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,							
			BindException errors) throws Exception {


	int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
	SegtoManualBean segtoManualBean = (SegtoManualBean) command;
	MensajeTransaccionBean mensaje = null;
	mensaje = segtoManualServicio.grabaTransaccion(tipoTransaccion, segtoManualBean);
			
	return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public SegtoManualServicio getSegtoManualServicio() {
		return segtoManualServicio;
	}

	public void setSegtoManualServicio(SegtoManualServicio segtoManualServicio) {
		this.segtoManualServicio = segtoManualServicio;
	}
}