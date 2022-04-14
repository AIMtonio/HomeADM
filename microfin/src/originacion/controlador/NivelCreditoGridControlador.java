package originacion.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import originacion.bean.NivelCreditoBean;
import originacion.servicio.NivelCreditoServicio;

public class NivelCreditoGridControlador extends AbstractCommandController{
	NivelCreditoServicio nivelCreditoServicio = null;
	
	public NivelCreditoGridControlador(){
		setCommandClass(NivelCreditoBean.class);
		setCommandName("nivelCreditoBean");			
	}

	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
		
		NivelCreditoBean bean = (NivelCreditoBean)command;
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));	

		List listaResultado = new ArrayList();
		List parametrosList = nivelCreditoServicio.lista(tipoLista,bean);
		
		listaResultado.add(tipoLista);
		listaResultado.add(parametrosList);
		
		return new ModelAndView("originacion/nivelCreditoGridVista", "listaResultado", listaResultado);
	}	
	
	public NivelCreditoServicio getNivelCreditoServicio() {
		return nivelCreditoServicio;
	}

	public void setNivelCreditoServicio(NivelCreditoServicio nivelCreditoServicio) {
		this.nivelCreditoServicio = nivelCreditoServicio;
	}

}
