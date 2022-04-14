package pld.controlador;

import general.bean.MensajeTransaccionBean;
import herramientas.Utileria;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import pld.bean.PerfilTransaccionalBean;
import pld.servicio.PerfilTransaccionalServicio;

public class PerfilTransaccionalControlador extends SimpleFormController{
	PerfilTransaccionalServicio perfilTransaccionalServicio;

	public PerfilTransaccionalControlador() {
		setCommandClass(PerfilTransaccionalBean.class);
		setCommandName("perfilTransaccional");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {
		MensajeTransaccionBean mensaje = null;
		try {
			PerfilTransaccionalBean bean = (PerfilTransaccionalBean) command;
			int tipoTransaccion = Utileria.convierteEntero(request.getParameter("tipoTransaccion"));
			mensaje = perfilTransaccionalServicio.grabaTransaccion(tipoTransaccion, bean);
		} catch (Exception ex) {
			ex.printStackTrace();
			mensaje = new MensajeTransaccionBean();
			mensaje.setNumero(888);
			mensaje.setDescripcion("Error al guardar el Perfil Transaccional." + ex.getMessage());
		} finally {
			if (mensaje == null) {
				mensaje = new MensajeTransaccionBean();
				mensaje.setNumero(777);
				mensaje.setDescripcion("Error al guardar el Perfil Transaccional.");
			}
		}

		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}
	
	public PerfilTransaccionalServicio getPerfilTransaccionalServicio() {
		return perfilTransaccionalServicio;
	}

	public void setPerfilTransaccionalServicio(PerfilTransaccionalServicio perfilTransaccionalServicio) {
		this.perfilTransaccionalServicio = perfilTransaccionalServicio;
	}
}
