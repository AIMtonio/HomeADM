package seguimiento.controlador; 

 import java.util.ArrayList;
import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import seguimiento.bean.SegtoRealizadosBean;
import seguimiento.servicio.SegtoRealizadosServicio;

 public class SegtoRealizadosListaControlador extends AbstractCommandController {

	SegtoRealizadosServicio segtoRealizadosServicio = null;

 	public SegtoRealizadosListaControlador(){
 		setCommandClass(SegtoRealizadosBean.class);
 		setCommandName("segtoRealizadosBean");
 	}

	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {

 		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
        String controlID = request.getParameter("controlID");
        
        SegtoRealizadosBean segtoRealizadosBean = (SegtoRealizadosBean) command;
         List listaSegtoResultado = segtoRealizadosServicio.lista(tipoLista, segtoRealizadosBean);
         
         List listaResultado = (List)new ArrayList();
         listaResultado.add(tipoLista);
         listaResultado.add(controlID);
         listaResultado.add(listaSegtoResultado);
 		return new ModelAndView("seguimiento/segtoRealizadoListaVista", "listaResultado", listaResultado);
 	}

	public SegtoRealizadosServicio getSegtoRealizadosServicio() {
		return segtoRealizadosServicio;
	}

	public void setSegtoRealizadosServicio(
			SegtoRealizadosServicio segtoRealizadosServicio) {
		this.segtoRealizadosServicio = segtoRealizadosServicio;
	}
	
 } 