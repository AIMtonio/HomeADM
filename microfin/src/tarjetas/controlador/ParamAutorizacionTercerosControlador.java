package tarjetas.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import tarjetas.bean.ParamTarjetasBean;
import tarjetas.servicio.ParamTarjetasServicio;

public class ParamAutorizacionTercerosControlador extends SimpleFormController {
	
	ParamTarjetasServicio paramTarjetasServicio = null;
	
	public ParamAutorizacionTercerosControlador(){
 		setCommandClass(ParamTarjetasBean.class);
 		setCommandName("paramTarjetasBean");
 	}

	protected ModelAndView onSubmit(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {

		paramTarjetasServicio.getParamTarjetasDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		int tipoTransaccion = (request.getParameter("tipoTransaccion") != null) ? Integer.parseInt(request.getParameter("tipoTransaccion")): 0;
		
		ParamTarjetasBean paramTarjetasBean = (ParamTarjetasBean) command;
		MensajeTransaccionBean mensajeTransaccionBean = null;
		mensajeTransaccionBean = paramTarjetasServicio.grabaTransaccion(tipoTransaccion, paramTarjetasBean);

		return new ModelAndView(getSuccessView(), "mensaje", mensajeTransaccionBean);
	}

	public ParamTarjetasServicio getParamTarjetasServicio() {
		return paramTarjetasServicio;
	}

	public void setParamTarjetasServicio(ParamTarjetasServicio paramTarjetasServicio) {
		this.paramTarjetasServicio = paramTarjetasServicio;
	}
}
