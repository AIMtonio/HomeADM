package credito.controlador;

import general.bean.MensajeTransaccionBean;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;
import org.springframework.web.servlet.mvc.SimpleFormController;

import credito.bean.AvalesPorSoliciBean;
import credito.bean.IntegraGruposBean;
import credito.servicio.AvalesPorSoliciServicio;
import credito.servicio.IntegraGruposServicio;

public class AvalesPorSoliciControlador extends SimpleFormController{
	

	private AvalesPorSoliciServicio avalesPorSoliciServicio;
	
	public AvalesPorSoliciControlador() {
		setCommandClass(AvalesPorSoliciBean.class);
		setCommandName("avalesPorSolicitud");
}
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
		
		avalesPorSoliciServicio.getAvalesPorSoliciDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		
		AvalesPorSoliciBean avalesPorSolicitud = (AvalesPorSoliciBean) command;
		int tipoTransaccion = (request.getParameter("tipoTransaccion")!=null)?
					Integer.parseInt(request.getParameter("tipoTransaccion")):
				0;
		String avalesDetalle = request.getParameter("avales");
					
		MensajeTransaccionBean mensaje = null;
		mensaje = avalesPorSoliciServicio.grabaListaAvales(tipoTransaccion, avalesPorSolicitud, avalesDetalle);
																
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}
	public AvalesPorSoliciServicio getAvalesPorSoliciServicio() {
		return avalesPorSoliciServicio;
	}
	public void setAvalesPorSoliciServicio(
			AvalesPorSoliciServicio avalesPorSoliciServicio) {
		this.avalesPorSoliciServicio = avalesPorSoliciServicio;
	}
	
}
