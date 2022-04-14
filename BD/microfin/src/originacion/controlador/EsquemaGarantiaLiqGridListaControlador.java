package originacion.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import originacion.bean.EsquemaGarantiaLiqBean;
import originacion.servicio.EsquemaGarantiaLiqServicio;

public class EsquemaGarantiaLiqGridListaControlador extends AbstractCommandController{
	EsquemaGarantiaLiqServicio esquemaGarantiaLiqServicio = null;

	public EsquemaGarantiaLiqGridListaControlador() {
		setCommandClass(EsquemaGarantiaLiqBean.class);
		setCommandName("esquemaGarantiaLiqBean");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
							  HttpServletResponse response,
							  Object command,
							  BindException errors) throws Exception {
	
		EsquemaGarantiaLiqBean bean = (EsquemaGarantiaLiqBean) command;
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		String bonifica = request.getParameter("bonificaFOGA");
		
		List listEsquemas = esquemaGarantiaLiqServicio.lista(bean,tipoLista);
	
		List listaResultado = new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(listEsquemas);
		listaResultado.add(bonifica);

		
		return new ModelAndView("originacion/esquemaGarantiaLiqGridVista", "listaResultado", listaResultado);
	
	}

	public EsquemaGarantiaLiqServicio getEsquemaGarantiaLiqServicio() {
		return esquemaGarantiaLiqServicio;
	}

	public void setEsquemaGarantiaLiqServicio(
			EsquemaGarantiaLiqServicio esquemaGarantiaLiqServicio) {
		this.esquemaGarantiaLiqServicio = esquemaGarantiaLiqServicio;
	}
	
}
