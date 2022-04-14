package cliente.controlador;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;
import credito.bean.AvalesBean;
import credito.servicio.AvalesServicio;

public class ResumenAvalesClienteGridControlador extends AbstractCommandController{
	
	AvalesServicio avalesServicio = null;

	public ResumenAvalesClienteGridControlador() {
		setCommandClass(AvalesBean.class);
		setCommandName("avalesBean");
	}

	protected ModelAndView handle(HttpServletRequest request,
							  HttpServletResponse response,
							  Object command,
							  BindException errors) throws Exception {
	
		AvalesBean bean = (AvalesBean) command;
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		List listResultado = avalesServicio.lista(tipoLista,bean);
	
		List listaResultado = new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(listResultado);
		
		return new ModelAndView("cliente/clienteAvalesGridVista", "listaResultado", listaResultado);
	
	}

	public AvalesServicio getAvalesServicio() {
		return avalesServicio;
	}

	public void setAvalesServicio(AvalesServicio avalesServicio) {
		this.avalesServicio = avalesServicio;
	}

	
}