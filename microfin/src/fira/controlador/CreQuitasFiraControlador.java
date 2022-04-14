package fira.controlador;

import fira.servicio.CreQuitasFiraServicio;
import general.bean.MensajeTransaccionBean;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import fira.bean.CreQuitasFiraBean;

public class CreQuitasFiraControlador  extends SimpleFormController {
		
	CreQuitasFiraServicio creQuitasFiraServicio = null;
	
	public CreQuitasFiraControlador() {
		setCommandClass(CreQuitasFiraBean.class);
		setCommandName("creQuitas");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse response,
									Object command,							
									BindException errors) throws Exception {
		creQuitasFiraServicio.getCreQuitasFiraDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		
		
		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
								Integer.parseInt(request.getParameter("tipoTransaccion")):
								0;
								
		CreQuitasFiraBean creQuitasFiraBean = (CreQuitasFiraBean) command;
		creQuitasFiraBean.setUsuarioID(request.getParameter("usuarioID"));
		creQuitasFiraBean.setPuestoID(request.getParameter("puestoID"));
		
		MensajeTransaccionBean mensaje = null;
		mensaje = creQuitasFiraServicio.grabaTransaccion(tipoTransaccion, creQuitasFiraBean);
		
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public CreQuitasFiraServicio getCreQuitasFiraServicio() {
		return creQuitasFiraServicio;
	}

	public void setCreQuitasFiraServicio(CreQuitasFiraServicio creQuitasFiraServicio) {
		this.creQuitasFiraServicio = creQuitasFiraServicio;
	}



		
}

