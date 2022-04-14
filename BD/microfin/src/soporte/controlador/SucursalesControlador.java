package soporte.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import soporte.bean.SucursalesBean;
import soporte.servicio.SucursalesServicio;

public class SucursalesControlador  extends SimpleFormController{

	SucursalesServicio sucursalesServicio = null;
	
	public SucursalesControlador() {
		setCommandClass(SucursalesBean.class);
		setCommandName("sucursal");
	}
		
	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse response,
									Object command,
									BindException errors) throws Exception {

		sucursalesServicio.getSucursalesDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		SucursalesBean sucursal = (SucursalesBean) command;
		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?		
				Integer.parseInt(request.getParameter("tipoTransaccion")):0;
		
		MensajeTransaccionBean mensaje = null;
		mensaje = sucursalesServicio.grabaTransaccion(tipoTransaccion,sucursal);
																
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public SucursalesServicio getSucursalesServicio() {
		return sucursalesServicio;
	}


	public void setSucursalesServicio(SucursalesServicio sucursalesServicio) {
		this.sucursalesServicio = sucursalesServicio;
	}
}
