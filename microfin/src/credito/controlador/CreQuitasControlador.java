package credito.controlador;

import general.bean.MensajeTransaccionBean;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import credito.bean.CreQuitasBean;
import credito.servicio.CreQuitasServicio;

public class CreQuitasControlador  extends SimpleFormController {
		
	CreQuitasServicio creQuitasServicio = null;
	
	public CreQuitasControlador() {
		setCommandClass(CreQuitasBean.class);
		setCommandName("creQuitas");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse response,
									Object command,							
									BindException errors) throws Exception {
		creQuitasServicio.getCreQuitasDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		
		
		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
								Integer.parseInt(request.getParameter("tipoTransaccion")):
								0;
								
		CreQuitasBean creQuitasBean = (CreQuitasBean) command;
		creQuitasBean.setUsuarioID(request.getParameter("usuarioID"));
		creQuitasBean.setPuestoID(request.getParameter("puestoID"));
		
		MensajeTransaccionBean mensaje = null;
		
		mensaje = creQuitasServicio.grabaTransaccion(tipoTransaccion, creQuitasBean);
		
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}
	public CreQuitasServicio getCreQuitasServicio() {
		return creQuitasServicio;
	}

	public void setCreQuitasServicio(CreQuitasServicio creQuitasServicio) {
		this.creQuitasServicio = creQuitasServicio;
	}
		
}

