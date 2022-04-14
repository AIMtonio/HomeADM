package fira.controlador;

import fira.bean.GarantiaAgroBean;
import fira.servicio.GarantiaAgroServicio;
import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

public class GarantiasAgroControlador extends SimpleFormController{
	
	GarantiaAgroServicio garantiaServicio = null;
	
	public GarantiasAgroControlador(){
		setCommandClass(GarantiaAgroBean.class);
		setCommandName("garantiaBean");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {

		GarantiaAgroBean garantiaBean = (GarantiaAgroBean) command;

		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?Integer.parseInt(request.getParameter("tipoTransaccion")):0;
		
		MensajeTransaccionBean mensaje = garantiaServicio.grabaTransaccion(tipoTransaccion, garantiaBean);
				

return new ModelAndView(getSuccessView(), "mensaje", mensaje);
}

	public void setGarantiaAgroServicio (GarantiaAgroServicio garantiaServicio){
		this.garantiaServicio = garantiaServicio;
	}
	public GarantiaAgroServicio getGarantiaAgroServicio(){
		return this.garantiaServicio;
	}
}
