package regulatorios.controlador;


import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import general.bean.MensajeTransaccionBean;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import regulatorios.bean.OpcionesMenuRegBean;
import regulatorios.servicio.OpcionesMenuRegServicio;

public class OpcionesMenuRegListaControlador extends AbstractCommandController {

	OpcionesMenuRegServicio opcionesMenuRegServicio = null;

	public OpcionesMenuRegListaControlador(){
		setCommandClass(OpcionesMenuRegBean.class);
		setCommandName("opcionesMenuRegBean");
	}

	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {

		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		String controlID = request.getParameter("controlID");
		
		OpcionesMenuRegBean opcionesMenuRegBean = (OpcionesMenuRegBean) command;
                List listaMenu = opcionesMenuRegServicio.lista(tipoLista, opcionesMenuRegBean);
                
                List listaResultado = (List)new ArrayList();
                listaResultado.add(tipoLista);
                listaResultado.add(controlID);
                listaResultado.add(listaMenu);
		return new ModelAndView("regulatorios/opcionesMenuRegListaVista", "listaResultado", listaResultado);
	}

	public void setOpcionesMenuRegServicio(
			OpcionesMenuRegServicio opcionesMenuRegServicio) {
		this.opcionesMenuRegServicio = opcionesMenuRegServicio;
	}
	     

	
} 

