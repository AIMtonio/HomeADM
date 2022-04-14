package soporte.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import soporte.bean.ActivaInactivaProductosBean;
import soporte.servicio.ActivaInactivaProductoServicio;

public class ActivaInactivaProductosControlador extends SimpleFormController{
	
	ActivaInactivaProductoServicio activaInactivaProductoServicio = null; 
	
	public ActivaInactivaProductosControlador(){
		setCommandClass(ActivaInactivaProductosBean.class);
		setCommandName("activaDesacProduc");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
		
		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
		int tipoActualizacion = Integer.parseInt(request.getParameter("tipoActualizacion"));
		
		 //Establecemos el Parametros de Auditoria del Nombre del Programa
		activaInactivaProductoServicio.getActivaInactivaProductosDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		ActivaInactivaProductosBean activarDesactivarProducto = (ActivaInactivaProductosBean) command;
		
		MensajeTransaccionBean mensaje = null;
		mensaje = activaInactivaProductoServicio.actualizaProducto(tipoTransaccion,tipoActualizacion, activarDesactivarProducto);
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
		
	}

	public ActivaInactivaProductoServicio getActivaInactivaProductoServicio() {
		return activaInactivaProductoServicio;
	}

	public void setActivaInactivaProductoServicio(
			ActivaInactivaProductoServicio activaInactivaProductoServicio) {
		this.activaInactivaProductoServicio = activaInactivaProductoServicio;
	}
	
}
