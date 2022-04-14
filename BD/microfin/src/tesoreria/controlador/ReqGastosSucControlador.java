package tesoreria.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import tesoreria.bean.ReqGastosSucBean;
import tesoreria.servicio.ReqGastosSucServicio;;

public class ReqGastosSucControlador extends SimpleFormController {

	ReqGastosSucServicio reqGastosSucServicio = null;
	
	public ReqGastosSucControlador(){
		setCommandClass(ReqGastosSucBean.class);
		setCommandName("requisicionGastosSuc");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request, 
									HttpServletResponse response, 
									Object command, 
									BindException errors) throws Exception{
		reqGastosSucServicio.getReqGastosSucDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		ReqGastosSucBean reqGastosSucBean = (ReqGastosSucBean) command;
		MensajeTransaccionBean mensaje = null;
		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?Integer.parseInt(request.getParameter("tipoTransaccion")):0;
		
		mensaje = reqGastosSucServicio.grabaTransaccion(tipoTransaccion, reqGastosSucBean);
				
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);	
	}
	
	public void setReqGastosSucServicio(ReqGastosSucServicio reqGastosSucServicio) {
		this.reqGastosSucServicio = reqGastosSucServicio;
	}
}
