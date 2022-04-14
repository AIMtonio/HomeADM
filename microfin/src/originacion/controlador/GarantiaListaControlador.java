package originacion.controlador;

import herramientas.Utileria;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;
 import originacion.servicio.GarantiaServicio;
 import originacion.bean.GarantiaBean;

public class GarantiaListaControlador extends AbstractCommandController{

	GarantiaServicio garantiaServicio = null;

	public GarantiaListaControlador(){
		setCommandClass(GarantiaBean.class);
		setCommandName("solicitudCredito");
	}

	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {

		String tp=request.getParameter("tipoLista");
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
       String controlID = request.getParameter("controlID");
       
       GarantiaBean garantiaBean = (GarantiaBean) command;
		
                List garantiasLista = garantiaServicio.lista(tipoLista, garantiaBean);
                		
                List listaResultado = (List)new ArrayList();
                listaResultado.add(tipoLista);
                listaResultado.add(controlID);
                listaResultado.add(garantiasLista);
                
		return new ModelAndView("originacion/garantiasListaVista", "listaResultado", listaResultado);
	}
	
	public void setGarantiaServicio(
			GarantiaServicio garantiaServicio) {
		this.garantiaServicio = garantiaServicio;
	}
	
}
