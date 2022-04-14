package tesoreria.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import tesoreria.bean.TiposMovTesoBean;
import tesoreria.servicio.TiposMovTesoServicio;


public class TiposMovTesoControlador extends SimpleFormController{
	
	TiposMovTesoServicio tiposMovTesoServicio = null;
	
	public TiposMovTesoControlador(){
		setCommandClass(TiposMovTesoBean.class);
		setCommandName("tiposMovTeso");
		
	}
	  
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
		TiposMovTesoBean tiposMovTesoBean = (TiposMovTesoBean) command;
	
		tiposMovTesoServicio.getTiposMovTesoDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
		MensajeTransaccionBean mensaje = null;
		mensaje = tiposMovTesoServicio.grabaTransaccion(tipoTransaccion, tiposMovTesoBean);
		
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);	
	}
	
	public void setTiposMovTesoServicio(TiposMovTesoServicio tiposMovTesoServicio){
		this.tiposMovTesoServicio = tiposMovTesoServicio;
	}
	
	public TiposMovTesoServicio getTiposMovTesoServicio(){
		return this.tiposMovTesoServicio;
	}
	

}
