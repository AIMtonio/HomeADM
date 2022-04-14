package pld.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import pld.bean.PLDListasPersBloqBean;
import pld.servicio.PLDListasPersBloqServicio;

public class PLDListasPersBloqControlador extends SimpleFormController{
	
	PLDListasPersBloqServicio pldListasPersBloqServicio = null;
	
	private PLDListasPersBloqControlador(){
		setCommandClass(PLDListasPersBloqBean.class);
		setCommandName("listasPersBloq");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse response,
									Object command,
									BindException errors) throws Exception {
		pldListasPersBloqServicio.getPldListasPersBloqDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());

		PLDListasPersBloqBean  listasPersBloq = (PLDListasPersBloqBean) command;
		int tipoTransaccion = (request.getParameter("tipoTransaccion")!=null)?
								Integer.parseInt(request.getParameter("tipoTransaccion")):0;
	
		MensajeTransaccionBean mensaje = null;
		mensaje = pldListasPersBloqServicio.grabaTransaccion(tipoTransaccion, listasPersBloq);
		
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public PLDListasPersBloqServicio getPldListasPersBloqServicio() {
		return pldListasPersBloqServicio;
	}

	public void setPldListasPersBloqServicio(
			PLDListasPersBloqServicio pldListasPersBloqServicio) {
		this.pldListasPersBloqServicio = pldListasPersBloqServicio;
	}
}
