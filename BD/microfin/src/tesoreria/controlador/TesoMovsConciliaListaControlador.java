package tesoreria.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import tesoreria.bean.TesoMovsArchConciliaBean;
import tesoreria.servicio.TesoMovsConciliaServicio;

import credito.bean.TasasBaseBean;
@SuppressWarnings("deprecation")
public class TesoMovsConciliaListaControlador extends AbstractCommandController {
	TesoMovsConciliaServicio tesoMovsConciliaServicio = null;
	
	public TesoMovsConciliaListaControlador(){
		setCommandClass(TesoMovsArchConciliaBean.class);
		setCommandName("tesoMovsConciliaBean");
	}

	@Override
	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {

	int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
    String controlID = request.getParameter("controlID");
         
    TesoMovsArchConciliaBean tesoMovsConcBean = (TesoMovsArchConciliaBean) command;
              List tesoMovsConc = tesoMovsConciliaServicio.listaCuentasAhoTeso(tipoLista, tesoMovsConcBean);
              
              List listaResultado = (List)new ArrayList();
              listaResultado.add(tipoLista);
              listaResultado.add(controlID);
              listaResultado.add(tesoMovsConc);
              
		return new ModelAndView("tesoreria/TesoMovsConciliaListaVista", "listaResultado", listaResultado);
	}
	
	public void setTesoMovsConciliaServicio(TesoMovsConciliaServicio tesoMovsConciliaServicio) {
		this.tesoMovsConciliaServicio = tesoMovsConciliaServicio;
	}

}
