package fondeador.controlador;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import fondeador.bean.CondicionesDesctoEdoLinFonBean;
import fondeador.servicio.CondicionesDesctoEdoLinFonServicio;

public class CondicionesDesctoEdoLinFonGridControlador extends AbstractCommandController{
		
	CondicionesDesctoEdoLinFonServicio  condicionesDesctoEdoLinFonServicio = null;
	public CondicionesDesctoEdoLinFonGridControlador() {
		setCommandClass(CondicionesDesctoEdoLinFonBean.class);
		setCommandName("condicionesDesctoEdoLinFonBean");
	}
		
	protected ModelAndView handle(HttpServletRequest request,
								  HttpServletResponse response,
								  Object command,
								  BindException errors) throws Exception {	
		
		CondicionesDesctoEdoLinFonBean condicionesDesctoEdoLinFonBean = (CondicionesDesctoEdoLinFonBean) command;
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		
		List listaCondiciones = condicionesDesctoEdoLinFonServicio.lista(tipoLista, condicionesDesctoEdoLinFonBean);
		List listaResultado = (List)new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(listaCondiciones);
	
		return new ModelAndView("fondeador/condicionesDesctoEdoLinFonGridVista", "listaResultado", listaResultado);
	}

	public CondicionesDesctoEdoLinFonServicio getCondicionesDesctoEdoLinFonServicio() {
		return condicionesDesctoEdoLinFonServicio;
	}

	public void setCondicionesDesctoEdoLinFonServicio(
			CondicionesDesctoEdoLinFonServicio condicionesDesctoEdoLinFonServicio) {
		this.condicionesDesctoEdoLinFonServicio = condicionesDesctoEdoLinFonServicio;
	}	
}

