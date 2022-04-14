package contabilidad.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import contabilidad.bean.ProrrateoContableBean;
import contabilidad.servicio.ProrrateoContableServicio;

public class ProrrateoContableControlador extends SimpleFormController{
	ProrrateoContableServicio prorrateoContableServicio=null;
	public ProrrateoContableControlador(){
		setCommandClass(ProrrateoContableBean.class);
		setCommandName("prorrateoMetod");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,HttpServletResponse response,Object command,BindException errors) throws Exception {
		
		ProrrateoContableBean  prorrateoContableBean=(ProrrateoContableBean)command;
		MensajeTransaccionBean mensaje = null;
		int tipoTransaccion=Integer.parseInt(request.getParameter("tipoTransaccion"));		
		mensaje=prorrateoContableServicio.grabaTransaccion(tipoTransaccion, prorrateoContableBean);		
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);			
	}

	public ProrrateoContableServicio getProrrateoContableServicio() {
		return prorrateoContableServicio;
	}
	public void setProrrateoContableServicio(
			ProrrateoContableServicio prorrateoContableServicio) {
		this.prorrateoContableServicio = prorrateoContableServicio;
	}
	
}
