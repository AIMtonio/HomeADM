package contabilidad.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import contabilidad.bean.TimbradoPorProductoBean;
import contabilidad.servicio.TimbradoPorProductoServicio;


public class TimbradoPorProductoControlador extends SimpleFormController{


	TimbradoPorProductoServicio timbradoPorProductoServicio = null;
	
	public TimbradoPorProductoControlador(){
		setCommandClass(TimbradoPorProductoBean.class);
		setCommandName("timbradoPorProductoBean");
	}
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
		
		timbradoPorProductoServicio.getTimbradoPorProductoDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		
		TimbradoPorProductoBean frecTimbradoProducBean =(TimbradoPorProductoBean)command;
		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));	
		MensajeTransaccionBean mensaje = null;		
		
		mensaje =  timbradoPorProductoServicio.grabaTransaccion(tipoTransaccion, frecTimbradoProducBean);
		
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);	
	}
	
	
	public TimbradoPorProductoServicio getTimbradoPorProductoServicio() {
		return timbradoPorProductoServicio;
	}
	public void setTimbradoPorProductoServicio(
			TimbradoPorProductoServicio timbradoPorProductoServicio) {
		this.timbradoPorProductoServicio = timbradoPorProductoServicio;
	}
}
