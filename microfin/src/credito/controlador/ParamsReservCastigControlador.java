package credito.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import credito.bean.ParamsReservCastigBean;
import credito.servicio.ParamsReservCastigServicio;


public class ParamsReservCastigControlador extends SimpleFormController {
	
	ParamsReservCastigServicio paramsReservCastigServicio =null;
	
	public ParamsReservCastigControlador(){
		setCommandClass(ParamsReservCastigBean.class);
		setCommandName("paramsReservCastigBean");
		
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
		
		ParamsReservCastigBean bean = (ParamsReservCastigBean) command;
		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
		MensajeTransaccionBean mensaje = null;
		paramsReservCastigServicio.getParamsReservCastigDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		
		mensaje = paramsReservCastigServicio.grabaTransaccion(tipoTransaccion, bean);
		
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

 //*****************************GETTERS Y SETTERS **********************************	
	public ParamsReservCastigServicio getParamsReservCastigServicio() {
		return paramsReservCastigServicio;
	}

	public void setParamsReservCastigServicio(
			ParamsReservCastigServicio paramsReservCastigServicio) {
		this.paramsReservCastigServicio = paramsReservCastigServicio;
	}

	
	
}
