package gestionComecial.controlador;

import general.bean.MensajeTransaccionBean;
import gestionComecial.bean.PuestosBean;
import gestionComecial.servicio.PuestosServicio;
import herramientas.Utileria;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;



public class PuestosControlador extends SimpleFormController{
	
	PuestosServicio puestosServicio = null;

	public PuestosControlador() {
		setCommandClass(PuestosBean.class);
		setCommandName("puestos");
}
	

protected ModelAndView onSubmit(HttpServletRequest request,
		HttpServletResponse response,
		Object command,
		BindException errors) throws Exception {
	
	puestosServicio.getPuestosDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
	
	PuestosBean puestos = (PuestosBean) command;
	int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
	

	MensajeTransaccionBean mensaje = null;
	mensaje = puestosServicio.grabaTransaccion(tipoTransaccion,puestos);
									
	return new ModelAndView(getSuccessView(), "mensaje", mensaje);
}
	public void setPuestosServicio(PuestosServicio puestosServicio) {
		this.puestosServicio = puestosServicio;
}

}
