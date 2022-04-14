package fondeador.controlador;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import fondeador.bean.CondicionesDesctoDestLinFonBean;
import fondeador.servicio.CondicionesDesctoDestLinFonServicio;

public class CondicionesDesctoDestLinFonGridControlador extends AbstractCommandController{
		
	CondicionesDesctoDestLinFonServicio condicionesDesctoDestLinFonServicio = null;
	public CondicionesDesctoDestLinFonGridControlador() {
		setCommandClass(CondicionesDesctoDestLinFonBean.class);
		setCommandName("condicionesDesctoDestLinFonBean");
	}
		
	protected ModelAndView handle(HttpServletRequest request,
								  HttpServletResponse response,
								  Object command,
								  BindException errors) throws Exception {			
		CondicionesDesctoDestLinFonBean condicionesDesctoDestLinFonBean = (CondicionesDesctoDestLinFonBean) command;
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		
		List listaCondiciones = condicionesDesctoDestLinFonServicio.lista(tipoLista, condicionesDesctoDestLinFonBean);
		List listaResultado = (List)new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(listaCondiciones);
	
		return new ModelAndView("fondeador/condicionesDesctoDestLinFonGridVista", "listaResultado", listaResultado);
	}

	public CondicionesDesctoDestLinFonServicio getCondicionesDesctoDestLinFonServicio() {
		return condicionesDesctoDestLinFonServicio;
	}

	public void setCondicionesDesctoDestLinFonServicio(
			CondicionesDesctoDestLinFonServicio condicionesDesctoDestLinFonServicio) {
		this.condicionesDesctoDestLinFonServicio = condicionesDesctoDestLinFonServicio;
	}
}

