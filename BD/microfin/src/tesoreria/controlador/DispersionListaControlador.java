package tesoreria.controlador; 

import java.util.ArrayList;
import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import tesoreria.bean.DispersionBean;
import tesoreria.servicio.OperDispersionServicio;

 class DispersionListaControlador extends AbstractCommandController {

	 OperDispersionServicio operDispersionServicio = null;

 	public DispersionListaControlador(){
 		setCommandClass(DispersionBean.class);
 		setCommandName("operDispersion");
 	}

	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {

 		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
        String controlID = request.getParameter("controlID");
        
        DispersionBean dispersionBean = (DispersionBean) command;
        List dispersionList = operDispersionServicio.lista(tipoLista, dispersionBean);
	     
	    List listaResultado = (List)new ArrayList();
	    listaResultado.add(tipoLista);
	    listaResultado.add(controlID);
	    listaResultado.add(dispersionList);
 		return new ModelAndView("tesoreria/dispersionListaVista", "listaResultado", listaResultado);
 	}
	public void setOperDispersionServicio(
			OperDispersionServicio operDispersionServicio) {
		this.operDispersionServicio = operDispersionServicio;
	} 	
 } 
