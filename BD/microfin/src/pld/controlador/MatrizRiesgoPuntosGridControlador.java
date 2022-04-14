package pld.controlador;

import herramientas.Utileria;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import pld.bean.MatrizRiesgoPuntosBean;
import pld.servicio.MatrizRiesgoPuntosServicio;

public class MatrizRiesgoPuntosGridControlador extends AbstractCommandController {
	MatrizRiesgoPuntosServicio	matrizRiesgoPuntosServicio	= null;
	
	public MatrizRiesgoPuntosGridControlador() {
		setCommandClass(MatrizRiesgoPuntosBean.class);
		setCommandName("matrizRiesgoPuntos");
	}
	
	@Override
	protected ModelAndView handle(HttpServletRequest request, HttpServletResponse response, Object command, org.springframework.validation.BindException errors) throws Exception {
		List listaResultado = (List) new ArrayList();
		try {
			MatrizRiesgoPuntosBean bean = (MatrizRiesgoPuntosBean) command;
			int tipoLista = Utileria.convierteEntero(request.getParameter("tipoLista"));
			double total = 0;
			String conceptoDesc="";
			String tipoPersona="T";
			List<MatrizRiesgoPuntosBean> lista = matrizRiesgoPuntosServicio.lista(tipoLista, bean);
			
			listaResultado.add(tipoLista);
			listaResultado.add(lista);
			if (lista != null && !lista.isEmpty()) {
				total = Utileria.convierteDoble(lista.get(0).getTotal());
				conceptoDesc=lista.get(0).getConceptoDesc();
				tipoPersona=lista.get(0).getTipoPersona();
			}
			listaResultado.add(total);
			listaResultado.add(conceptoDesc);
			listaResultado.add(tipoPersona);
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return new ModelAndView("pld/matrizRiesgoPuntosGridVista", "listaResultado", listaResultado);
	}

	public MatrizRiesgoPuntosServicio getMatrizRiesgoPuntosServicio() {
		return matrizRiesgoPuntosServicio;
	}

	public void setMatrizRiesgoPuntosServicio(MatrizRiesgoPuntosServicio matrizRiesgoPuntosServicio) {
		this.matrizRiesgoPuntosServicio = matrizRiesgoPuntosServicio;
	}
	

}
