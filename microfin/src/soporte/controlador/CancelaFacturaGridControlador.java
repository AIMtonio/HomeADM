package soporte.controlador;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import soporte.bean.CancelaFacturaBean;
import soporte.servicio.CancelaFacturaServicio;

public class CancelaFacturaGridControlador extends AbstractCommandController{
	
	CancelaFacturaServicio cancelaFacturaServicio = null;

	public CancelaFacturaGridControlador() {
		setCommandClass(CancelaFacturaBean.class);
		setCommandName("cancelarFactura");
	}
	
	protected ModelAndView handle(HttpServletRequest request,HttpServletResponse response,Object command,BindException errors) throws Exception {		
		CancelaFacturaBean cancelaFacturaBean = (CancelaFacturaBean) command;
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		List cancelaFacturaList = cancelaFacturaServicio.lista(tipoLista, cancelaFacturaBean);		
		return new ModelAndView("soporte/cancelaFacturaGridVista", "cancelaFacturaList", cancelaFacturaList);
	}

	public CancelaFacturaServicio getCancelaFacturaServicio() {
		return cancelaFacturaServicio;
	}

	public void setCancelaFacturaServicio(CancelaFacturaServicio cancelaFacturaServicio) {
		this.cancelaFacturaServicio = cancelaFacturaServicio;
	}

}
