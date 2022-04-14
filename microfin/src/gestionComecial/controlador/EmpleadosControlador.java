package gestionComecial.controlador;

import general.bean.MensajeTransaccionBean;
import gestionComecial.bean.EmpleadosBean;
import gestionComecial.bean.PuestosBean;
import gestionComecial.servicio.EmpleadosServicio;
import gestionComecial.servicio.PuestosServicio;
import herramientas.Utileria;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

public class EmpleadosControlador extends SimpleFormController{
	
	EmpleadosServicio empleadosServicio = null;

	public EmpleadosControlador() {
		setCommandClass(EmpleadosBean.class);
		setCommandName("empleados");
}
	

protected ModelAndView onSubmit(HttpServletRequest request,
		HttpServletResponse response,
		Object command,
		BindException errors) throws Exception {
	
	empleadosServicio.getEmpleadosDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
	
	EmpleadosBean empleados = (EmpleadosBean) command;
	int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
	

	MensajeTransaccionBean mensaje = null;
	mensaje = empleadosServicio.grabaTransaccion(tipoTransaccion,empleados);
									
	return new ModelAndView(getSuccessView(), "mensaje", mensaje);
}
	public void setEmpleadosServicio(EmpleadosServicio empleadosServicio) {
		this.empleadosServicio = empleadosServicio;
}

}
