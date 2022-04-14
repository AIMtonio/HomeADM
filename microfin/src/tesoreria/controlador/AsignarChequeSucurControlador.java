package tesoreria.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import tesoreria.bean.AsignarChequeSucurBean;
import tesoreria.servicio.AsignarChequeSucurServicio;

public class AsignarChequeSucurControlador extends SimpleFormController{
	AsignarChequeSucurServicio asignarChequeSucurServicio=null;
	
	public AsignarChequeSucurControlador(){
		setCommandClass(AsignarChequeSucurBean.class);
		setCommandName("asignarCheque");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,HttpServletResponse response,Object command,BindException errors) throws Exception {
		
		AsignarChequeSucurBean  asignarChequeSucurBean=(AsignarChequeSucurBean)command;
		MensajeTransaccionBean mensaje = null;
		int tipoTransaccion=Integer.parseInt(request.getParameter("tipoTransaccion"));
		
		mensaje=asignarChequeSucurServicio.grabaTransaccion(tipoTransaccion, asignarChequeSucurBean);
		
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);			
	}

	public AsignarChequeSucurServicio getAsignarChequeSucurServicio() {
		return asignarChequeSucurServicio;
	}

	public void setAsignarChequeSucurServicio(
			AsignarChequeSucurServicio asignarChequeSucurServicio) {
		this.asignarChequeSucurServicio = asignarChequeSucurServicio;
	}



	
}
