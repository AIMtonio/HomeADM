package cuentas.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import cuentas.bean.CuentasAhoBean;
import cuentas.servicio.CuentasAhoServicio;

public class BloqueoMasivoCuentasControlador extends SimpleFormController {
	CuentasAhoServicio cuentasAhoServicio = null;

	public BloqueoMasivoCuentasControlador() {
		setCommandClass(CuentasAhoBean.class);
		setCommandName("bloqueoMasivoBean");
	}

	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response, Object command, BindException errors)
			throws Exception {
		cuentasAhoServicio.getCuentasAhoDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());

		int tipoTransaccion = (request.getParameter("tipoTransaccion")!=null)?
								Integer.parseInt(request.getParameter("tipoTransaccion")):0;
				

		MensajeTransaccionBean mensaje = null;
		mensaje = cuentasAhoServicio.grabaTransaccionBloqueoDebloqueo(tipoTransaccion);

		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public CuentasAhoServicio getCuentasAhoServicio() {
		return cuentasAhoServicio;
	}

	public void setCuentasAhoServicio(CuentasAhoServicio cuentasAhoServicio) {
		this.cuentasAhoServicio = cuentasAhoServicio;
	}

}