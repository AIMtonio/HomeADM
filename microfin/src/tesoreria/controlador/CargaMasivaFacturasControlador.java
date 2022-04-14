package tesoreria.controlador;
import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import nomina.bean.BitacoraPagoNominaBean;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import tesoreria.bean.CargaMasivaFacturasBean;
import tesoreria.servicio.CargaMasivaFacturasServicio;

public class CargaMasivaFacturasControlador extends SimpleFormController{
	CargaMasivaFacturasServicio cargaMasivaFacturasServicio = null;

	public CargaMasivaFacturasControlador(){
		setCommandClass(CargaMasivaFacturasBean.class);
		setCommandName("cargaMasivaFacturasBean");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,	HttpServletResponse response,Object command,BindException errors) throws Exception {
		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?		
		Integer.parseInt(request.getParameter("tipoTransaccion")):0;
			
		cargaMasivaFacturasServicio.getCargaMasivaFacturasDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
			
		CargaMasivaFacturasBean cargaMasivaFacturasBean = (CargaMasivaFacturasBean) command;
		MensajeTransaccionBean mensaje = null;
		mensaje = cargaMasivaFacturasServicio.grabaTransaccion(tipoTransaccion,cargaMasivaFacturasBean, null);
		
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	
	public CargaMasivaFacturasServicio getCargaMasivaFacturasServicio() {
		return cargaMasivaFacturasServicio;
	}

	public void setCargaMasivaFacturasServicio(
			CargaMasivaFacturasServicio cargaMasivaFacturasServicio) {
		this.cargaMasivaFacturasServicio = cargaMasivaFacturasServicio;
	}
	

}
