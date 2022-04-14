package nomina.controlador;

import general.bean.MensajeTransaccionBean;
import herramientas.Utileria;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


import nomina.bean.CondicionProductoNominaBean;
import nomina.servicio.CondicionProductoNominaServicio;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

public class CondicionesProductoNominaControlador   extends SimpleFormController{
	CondicionProductoNominaServicio condicionProductoNominaServicio = null;
	
	public CondicionesProductoNominaControlador(){
		// TODO Auto-generated constructor stub
		setCommandClass(CondicionProductoNominaBean.class);
		setCommandName("condicionProductoNominaBean");
		
	}
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {

		CondicionProductoNominaBean condicionProductoNominaBean = (CondicionProductoNominaBean) command;
		
		int tipoTransaccion = (request.getParameter("tipoTransaccion") != null) ? Utileria.convierteEntero(request.getParameter("tipoTransaccion")) : 0;
		condicionProductoNominaServicio.getNominaCondicionCredDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		MensajeTransaccionBean mensaje = null;
        mensaje = null;
		mensaje = condicionProductoNominaServicio.grabaTransaccion(tipoTransaccion, condicionProductoNominaBean);
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}
	public CondicionProductoNominaServicio getCondicionProductoNominaServicio() {
		return condicionProductoNominaServicio;
	}
	public void setCondicionProductoNominaServicio(
			CondicionProductoNominaServicio condicionProductoNominaServicio) {
		this.condicionProductoNominaServicio = condicionProductoNominaServicio;
	}
	
}
