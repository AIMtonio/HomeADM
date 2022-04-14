package originacion.controlador;

import org.springframework.web.servlet.mvc.AbstractCommandController;
import java.util.List;
import java.util.ArrayList;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;

import originacion.bean.TiposNotasCargoBean;
import originacion.servicio.TiposNotasCargoServicio;

public class TiposNotasCargoListaControlador extends AbstractCommandController {

	private TiposNotasCargoServicio tiposNotasCargoServicio = null;

	public TiposNotasCargoListaControlador(){
		setCommandClass(TiposNotasCargoBean.class);
		setCommandName("tiposNotasCargoBean");
	}

	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {

		String tp=request.getParameter("tipoLista");

		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));

		String controlID = request.getParameter("controlID");
		   
		TiposNotasCargoBean tiposNotasCargoBean = (TiposNotasCargoBean) command;
		
		List<?> listaTiposNotasCargo = tiposNotasCargoServicio.lista(tipoLista, tiposNotasCargoBean);
		
		List listaResultado = (List)new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(controlID);
		listaResultado.add(listaTiposNotasCargo);
            
		return new ModelAndView("originacion/tiposNotasCargoListaVista", "listaResultado", listaResultado);
	}

	public TiposNotasCargoServicio getTiposNotasCargoServicio() {
		return tiposNotasCargoServicio;
	}

	public void setTiposNotasCargoServicio(
			TiposNotasCargoServicio tiposNotasCargoServicio) {
		this.tiposNotasCargoServicio = tiposNotasCargoServicio;
	}

}
