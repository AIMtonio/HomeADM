package soporte.controlador;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import general.bean.MensajeTransaccionBean;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import soporte.bean.ParametrosYangaBean;
import soporte.servicio.ParametrosYangaServicio;;

public class ParametrosYangaControlador extends SimpleFormController {
	

	ParametrosYangaServicio parametrosYangaServicio = null;


	public ParametrosYangaControlador() {
		setCommandClass(ParametrosYangaBean.class); 
		setCommandName("parametrosYangaBean");	
	}
	
	
	protected ModelAndView onSubmit(HttpServletRequest request, HttpServletResponse response, Object command,BindException errors) 
	throws Exception {
	

		parametrosYangaServicio.getParametrosYangaDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());

		ParametrosYangaBean parametrosYangaBean = (ParametrosYangaBean) command;

		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null) ?
					Integer.parseInt(request.getParameter("tipoTransaccion")): 0;

		MensajeTransaccionBean mensaje = null;		
		mensaje = parametrosYangaServicio.grabaTransaccion(tipoTransaccion,parametrosYangaBean);
										
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}//fin del onSubmit


	public void setParametrosYangaServicio(ParametrosYangaServicio parametrosYangaServicio) {
		this.parametrosYangaServicio = parametrosYangaServicio;
	}


}// fin de la clase
