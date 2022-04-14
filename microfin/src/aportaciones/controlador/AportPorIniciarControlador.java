package aportaciones.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import aportaciones.bean.AportacionesBean;
import aportaciones.servicio.AportacionesServicio;

public class AportPorIniciarControlador extends SimpleFormController{
	
	AportacionesServicio aportacionesServicio =null;
	String nombreReporte=null;
	String successView=null;
	
	public AportPorIniciarControlador(){
		setCommandClass(AportacionesBean.class);
		setCommandName("aportacionesPorIniciar");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
		
		AportacionesBean aportacionesBean =(AportacionesBean) command;
		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
				Integer.parseInt(request.getParameter("tipoTransaccion")):
			0;
				
		MensajeTransaccionBean mensaje = null;
		
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}
	
	public AportacionesServicio getAportacionesServicio() {
		return aportacionesServicio;
	}


	public void setAportacionesServicio(AportacionesServicio aportacionesServicio) {
		this.aportacionesServicio = aportacionesServicio;
	}


	public String getNombreReporte() {
		return nombreReporte;
	}


	public void setNombreReporte(String nombreReporte) {
		this.nombreReporte = nombreReporte;
	}
}
