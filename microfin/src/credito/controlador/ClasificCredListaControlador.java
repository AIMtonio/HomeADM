package credito.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import credito.bean.ClasificCreditoBean;
import credito.servicio.ClasificCreditoServicio;

public class ClasificCredListaControlador extends AbstractCommandController {
	
	ClasificCreditoServicio clasificCreditoServicio = null;

	public ClasificCredListaControlador(){
		setCommandClass(ClasificCreditoBean.class);
		setCommandName("clasificacionCredito");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {

		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
     String controlID = request.getParameter("controlID");
     
     ClasificCreditoBean clasificCredito = (ClasificCreditoBean) command;
              List clasiCredito = clasificCreditoServicio.lista(tipoLista, clasificCredito);
              
              List listaResultado = (List)new ArrayList();
              listaResultado.add(tipoLista);
              listaResultado.add(controlID);
              listaResultado.add(clasiCredito);
		return new ModelAndView("credito/clasificCreditoListaVista", "listaResultado", listaResultado);
	}
	
	
	public void setClasificCreditoServicio(
			ClasificCreditoServicio clasificacionCreditoServicio) {
		this.clasificCreditoServicio = clasificacionCreditoServicio;
	}

}
