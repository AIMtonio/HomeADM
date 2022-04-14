package cliente.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import cliente.servicio.ProtectAhoCredServicio;
import cliente.bean.ProtecionAhorroCreditoBean;

public class ProtecCreditoGridControlador extends AbstractCommandController{
	ProtectAhoCredServicio protectAhoCredServicio = null;
	protected final Logger loggerSAFI = Logger.getLogger("SAFI");
	public ProtecCreditoGridControlador() {
		setCommandClass(ProtecionAhorroCreditoBean.class);
		setCommandName("creditosBean");
	}
		
	protected ModelAndView handle(HttpServletRequest request,
								  HttpServletResponse response,
								  Object command,
								  BindException errors) throws Exception {
				
		ProtecionAhorroCreditoBean creditos = (ProtecionAhorroCreditoBean) command;
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
        
		List proteccionLista = protectAhoCredServicio.listaProetccionCredito(tipoLista, creditos);
		
		List listaResultado = (List)new ArrayList();
        listaResultado.add(tipoLista);
        listaResultado.add(proteccionLista);
        
		return new ModelAndView("credito/proteccionCredGridVista", "resumCteCred", listaResultado);
			

	}

	//----------------------getter y setter ------------------
	public ProtectAhoCredServicio getProtectAhoCredServicio() {
		return protectAhoCredServicio;
	}

	public void setProtectAhoCredServicio(
			ProtectAhoCredServicio protectAhoCredServicio) {
		this.protectAhoCredServicio = protectAhoCredServicio;
	}
}
