package tesoreria.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import tesoreria.bean.CuentaNostroBean;
import tesoreria.bean.DispersionMasivaBean;
import tesoreria.servicio.DispersionMasivaServicio;



public class DispersionMasivaControlador extends SimpleFormController{
	
	DispersionMasivaServicio dispersionMasivaServicio;
	
	public DispersionMasivaControlador() { 
		setCommandClass(DispersionMasivaBean.class);
		setCommandName("dispersionMasivaBean"); 
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {

		DispersionMasivaBean dispersionMasivaBean = (DispersionMasivaBean) command;

		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));


	MensajeTransaccionBean mensaje = null;
	mensaje = dispersionMasivaServicio.grabaTransaccion(tipoTransaccion,dispersionMasivaBean);
											
	return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public DispersionMasivaServicio getDispersionMasivaServicio() {
		return dispersionMasivaServicio;
	}

	public void setDispersionMasivaServicio(
			DispersionMasivaServicio dispersionMasivaServicio) {
		this.dispersionMasivaServicio = dispersionMasivaServicio;
	}
	
	
}
