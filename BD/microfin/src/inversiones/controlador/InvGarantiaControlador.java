package inversiones.controlador;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import general.bean.MensajeTransaccionBean;
import inversiones.bean.InvGarantiaBean;
import inversiones.servicio.InvGarantiaServicio;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

public class InvGarantiaControlador extends SimpleFormController {
	
	public InvGarantiaControlador(){
		setCommandClass(InvGarantiaBean.class);
		setCommandName("invGarantiaBean");
	}
	
	InvGarantiaServicio invGarantiaServicio = null;
	
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {

		InvGarantiaBean invGarantiaBean = (InvGarantiaBean) command;
		invGarantiaServicio.getInvGarantiaDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
				Integer.parseInt(request.getParameter("tipoTransaccion")):
				0;	
		int tipoActualizacion = (request.getParameter("tipoActualizacion")!=null)?
				Integer.parseInt(request.getParameter("tipoActualizacion")):
				0;
		MensajeTransaccionBean mensaje = null;
		mensaje = invGarantiaServicio.grabaTransaccion(tipoTransaccion,tipoActualizacion, invGarantiaBean);
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);		
	}

	public InvGarantiaServicio getInvGarantiaServicio() {
		return invGarantiaServicio;
	}

	public void setInvGarantiaServicio(InvGarantiaServicio invGarantiaServicio) {
		this.invGarantiaServicio = invGarantiaServicio;
	}
}