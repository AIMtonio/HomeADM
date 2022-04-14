package seguimiento.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import seguimiento.bean.RegistroGestorBean;
import seguimiento.servicio.RegistroGestorServicio;

public class ConsultaGestoresControlador extends SimpleFormController{
	RegistroGestorServicio  registroGestorServicio= null;

	public ConsultaGestoresControlador() {
		setCommandClass(RegistroGestorBean.class);
		setCommandName("registroGestorBean");
	}
	protected ModelAndView onSubmit(HttpServletRequest request,HttpServletResponse response,Object command,							
			BindException errors) throws Exception {

		RegistroGestorBean registroGestorBean = (RegistroGestorBean) command;

		registroGestorServicio.getRegistroGestorDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
			Integer.parseInt(request.getParameter("tipoTransaccion")):0;

			MensajeTransaccionBean mensaje = null;
			mensaje = registroGestorServicio.grabaTransaccion(tipoTransaccion,registroGestorBean);

			return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}
	
	/* Getter y Setter */
	public RegistroGestorServicio getRegistroGestorServicio() {
		return registroGestorServicio;
	}
	public void setRegistroGestorServicio(
			RegistroGestorServicio registroGestorServicio) {
		this.registroGestorServicio = registroGestorServicio;
	}
}