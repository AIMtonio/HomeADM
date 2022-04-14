package tesoreria.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import tesoreria.bean.TipoproveimpuesBean;
import tesoreria.servicio.TipoproveimpuesServicio;

public class TipoproveimpuesControlador extends SimpleFormController{
	
	TipoproveimpuesServicio tipoproveimpuesServicio = null;

	public TipoproveimpuesControlador() {
		setCommandClass(TipoproveimpuesBean.class);
		setCommandName("tipoproveimpues");
}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
		
		tipoproveimpuesServicio.getTipoproveimpuesDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		TipoproveimpuesBean tipoproveimpues = (TipoproveimpuesBean) command;
		
		int tipoTransaccion = (request.getParameter("tipoTransaccion")!=null)?
				Integer.parseInt(request.getParameter("tipoTransaccion")): 0;
		

		MensajeTransaccionBean mensaje = null;
		mensaje = tipoproveimpuesServicio.grabaTransaccion(tipoTransaccion,tipoproveimpues);
										
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public TipoproveimpuesServicio getTipoproveimpuesServicio() {
		return tipoproveimpuesServicio;
	}

	public void setTipoproveimpuesServicio(
			TipoproveimpuesServicio tipoproveimpuesServicio) {
		this.tipoproveimpuesServicio = tipoproveimpuesServicio;
	}



}
