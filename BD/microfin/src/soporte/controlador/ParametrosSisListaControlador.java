package soporte.controlador;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.util.ArrayList;
import java.util.List;
import general.bean.MensajeTransaccionBean;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import soporte.bean.ParametrosSisBean;
import soporte.servicio.ParametrosSisServicio;;
public class ParametrosSisListaControlador extends AbstractCommandController{
	
	ParametrosSisServicio parametrosSisServicio = null;
	
	public ParametrosSisListaControlador() {
		setCommandClass(ParametrosSisBean.class);
		setCommandName("parametrosSisBean");
	}
		
	protected ModelAndView handle(HttpServletRequest request,
								  HttpServletResponse response,
								  Object command,
								  BindException errors) throws Exception {
		
	
		
		int tipoLista =(request.getParameter("tipoLista")!=null)?
				Integer.parseInt(request.getParameter("tipoLista")): 0;
				
		String controlID = request.getParameter("controlID");
		
		ParametrosSisBean parametrosSisBean = (ParametrosSisBean) command;
		List parametrosSis =parametrosSisServicio.lista(tipoLista, parametrosSisBean);
		
		List listaResultado = (List)new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(controlID);
		listaResultado.add(parametrosSis);
		
		return new ModelAndView("soporte/parametrosSisListaVista", "listaResultado",listaResultado);
	}

	public void setParametrosSisServicio(ParametrosSisServicio parametrosSisServicio) {
		this.parametrosSisServicio = parametrosSisServicio;
	}
	
	
}
