package regulatorios.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import regulatorios.bean.AcreditadoRelBean;
import regulatorios.servicio.AcreditadoRelServicio;

public class AcreditadoRelGridControlador extends AbstractCommandController{
	AcreditadoRelServicio acreditadoRelServicio = null;
	
	public AcreditadoRelGridControlador(){
		setCommandClass(AcreditadoRelBean.class);
		setCommandName("acreditadosRelBean");			
	}

	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
		
		AcreditadoRelBean bean = (AcreditadoRelBean)command;
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));	

		List listaResultado = new ArrayList();
		List listaAcreditados = acreditadoRelServicio.listaAcreditadosRelGrid(tipoLista);
		
		listaResultado.add(tipoLista);
		listaResultado.add(listaAcreditados);
		
		return new ModelAndView("regulatorios/acreditadoRelGridVista", "listaResultado", listaResultado);
	}
	
	public AcreditadoRelServicio getAcreditadoRelServicio() {
		return acreditadoRelServicio;
	}
	public void setAcreditadoRelServicio(AcreditadoRelServicio acreditadoRelServicio) {
		this.acreditadoRelServicio = acreditadoRelServicio;
	}
}
