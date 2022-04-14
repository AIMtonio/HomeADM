package credito.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import credito.bean.IntegraGruposBean;
import credito.servicio.IntegraGruposServicio;

public class IntegraGruposControlador extends SimpleFormController{
	

	private IntegraGruposServicio integraGruposServicio;
	
	public IntegraGruposControlador() {
		setCommandClass(IntegraGruposBean.class);
		setCommandName("integraGruposCre");
}
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
		
		integraGruposServicio.getIntegraGruposDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		
		IntegraGruposBean integraGrupos = (IntegraGruposBean) command;
		int tipoTransaccion = (request.getParameter("tipoTransaccion")!=null)?
					Integer.parseInt(request.getParameter("tipoTransaccion")):
				0;
		String integraGruposDetalle = request.getParameter("integrantes");
					
		MensajeTransaccionBean mensaje = null;
		mensaje = integraGruposServicio.grabaListaGrupos(tipoTransaccion, integraGrupos, integraGruposDetalle);
																
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}
	public IntegraGruposServicio getIntegraGruposServicio() {
		return integraGruposServicio;
	}
	public void setIntegraGruposServicio(IntegraGruposServicio integraGruposServicio) {
		this.integraGruposServicio = integraGruposServicio;
	}
	

}
