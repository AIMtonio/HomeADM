package credito.controlador;

import general.bean.MensajeTransaccionBean;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;
import org.springframework.web.servlet.mvc.SimpleFormController;

import credito.bean.OblSolidariosPorSoliciBean;
import credito.bean.IntegraGruposBean;
import credito.servicio.OblSoliPorSoliciServicio;
import credito.servicio.IntegraGruposServicio;

public class OblSolidariosPorSoliciControlador extends SimpleFormController{
	

	private OblSoliPorSoliciServicio oblSoliPorSoliciServicio;
	
	public OblSolidariosPorSoliciControlador() {
		setCommandClass(OblSolidariosPorSoliciBean.class);
		setCommandName("oblSolidPorSolicitud");
	}
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
		
		oblSoliPorSoliciServicio.getOblSolidariosPorSoliciDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		
		OblSolidariosPorSoliciBean oblSolidPorSolicitud = (OblSolidariosPorSoliciBean) command;
		int tipoTransaccion = (request.getParameter("tipoTransaccion")!=null)?
					Integer.parseInt(request.getParameter("tipoTransaccion")):
				0;
		String oblSolidDetalle = request.getParameter("oblSolidarios");
					
		MensajeTransaccionBean mensaje = null;
		mensaje = oblSoliPorSoliciServicio.grabaListaOblSolidarios(tipoTransaccion, oblSolidPorSolicitud, oblSolidDetalle);
																
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}
	public OblSoliPorSoliciServicio getOblSoliPorSoliciServicio() {
		return oblSoliPorSoliciServicio;
	}
	public void setOblSoliPorSoliciServicio(
			OblSoliPorSoliciServicio oblSoliPorSoliciServicio) {
		this.oblSoliPorSoliciServicio = oblSoliPorSoliciServicio;
	}
	
	
}
