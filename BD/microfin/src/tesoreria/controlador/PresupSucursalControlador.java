package tesoreria.controlador;

import general.bean.MensajeTransaccionBean;
import herramientas.Utileria;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import tesoreria.bean.PresupuestoSucursalBean;
import tesoreria.servicio.PresupSucursalServicio;


public class PresupSucursalControlador extends SimpleFormController {


	public PresupSucursalControlador(){
		
		setCommandClass(PresupuestoSucursalBean.class);
		setCommandName("presupuestoSucursalBean");
	}
	
	public PresupSucursalServicio presupSucursalServicio = null;
	
	
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
				
		PresupuestoSucursalBean presupuestoSucursalBean = (PresupuestoSucursalBean) command;
				
		
		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null) ? Integer.parseInt(request.getParameter("tipoTransaccion")) : 0;
		
		
	
		
		
		MensajeTransaccionBean mensaje = null;
				
			mensaje = presupSucursalServicio.grabaTransaccion(tipoTransaccion, presupuestoSucursalBean);

		//mensaje = operDispersionServicio.listaDispersion(tipoTransaccion,presupuestoSucursalBean);
		
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public void setPresupSucursalServicio(PresupSucursalServicio presupSucursalServicio) {
		this.presupSucursalServicio = presupSucursalServicio;
	}
}
