package seguimiento.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import seguimiento.bean.SegtoResultadosBean;
import seguimiento.servicio.SegtoResultadosServicio;


public class SegtoResultadosListaControlador  extends AbstractCommandController  {


	SegtoResultadosServicio segtoResultadosServicio= null;

	public SegtoResultadosListaControlador(){
 		setCommandClass(SegtoResultadosBean.class);
		setCommandName("segtoResultadosBean");
	}
	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {

 		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
        String controlID = request.getParameter("controlID");
        
        SegtoResultadosBean segtoResultadosBean = (SegtoResultadosBean) command;
        List listaResultadosSegto = segtoResultadosServicio.lista(tipoLista, segtoResultadosBean);
        
        List listaResultado = (List)new ArrayList();
        listaResultado.add(tipoLista);
        listaResultado.add(controlID);
        listaResultado.add(listaResultadosSegto);
        return new ModelAndView("seguimiento/segtoResultadosListaVista", "listaResultado", listaResultado);
 	}
	
	public SegtoResultadosServicio getSegtoResultadosServicio() {
		return segtoResultadosServicio;
	}
	public void setSegtoResultadosServicio(
			SegtoResultadosServicio segtoResultadosServicio) {
		this.segtoResultadosServicio = segtoResultadosServicio;
	}	
}
