package originacion.controlador;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import general.bean.MensajeTransaccionBean;
import originacion.bean.ServiciosAdicionalesBean;
import originacion.servicio.ServiciosAdicionalesServicio;

public class ServiciosAdicionalesControlador extends SimpleFormController{
	ServiciosAdicionalesServicio serviciosAdicionalesServicio = null;
	
	public ServiciosAdicionalesControlador() {
		setCommandClass(ServiciosAdicionalesBean.class);
		setCommandName("serviciosAdicionales");
	}

		
		protected ModelAndView onSubmit(HttpServletRequest request,
				HttpServletResponse response, 
				Object command, 
				BindException errors)throws Exception {
			
			ServiciosAdicionalesBean servicios = (ServiciosAdicionalesBean) command;
			serviciosAdicionalesServicio.getServiciosAdicionalesDAO().getParametrosAuditoriaBean().setNombrePrograma
			(request.getRequestURI().toString());
			int tipoTransaccion = (request.getParameter("tipoTransaccion")!=null)?
					Integer.parseInt(request.getParameter("tipoTransaccion")):0;
					
			MensajeTransaccionBean mensaje = null;
			mensaje = serviciosAdicionalesServicio.grabaTransaccion(servicios, tipoTransaccion);

			return new ModelAndView(getSuccessView(), "mensaje", mensaje);
		}
				
	
	public ServiciosAdicionalesServicio getServiciosAdicionalesServicio() {
		return serviciosAdicionalesServicio;
	}

	public void setServiciosAdicionalesServicio(ServiciosAdicionalesServicio serviciosAdicionalesServicio) {
		this.serviciosAdicionalesServicio = serviciosAdicionalesServicio;
	}	
}