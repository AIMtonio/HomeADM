package buroCredito.controlador;

import general.bean.MensajeTransaccionBean;
import herramientas.Utileria;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import buroCredito.bean.BuroCalificaBean;
import buroCredito.servicio.BuroCalificaServicio;

public class BuroCalificaControlador extends SimpleFormController {
	
	BuroCalificaServicio buroCalificaServicio = null;

	public BuroCalificaControlador(){
		setCommandClass(BuroCalificaBean.class);
		setCommandName("buroCalificaBean");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {
		MensajeTransaccionBean mensaje = null;
		
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}
	
	
	public BuroCalificaServicio getBuroCalificaServicio() {
		return buroCalificaServicio;
	}

	public void setBuroCalificaServicio(BuroCalificaServicio buroCalificaServicio) {
		this.buroCalificaServicio = buroCalificaServicio;
	}
}
