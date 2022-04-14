package soporte.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import soporte.bean.RelacionadosFiscalesBean;
import soporte.servicio.RelacionadosFiscalesServicio;

public class RelacionadosFisGridControlador extends AbstractCommandController{
	private RelacionadosFiscalesServicio relacionadosFiscalesServicio = null;
	
	public RelacionadosFisGridControlador(){
		setCommandClass(RelacionadosFiscalesBean.class);
		setCommandName("relacionadosFiscalesBean");			
	}
	
	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {	
		
		RelacionadosFiscalesBean bean = (RelacionadosFiscalesBean)command;
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		List listaResultado = new ArrayList();
		List listaBean = relacionadosFiscalesServicio.listaRelacionadosFiscalsGrid(tipoLista,bean);
		
		listaResultado.add(listaBean);		
		
		return new ModelAndView("soporte/relacionadosFiscalesGridVista", "listaResultado", listaResultado);
	}

	public RelacionadosFiscalesServicio getRelacionadosFiscalesServicio() {
		return relacionadosFiscalesServicio;
	}

	public void setRelacionadosFiscalesServicio(
			RelacionadosFiscalesServicio relacionadosFiscalesServicio) {
		this.relacionadosFiscalesServicio = relacionadosFiscalesServicio;
	}
}
