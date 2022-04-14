package cuentas.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import cuentas.bean.CuentasAhoBean;
import cuentas.servicio.CuentasAhoServicio;

public class DesbloqueoMasivoCuentasControlador extends SimpleFormController {
	//protected final Logger loggerSAFI = Logger.getLogger("SAFI");

	CuentasAhoServicio cuentasAhoServicio= null;
	public  DesbloqueoMasivoCuentasControlador(){
		
 		setCommandClass(CuentasAhoBean.class);
 		setCommandName("desbloqueoMasivoBean");
 	}
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response, Object command, BindException errors)
			throws Exception {
		cuentasAhoServicio.getCuentasAhoDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());

		int tipoTransaccion = (request.getParameter("tipoTransaccion")!=null)?
								Integer.parseInt(request.getParameter("tipoTransaccion")):0;
		MensajeTransaccionBean mensaje = null;
		mensaje = cuentasAhoServicio.grabaTransaccionDesbloqueoCuenta(tipoTransaccion);
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
}
	public CuentasAhoServicio getCuentasAhoServicio() {
		return cuentasAhoServicio;
	}
	public void setCuentasAhoServicio(CuentasAhoServicio cuentasAhoServicio) {
		this.cuentasAhoServicio = cuentasAhoServicio;
	}
	
	
}