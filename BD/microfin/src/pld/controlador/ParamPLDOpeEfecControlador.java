package pld.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import pld.bean.OpeInusualesBean;
import pld.bean.ParamPLDOpeEfecBean;
import pld.bean.ParametrosAlertasBean;
import pld.bean.ParametrosPLDBean;
import pld.servicio.OpeInusualesServicio;
import pld.servicio.ParamPLDOpeEfecServicio;
import pld.servicio.ParametrosAlertasServicio;
import pld.servicio.ParametrosPLDServicio;

public class ParamPLDOpeEfecControlador extends SimpleFormController{
	
	ParamPLDOpeEfecServicio paramPLDOpeEfecServicio = null;

	public ParamPLDOpeEfecControlador() {
		setCommandClass(ParamPLDOpeEfecBean.class);
		setCommandName("paramPLDOpeEfecBean");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
		
		paramPLDOpeEfecServicio.getParamPLDOpeEfecDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		
		ParamPLDOpeEfecBean paramPLDOpeEfecBean = (ParamPLDOpeEfecBean) command;
		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
		
		MensajeTransaccionBean mensaje = null;
		mensaje = paramPLDOpeEfecServicio.grabaTransaccion(tipoTransaccion,paramPLDOpeEfecBean);

		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public ParamPLDOpeEfecServicio getParamPLDOpeEfecServicio() {
		return paramPLDOpeEfecServicio;
	}

	public void setParamPLDOpeEfecServicio(
			ParamPLDOpeEfecServicio paramPLDOpeEfecServicio) {
		this.paramPLDOpeEfecServicio = paramPLDOpeEfecServicio;
	}
}

