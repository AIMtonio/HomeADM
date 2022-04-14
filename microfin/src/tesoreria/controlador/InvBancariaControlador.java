package tesoreria.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import tesoreria.bean.InvBancariaBean;
import tesoreria.servicio.InvBancariaServicio;

public class InvBancariaControlador extends SimpleFormController {
	
	InvBancariaServicio	invBancariaServicio	= null;
	
	public InvBancariaControlador() {
		setCommandClass(InvBancariaBean.class);
		setCommandName("invBancariaBean");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {
		MensajeTransaccionBean mensaje = null;
		InvBancariaBean inversionBean = (InvBancariaBean) command;
		invBancariaServicio.getInvBancariaDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		
		int tipoTransaccion = (request.getParameter("tipoTransaccion") != null) ? Integer.parseInt(request.getParameter("tipoTransaccion")) : 0;
		String detalles = request.getParameter("detalle");
		mensaje = invBancariaServicio.grabaDetalle(tipoTransaccion, detalles, inversionBean);
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}
	
	public void setInvBancariaServicio(InvBancariaServicio invBancariaServicio) {
		this.invBancariaServicio = invBancariaServicio;
	}
}
