package credito.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import credito.bean.RespaldoPagoCreditoBean;
import credito.servicio.RespaldoPagoCreditoServicio;

public class RespaldoPagoCreditoListaControlador  extends AbstractCommandController{

	RespaldoPagoCreditoServicio respaldoPagoCreditoServicio = null;
	
	public RespaldoPagoCreditoListaControlador() {
		setCommandClass(RespaldoPagoCreditoBean.class);
		setCommandName("respaldoPagoCreditoBean");
	}
			
	protected ModelAndView handle(HttpServletRequest request,
									  HttpServletResponse response,
									  Object command,
									  BindException errors) throws Exception {

		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		String controlID = request.getParameter("controlID");
	
		RespaldoPagoCreditoBean respaldoPagoCreditoBean = (RespaldoPagoCreditoBean) command;
		
		List creditos =	respaldoPagoCreditoServicio.lista(tipoLista, respaldoPagoCreditoBean);
		
		List listaResultado = (List)new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(controlID);
		listaResultado.add(creditos);
				
		return new ModelAndView("credito/respaldoPagoCreditoListaVista", "listaResultado", listaResultado);
	}

	//------------setter-------------
	public void setRespaldoPagoCreditoServicio(
			RespaldoPagoCreditoServicio respaldoPagoCreditoServicio) {
		this.respaldoPagoCreditoServicio = respaldoPagoCreditoServicio;
	}

	
	
}
