package cliente.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import cliente.bean.ServiFunFoliosBean;
import cliente.servicio.ServiFunFoliosServicio;

public class RepFoliosSERVIFUNControlador extends SimpleFormController{

	ServiFunFoliosServicio serviFunFoliosServicio= null;
	
	public RepFoliosSERVIFUNControlador() {
		setCommandClass(ServiFunFoliosBean.class);
		setCommandName("serviFunFoliosBean");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse response,
									Object command,							
									BindException errors) throws Exception {
		
		serviFunFoliosServicio.getServiFunFoliosDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		
		ServiFunFoliosBean creCastigados = (ServiFunFoliosBean) command;
	
			MensajeTransaccionBean mensaje = null;
	
	
			return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}
//-------------setterr
	public void setServiFunFoliosServicio(
			ServiFunFoliosServicio serviFunFoliosServicio) {
		this.serviFunFoliosServicio = serviFunFoliosServicio;
	}
	
	
}
