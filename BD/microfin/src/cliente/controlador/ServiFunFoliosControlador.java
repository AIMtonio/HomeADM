package cliente.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;
import cliente.bean.ServiFunFoliosBean;
import cliente.servicio.ServiFunFoliosServicio;

public class ServiFunFoliosControlador extends SimpleFormController {
	ServiFunFoliosServicio serviFunFoliosServicio=null;
	public ServiFunFoliosControlador() {
		setCommandClass(ServiFunFoliosBean.class);
		setCommandName("serviFunFolio");
	}
	protected ModelAndView onSubmit(HttpServletRequest request,HttpServletResponse response,Object command,BindException errors) throws Exception {
		serviFunFoliosServicio.getServiFunFoliosDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		
		ServiFunFoliosBean serviFunFolios = (ServiFunFoliosBean) command;
		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
		MensajeTransaccionBean mensaje = null;
		mensaje = serviFunFoliosServicio.grabaTransaccion(tipoTransaccion,serviFunFolios);
																
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);		
	}
		
	public ServiFunFoliosServicio getServiFunFoliosServicio() {
		return serviFunFoliosServicio;
	}
	public void setServiFunFoliosServicio(
			ServiFunFoliosServicio serviFunFoliosServicio) {
		this.serviFunFoliosServicio = serviFunFoliosServicio;
	}
	
}
