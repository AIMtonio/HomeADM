package tesoreria.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;
import tesoreria.bean.RenovacionOrdenPagoBean;
import tesoreria.servicio.RenovacionOrdenPagoServicio;

public class RenovacionOrdenPagoControlador extends SimpleFormController{
	
	RenovacionOrdenPagoServicio  renovacionOrdenPagoServicio= null;
	
	public RenovacionOrdenPagoControlador() {
		setCommandClass(RenovacionOrdenPagoBean.class);
		setCommandName("renovacionOrdenPago");		
	}

	
	protected ModelAndView onSubmit(HttpServletRequest request,HttpServletResponse response,Object command,	BindException errors) throws Exception {	
		RenovacionOrdenPagoBean renovacionOrdenPagoBean = (RenovacionOrdenPagoBean) command;

		renovacionOrdenPagoServicio.getRenovacionOrdenPagoDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
			Integer.parseInt(request.getParameter("tipoTransaccion")):0;

			MensajeTransaccionBean mensaje = null;
			mensaje = renovacionOrdenPagoServicio.grabaTransaccion(renovacionOrdenPagoBean, tipoTransaccion);

			return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}


	public RenovacionOrdenPagoServicio getRenovacionOrdenPagoServicio() {
		return renovacionOrdenPagoServicio;
	}


	public void setRenovacionOrdenPagoServicio(
			RenovacionOrdenPagoServicio renovacionOrdenPagoServicio) {
		this.renovacionOrdenPagoServicio = renovacionOrdenPagoServicio;
	}

	
}
