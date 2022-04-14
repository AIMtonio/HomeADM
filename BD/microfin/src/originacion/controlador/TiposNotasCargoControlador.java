package originacion.controlador;

import general.bean.MensajeTransaccionBean;
import herramientas.Utileria;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;

import org.springframework.web.servlet.mvc.SimpleFormController;

import originacion.bean.TiposNotasCargoBean;
import originacion.servicio.TiposNotasCargoServicio;

public class TiposNotasCargoControlador extends SimpleFormController {

	private TiposNotasCargoServicio tiposNotasCargoServicio = null;

	public TiposNotasCargoControlador(){
		setCommandClass(TiposNotasCargoBean.class);
		setCommandName("tiposNotasCargoBean");
	}

	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse response,
									Object command,
									BindException errors) throws Exception {

		TiposNotasCargoBean tiposNotasCargoBean = (TiposNotasCargoBean) command;

		int tipoTransaccion = (request.getParameter("tipoTransaccion") != null) ? Utileria.convierteEntero(request.getParameter("tipoTransaccion")) : 0;

		MensajeTransaccionBean mensaje = null;

		mensaje = tiposNotasCargoServicio.grabaTransaccion(tipoTransaccion, tiposNotasCargoBean);	

		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public TiposNotasCargoServicio getTiposNotasCargoServicio() {
		return tiposNotasCargoServicio;
	}

	public void setTiposNotasCargoServicio(
			TiposNotasCargoServicio tiposNotasCargoServicio) {
		this.tiposNotasCargoServicio = tiposNotasCargoServicio;
	}
}