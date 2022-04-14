package cliente.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import cliente.bean.RepInteresesPagadosBean;
import cliente.servicio.RepInteresesPagadosServicio;

public class RepInteresesPagadosControlador extends SimpleFormController{
	
	RepInteresesPagadosServicio repInteresesPagadosServicio = null;
	
	public RepInteresesPagadosControlador(){
		setCommandClass(RepInteresesPagadosBean.class);
		setCommandName("repInteresesPagados");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request, HttpServletResponse response,Object command,BindException errors) throws Exception {
	
		RepInteresesPagadosBean repInteresesPagadosBean = (RepInteresesPagadosBean) command;
		MensajeTransaccionBean mensaje = null;
											
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public RepInteresesPagadosServicio getRepInteresesPagadosServicio() {
		return repInteresesPagadosServicio;
	}

	public void setRepInteresesPagadosServicio(
			RepInteresesPagadosServicio repInteresesPagadosServicio) {
		this.repInteresesPagadosServicio = repInteresesPagadosServicio;
	}

}
