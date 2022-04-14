package cuentas.controlador;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import cuentas.bean.TiposPlanAhorroBean;
import cuentas.servicio.TiposPlanAhorroServicio;
import general.bean.MensajeTransaccionBean;

public class TiposPlanAhorroControlador extends SimpleFormController{
	
	TiposPlanAhorroServicio tiposPlanAhorroServicio = null;
	
	public TiposPlanAhorroControlador() {
		setCommandClass(TiposPlanAhorroBean.class);
		setCommandName("tiposPlanAhorroBean");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse response,
									Object command,
									BindException errores) throws Exception {
		
		TiposPlanAhorroBean tipoPlanAhorroBean = (TiposPlanAhorroBean) command;
		
		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
		
		MensajeTransaccionBean mensaje = null;
		mensaje = tiposPlanAhorroServicio.grabaTransaccion(tipoTransaccion, tipoPlanAhorroBean);
		
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public TiposPlanAhorroServicio getTiposPlanAhorroServicio() {
		return tiposPlanAhorroServicio;
	}

	public void setTiposPlanAhorroServicio(TiposPlanAhorroServicio tiposPlanAhorroServicio) {
		this.tiposPlanAhorroServicio = tiposPlanAhorroServicio;
	}
}
