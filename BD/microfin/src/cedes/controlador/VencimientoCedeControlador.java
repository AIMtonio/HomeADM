package cedes.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import cedes.bean.CedesBean;
import cedes.servicio.CedesServicio;

public class VencimientoCedeControlador extends SimpleFormController{
	CedesServicio cedesServicio =null;
	String nombreReporte=null;
	String successView=null;
	
	public VencimientoCedeControlador(){
		setCommandClass(CedesBean.class);
		setCommandName("vencimientoCedes");
	}
	
	
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
		
		CedesBean cedesBean =(CedesBean) command;
		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
				Integer.parseInt(request.getParameter("tipoTransaccion")):
			0;
				
		MensajeTransaccionBean mensaje = null;
		
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}


	public CedesServicio getCedesServicio() {
		return cedesServicio;
	}


	public void setCedesServicio(CedesServicio cedesServicio) {
		this.cedesServicio = cedesServicio;
	}

 
	public String getNombreReporte() {
		return nombreReporte;
	}


	public void setNombreReporte(String nombreReporte) {
		this.nombreReporte = nombreReporte;
	}


	

}
