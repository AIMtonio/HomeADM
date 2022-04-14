package cliente.controlador;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import general.bean.MensajeTransaccionBean;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import cliente.bean.GruposEmpBean;
import cliente.servicio.GruposEmpServicio;

public class GruposEmpControlador extends SimpleFormController {
					  
	GruposEmpServicio gruposEmpServicio = null;
	
	public GruposEmpControlador(){
		setCommandClass(GruposEmpBean.class);
		setCommandName("empresa");
	}
	
	
	
	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse response,
									Object command,
									BindException errors) throws Exception {
		
		GruposEmpBean empresa = (GruposEmpBean) command;
		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
		//int tipoTransaccion =1;
		
		MensajeTransaccionBean mensaje = null;
		mensaje = gruposEmpServicio.grabaTransaccion(tipoTransaccion, empresa);
		
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);	
	}
	
	public void setGruposEmpServicio(GruposEmpServicio gruposEmpServicio){
		this.gruposEmpServicio = gruposEmpServicio;	
	}
	
	
}
