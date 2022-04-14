package bancaMovil.controlador;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import bancaMovil.bean.BAMCuentasOrigenBean;
import bancaMovil.servicio.BAMCuentasOrigenServicio;
import cuentas.servicio.CuentasAhoServicio;
import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;

@SuppressWarnings("deprecation")
public class BAMCuentasOrigenControlador extends SimpleFormController {
	BAMCuentasOrigenServicio cuentasOrigenServicio = null;
	CuentasAhoServicio cuentasAhoServicio = null;

	public BAMCuentasOrigenControlador() {
		setCommandClass(BAMCuentasOrigenBean.class);
		setCommandName("cuentasOrigen");
	}

	protected ModelAndView onSubmit(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {
		
		cuentasOrigenServicio.getBAMCuentasOrigenDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		BAMCuentasOrigenBean cuentasOrigen = (BAMCuentasOrigenBean) command;
		
		MensajeTransaccionBean mensaje = cuentasOrigenServicio.grabaListaBAMCuentasOrigen(0, cuentasOrigen);

		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public void setBAMCuentasOrigenServicio(BAMCuentasOrigenServicio cuentasOrigenServicio) {
		this.cuentasOrigenServicio = cuentasOrigenServicio;
	}

	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
	}

	public CuentasAhoServicio getCuentasAhoServicio() {
		return cuentasAhoServicio;
	}

	public void setCuentasAhoServicio(CuentasAhoServicio cuentasAhoServicio) {
		this.cuentasAhoServicio = cuentasAhoServicio;
	}

}
