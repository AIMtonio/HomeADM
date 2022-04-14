package nomina.controlador;

import general.bean.MensajeTransaccionBean;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import nomina.bean.GeneraDomiciliacionPagosBean;
import nomina.servicio.GeneraDomiciliacionPagosServicio;
import nomina.servicio.GeneraDomiciliacionPagosServicio.Enum_Lis_Domiciliacion;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

public class GeneraDomiciliacionPagosControlador extends SimpleFormController{
	GeneraDomiciliacionPagosServicio generaDomiciliacionPagosServicio = null;

	public GeneraDomiciliacionPagosControlador() {
		setCommandClass(GeneraDomiciliacionPagosBean.class);
		setCommandName("generaDomiciliacionPagosBean");
}
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
			
		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?		
				Integer.parseInt(request.getParameter("tipoTransaccion")):0;
	
		GeneraDomiciliacionPagosBean generaDomiciliacionPagosBean = (GeneraDomiciliacionPagosBean) command;
		MensajeTransaccionBean mensaje = null;
		
		generaDomiciliacionPagosServicio.getGeneraDomiciliacionPagosDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
				
		mensaje = generaDomiciliacionPagosServicio.grabaTransaccion(tipoTransaccion,generaDomiciliacionPagosBean);
	
 		return new ModelAndView(getSuccessView(), "mensaje", mensaje);

	}

	// ============ GETTER  & SETTER ============== //
	
	public GeneraDomiciliacionPagosServicio getGeneraDomiciliacionPagosServicio() {
		return generaDomiciliacionPagosServicio;
	}
	public void setGeneraDomiciliacionPagosServicio(GeneraDomiciliacionPagosServicio generaDomiciliacionPagosServicio) {
		this.generaDomiciliacionPagosServicio = generaDomiciliacionPagosServicio;
	}
	

}