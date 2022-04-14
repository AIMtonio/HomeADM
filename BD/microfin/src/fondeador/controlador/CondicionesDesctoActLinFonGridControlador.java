package fondeador.controlador;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import fondeador.bean.CondicionesDesctoActLinFonBean;
import fondeador.servicio.CondicionesDesctoActLinFonServicio;

public class CondicionesDesctoActLinFonGridControlador extends AbstractCommandController{
		
	CondicionesDesctoActLinFonServicio condicionesDesctoActLinFonServicio = null;
	
	public CondicionesDesctoActLinFonGridControlador() {
		setCommandClass(CondicionesDesctoActLinFonBean.class);
		setCommandName("condicionesDesctoActLinFonBean");
	}
		
	protected ModelAndView handle(HttpServletRequest request,
								  HttpServletResponse response,
								  Object command,
								  BindException errors) throws Exception {			
		CondicionesDesctoActLinFonBean condicionesDesctoActLinFonBean = (CondicionesDesctoActLinFonBean) command;
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		List listaCondiciones = condicionesDesctoActLinFonServicio.lista(tipoLista, condicionesDesctoActLinFonBean);
		List listaResultado = (List)new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(listaCondiciones);
	
		return new ModelAndView("fondeador/condicionesDesctoActLinFonGridVista", "listaResultado", listaResultado);
	}

	public CondicionesDesctoActLinFonServicio getCondicionesDesctoActLinFonServicio() {
		return condicionesDesctoActLinFonServicio;
	}

	public void setCondicionesDesctoActLinFonServicio(
			CondicionesDesctoActLinFonServicio condicionesDesctoActLinFonServicio) {
		this.condicionesDesctoActLinFonServicio = condicionesDesctoActLinFonServicio;
	}

}

