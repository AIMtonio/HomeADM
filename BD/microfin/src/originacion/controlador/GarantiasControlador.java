package originacion.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;


import originacion.bean.GarantiaBean;
import originacion.servicio.GarantiaServicio;

public class GarantiasControlador extends SimpleFormController {

	GarantiaServicio garantiaServicio = null;

	public GarantiasControlador(){
		setCommandClass(GarantiaBean.class);
		setCommandName("garantiaBean");
	}

	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {

		GarantiaBean garantiaBean = (GarantiaBean) command;
		garantiaServicio.getgarantiasDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?Integer.parseInt(request.getParameter("tipoTransaccion")):0;
		MensajeTransaccionBean mensaje = garantiaServicio.grabaTransaccion(tipoTransaccion, garantiaBean);

		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public void setGarantiaServicio (GarantiaServicio garantiaServicio){
		this.garantiaServicio = garantiaServicio;
	}

	public GarantiaServicio getGarantiaServicio(){
		return this.garantiaServicio;
	}
}
