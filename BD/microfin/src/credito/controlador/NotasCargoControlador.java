package credito.controlador;

import general.bean.MensajeTransaccionBean;
import herramientas.Utileria;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import credito.bean.NotasCargoBean;
import credito.servicio.NotasCargoServicio;

public class NotasCargoControlador extends SimpleFormController {

	private NotasCargoServicio notasCargoServicio = null;

	public NotasCargoControlador(){
		setCommandClass(NotasCargoBean.class);
		setCommandName("notasCargoBean");
	}

	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse response,
									Object command,
									BindException errors) throws Exception {

		NotasCargoBean notasCargoBean = (NotasCargoBean) command;

		int tipoTransaccion = (request.getParameter("tipoTransaccion") != null) ? Utileria.convierteEntero(request.getParameter("tipoTransaccion")) : 0;

		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();

		mensaje = notasCargoServicio.grabaTransaccion(tipoTransaccion, notasCargoBean);

		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public NotasCargoServicio getNotasCargoServicio() {
		return notasCargoServicio;
	}

	public void setNotasCargoServicio(NotasCargoServicio notasCargoServicio) {
		this.notasCargoServicio = notasCargoServicio;
	}
}