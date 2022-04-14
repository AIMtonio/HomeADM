package cuentas.controlador; 

import java.util.ArrayList;
import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import cuentas.bean.CobrosPendBean;
import cuentas.servicio.CobrosPendServicio;

 public class CobrosPendListaControlador extends AbstractCommandController {

	 CobrosPendServicio cobrosPendServicio = null;

 	public CobrosPendListaControlador(){
 		setCommandClass(CobrosPendBean.class);
 		setCommandName("cobrosPendBean");
 	}

	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {

 		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
        String controlID = request.getParameter("controlID");
        
        CobrosPendBean cobrosPendBean = (CobrosPendBean) command;
        List listaCobrosPendientes = cobrosPendServicio.lista(tipoLista, cobrosPendBean);
	     
        List listaResultado = (List)new ArrayList();
        listaResultado.add(tipoLista);
        listaResultado.add(controlID);
        listaResultado.add(listaCobrosPendientes);
 		return new ModelAndView("cuentas/cobrosPendListaVista", "listaResultado", listaResultado);
 	}

	public CobrosPendServicio getCobrosPendServicio() {
		return cobrosPendServicio;
	}

	public void setCobrosPendServicio(CobrosPendServicio cobrosPendServicio) {
		this.cobrosPendServicio = cobrosPendServicio;
	}
 } 
