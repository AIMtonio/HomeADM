package pld.controlador;

import general.bean.MensajeTransaccionBean;
import herramientas.Utileria;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import pld.bean.ConocimientoUsuarioServiciosBean;
import pld.servicio.ConocimientoUsuarioServiciosServicio;


public class ConocimientoUsuarioServiciosControlador extends SimpleFormController {

	ConocimientoUsuarioServiciosServicio conocimientoUsuarioServicio = null;

	public ConocimientoUsuarioServiciosControlador() {
		setCommandClass(ConocimientoUsuarioServiciosBean.class);
		setCommandName("conocimientoUsuarioBean");
	}

	protected ModelAndView onSubmit(HttpServletRequest request,HttpServletResponse response, Object command, BindException errors) throws Exception {

        conocimientoUsuarioServicio.getConocimientoUsuarioServiciosDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());

		ConocimientoUsuarioServiciosBean bean = (ConocimientoUsuarioServiciosBean) command;

        int tipoTransaccion = (Utileria.esNumero(request.getParameter("tipoTransaccion"))) ? Utileria.convierteEntero(request.getParameter("tipoTransaccion")) : 0;

		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();

		mensaje = conocimientoUsuarioServicio.grabaTransaccion(tipoTransaccion, bean);

		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public ConocimientoUsuarioServiciosServicio getConocimientoUsuarioServiciosServicio() {
		return conocimientoUsuarioServicio;
	}

	public void setConocimientoUsuarioServiciosServicio( ConocimientoUsuarioServiciosServicio conocimientoUsuarioServicio) {
		this.conocimientoUsuarioServicio = conocimientoUsuarioServicio;
	}
}
