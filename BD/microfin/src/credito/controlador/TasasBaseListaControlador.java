package credito.controlador;


import java.util.ArrayList;
import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import general.bean.MensajeTransaccionBean;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import credito.bean.TasasBaseBean;
import credito.servicio.TasasBaseServicio;

public class TasasBaseListaControlador extends AbstractCommandController {

	TasasBaseServicio tasasBaseServicio = null;

	public TasasBaseListaControlador(){
		setCommandClass(TasasBaseBean.class);
		setCommandName("tasasBaseBean");
	}

	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {

		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
       String controlID = request.getParameter("controlID");
       
       TasasBaseBean tasasBaseBean = (TasasBaseBean) command;
                List tasasBase = tasasBaseServicio.lista(tipoLista, tasasBaseBean);
                
                List listaResultado = (List)new ArrayList();
                listaResultado.add(tipoLista);
                listaResultado.add(controlID);
                listaResultado.add(tasasBase);
		return new ModelAndView("credito/tasasBaseListaVista", "listaResultado", listaResultado);
	}

	public void setTasasBaseServicio(TasasBaseServicio tasasBaseServicio){
                    this.tasasBaseServicio = tasasBaseServicio;
	}
} 

