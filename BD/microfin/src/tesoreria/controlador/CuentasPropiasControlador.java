package tesoreria.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import tesoreria.bean.CuentasPropiasBean;
import tesoreria.servicio.CuentasPropiasServicio;

public class CuentasPropiasControlador extends SimpleFormController{

	CuentasPropiasServicio cuentasPropiasServicio = null;

	public CuentasPropiasControlador(){
		setCommandClass(CuentasPropiasBean.class);
		setCommandName("cuentasPropiasBean"); 
	}

	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
		
		cuentasPropiasServicio.getCuentasPropiasDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		CuentasPropiasBean cuentasPropias= (CuentasPropiasBean) command;
		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
		MensajeTransaccionBean mensaje = null;
		mensaje = cuentasPropiasServicio.grabaTransaccion(tipoTransaccion, cuentasPropias);
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public CuentasPropiasServicio getCuentasPropiasServicio() {
		return cuentasPropiasServicio;
	}

	public void setCuentasPropiasServicio(
			CuentasPropiasServicio cuentasPropiasServicio) {
		this.cuentasPropiasServicio = cuentasPropiasServicio;
	}

}
