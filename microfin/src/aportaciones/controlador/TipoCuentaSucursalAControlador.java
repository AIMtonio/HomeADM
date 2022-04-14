package aportaciones.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import aportaciones.bean.TipoCuentaSucursalABean;
import aportaciones.servicio.TipoCuentaSucursalAServicio;

public class TipoCuentaSucursalAControlador extends SimpleFormController{
	
	TipoCuentaSucursalAServicio tipoCuentaSucursalAServicio = null;
	
	public TipoCuentaSucursalAControlador() {
			setCommandClass(TipoCuentaSucursalABean.class);
			setCommandName("tipoCuentaSucursalABean");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
		tipoCuentaSucursalAServicio.getTipoCuentaSucursalDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());

		TipoCuentaSucursalABean tipoCuentaSucursal = (TipoCuentaSucursalABean) command;
		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
		

		MensajeTransaccionBean mensaje = null;
		mensaje = tipoCuentaSucursalAServicio.grabaTransaccion(tipoTransaccion,tipoCuentaSucursal);
										
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public TipoCuentaSucursalAServicio getTipoCuentaSucursalAServicio() {
		return tipoCuentaSucursalAServicio;
	}

	public void setTipoCuentaSucursalAServicio(
			TipoCuentaSucursalAServicio tipoCuentaSucursalAServicio) {
		this.tipoCuentaSucursalAServicio = tipoCuentaSucursalAServicio;
	}
	
	

}
