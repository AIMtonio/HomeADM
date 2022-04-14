package pld.controlador;


import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import pld.bean.MatrizRiesgoBean;
import pld.servicio.MatrizRiesgoServicio;
import pld.servicio.MatrizRiesgoServicio.Enum_Lis_MatrizRiesgo;

@SuppressWarnings("deprecation")
public class MatrizRiesgoGridControlador extends AbstractCommandController{

	MatrizRiesgoServicio  matrizRiesgoServicio=null;
	
	public MatrizRiesgoGridControlador() {
		setCommandClass(MatrizRiesgoBean.class);
		setCommandName("conceptoMatriz");
	}
	
	@Override
	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors)
			throws Exception {
		
			List listaConceptosRiesgo=	matrizRiesgoServicio.lista(Enum_Lis_MatrizRiesgo.principal);
			return new ModelAndView("pld/matrizRiesgoGridVista", "listaResultado",listaConceptosRiesgo);
	}

	public MatrizRiesgoServicio getMatrizRiesgoServicio() {
		return matrizRiesgoServicio;
	}

	public void setMatrizRiesgoServicio(MatrizRiesgoServicio matrizRiesgoServicio) {
		this.matrizRiesgoServicio = matrizRiesgoServicio;
	}
	
	
}
