package cedes.controlador;
import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import cedes.bean.TipoCuentaSucursalBean;
import cedes.servicio.TipoCuentaSucursalServicio;

public class TipoCuentaSucursalControlador extends SimpleFormController{

	TipoCuentaSucursalServicio tipoCuentaSucursalServicio = null;
	
	public TipoCuentaSucursalControlador() {
			setCommandClass(TipoCuentaSucursalBean.class);
			setCommandName("tipoCuentaSucursalBean");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
		tipoCuentaSucursalServicio.getTipoCuentaSucursalDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());

		TipoCuentaSucursalBean tipoCuentaSucursal = (TipoCuentaSucursalBean) command;
		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
		

		MensajeTransaccionBean mensaje = null;
		mensaje = tipoCuentaSucursalServicio.grabaTransaccion(tipoTransaccion,tipoCuentaSucursal);
										
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	/* Getter y Setter */
	public TipoCuentaSucursalServicio getTipoCuentaSucursalServicio() {
		return tipoCuentaSucursalServicio;
	}

	public void setTipoCuentaSucursalServicio(
			TipoCuentaSucursalServicio tipoCuentaSucursalServicio) {
		this.tipoCuentaSucursalServicio = tipoCuentaSucursalServicio;
	}
} 
