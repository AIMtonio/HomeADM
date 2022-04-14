package fondeador.controlador;

import fondeador.bean.AjusteMovimientosBean;
import fondeador.servicio.AjusteMovimientosServicio;
import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;


public class AjusteMovimientosControlador extends SimpleFormController {
	
	AjusteMovimientosServicio ajusteMovimientosServicio = null;

public AjusteMovimientosControlador() {
	setCommandClass(AjusteMovimientosBean.class);
	setCommandName("ajusteMovimientosBean");
}

protected ModelAndView onSubmit(HttpServletRequest request,
								HttpServletResponse response,
								Object command,							
								BindException errors) throws Exception {
	ajusteMovimientosServicio.getAjusteMovimientosDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
	
	AjusteMovimientosBean ajusteMovimientosBean =new AjusteMovimientosBean();
	ajusteMovimientosBean= (AjusteMovimientosBean) command;
		
	int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
				Integer.parseInt(request.getParameter("tipoTransaccion")):
			0;
	String ajuste = request.getParameter("detalleAjuste");
	
	MensajeTransaccionBean mensaje = null;
	mensaje = ajusteMovimientosServicio.grabaListaAjuste(tipoTransaccion, ajusteMovimientosBean, ajuste);
	
	return new ModelAndView(getSuccessView(), "mensaje", mensaje);
}
public AjusteMovimientosServicio getAjusteMovimientosServicio() {
	return ajusteMovimientosServicio;
}

public void setAjusteMovimientosServicio(AjusteMovimientosServicio ajusteMovimientosServicio) {
	this.ajusteMovimientosServicio = ajusteMovimientosServicio;
}
	
}
