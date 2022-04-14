package nomina.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import nomina.bean.NomClasifClavePresupBean;
import nomina.servicio.NomClasifClavePresupServicio;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

public class CrearFromulaClaveGridControlador extends AbstractCommandController{
	private NomClasifClavePresupServicio nomClasifClavePresupServicio = null;
	
	public CrearFromulaClaveGridControlador() {
		setCommandClass(NomClasifClavePresupBean.class);
		setCommandName("nomClasifClavePresupBean");
	}
	
	@Override
	protected ModelAndView handle(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {
			
		NomClasifClavePresupBean clasificacionClavePresup = (NomClasifClavePresupBean) command;
		
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		
		List claveLis = nomClasifClavePresupServicio.lista(tipoLista, clasificacionClavePresup);
		 
		List listaResultado = (List)new ArrayList();
		
		listaResultado.add(tipoLista); // 0
		listaResultado.add(claveLis); // 1
		
		return new ModelAndView("nomina/crearFromulaClaveGridVista", "listaResultado", listaResultado);
	}

	public NomClasifClavePresupServicio getNomClasifClavePresupServicio() {
		return nomClasifClavePresupServicio;
	}

	public void setNomClasifClavePresupServicio(
			NomClasifClavePresupServicio nomClasifClavePresupServicio) {
		this.nomClasifClavePresupServicio = nomClasifClavePresupServicio;
	}

	
}
