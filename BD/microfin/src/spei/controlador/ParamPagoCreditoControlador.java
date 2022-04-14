package spei.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import spei.bean.ParamPagoCreditoBean;
import spei.servicio.ParamPagoCreditoServicio;

public class ParamPagoCreditoControlador extends SimpleFormController {

	ParamPagoCreditoServicio	paramPagoCreditoServicio=null;

	public ParamPagoCreditoControlador(){
		setCommandClass(ParamPagoCreditoBean.class);
		setCommandName("paramPagoCreditoBean");
	}

	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse response,
									Object command,
									BindException errors) throws Exception {

		ParamPagoCreditoBean paramPagoCreditoBean = (ParamPagoCreditoBean) command;
		
		paramPagoCreditoServicio.getParamPagoCreditoDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		
		
		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?Integer.parseInt(request.getParameter("tipoTransaccion")):0;

		MensajeTransaccionBean mensaje = null;
		mensaje = paramPagoCreditoServicio.grabaTransaccion(tipoTransaccion, paramPagoCreditoBean);
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	
	public ParamPagoCreditoServicio getParamPagoCreditoServicio() {
		return paramPagoCreditoServicio;
	}

	public void setParamPagoCreditoServicio(
			ParamPagoCreditoServicio paramPagoCreditoServicio) {
		this.paramPagoCreditoServicio = paramPagoCreditoServicio;
	}

	
	
}
