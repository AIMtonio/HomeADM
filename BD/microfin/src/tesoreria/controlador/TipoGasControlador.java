package tesoreria.controlador;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import general.bean.MensajeTransaccionBean;


import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import tesoreria.bean.TipoGasBean;
import tesoreria.servicio.TipoGasServicio;

public class TipoGasControlador extends SimpleFormController{
	
	TipoGasServicio tipoGasServicio = null;

	public TipoGasControlador() {
		setCommandClass(TipoGasBean.class);
		setCommandName("tipoGasto");
}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
		
		tipoGasServicio.getTipoGasDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		
		TipoGasBean tipoGas = (TipoGasBean) command;
		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
		

		MensajeTransaccionBean mensaje = null;
		mensaje = tipoGasServicio.grabaTransaccion(tipoTransaccion,tipoGas);
										
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}
		public void setTipoGasServicio(TipoGasServicio tipoGasServicio) {
			this.tipoGasServicio = tipoGasServicio;
	}
}
