package activos.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import activos.bean.TiposActivosBean;
import activos.servicio.TiposActivosServicio;

public class TiposActivosControlador extends SimpleFormController{
	private TiposActivosServicio tiposActivosServicio = null;

	public TiposActivosControlador(){
		setCommandClass(TiposActivosBean.class);
		setCommandName("tiposActivosBean");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
		
		tiposActivosServicio.getTiposActivosDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		
		TiposActivosBean tiposActivosBean = (TiposActivosBean)command;
		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
		MensajeTransaccionBean mensaje = null;
		
		mensaje = tiposActivosServicio.grabaTransaccion(tipoTransaccion, tiposActivosBean);
				
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public TiposActivosServicio getTiposActivosServicio() {
		return tiposActivosServicio;
	}

	public void setTiposActivosServicio(TiposActivosServicio tiposActivosServicio) {
		this.tiposActivosServicio = tiposActivosServicio;
	}	
	
}
