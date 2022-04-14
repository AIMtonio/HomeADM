package credito.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import credito.bean.EstimacionPreventivaBean;
import credito.servicio.EstimacionPreventivaServicio;

public class EstimacionPreventivaControlador extends SimpleFormController{
	
	EstimacionPreventivaServicio estimacionPreventivaServicio = null;
	
	public EstimacionPreventivaControlador(){
		setCommandClass(EstimacionPreventivaBean.class);
		setCommandName("estimacionPreventivaBean");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,							
			BindException errors) throws Exception {
		int tipoTransaccion = (request.getParameter("tipoTransaccion") != null)?
				Integer.parseInt(request.getParameter("tipoTransaccion")):
					0;
				
		//Seteamos a los Parametros de Auditoria el Nombrel del Programa o Recurso
		estimacionPreventivaServicio.getEstimacionPreventivaDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		
		EstimacionPreventivaBean estimacionPreventivaBean= (EstimacionPreventivaBean) command;
		MensajeTransaccionBean mensaje = null;
		mensaje = estimacionPreventivaServicio.grabaFormaTransaccion(tipoTransaccion, estimacionPreventivaBean);
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public void setEstimacionPreventivaServicio(	
			EstimacionPreventivaServicio estimacionPreventivaServicio) {
		this.estimacionPreventivaServicio = estimacionPreventivaServicio;
	}
	
	
}
