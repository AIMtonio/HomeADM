package spei.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import spei.bean.ConsultaSpeiBean;
import spei.bean.SpeiRecepcionesPenBitBean;
import spei.servicio.SpeiRecepcionesPenBitServicio;



public class SpeiRecepcionesPenBitGridControlador extends AbstractCommandController{

	private SpeiRecepcionesPenBitServicio speiRecepcionesPenBitServicio = null;

	public SpeiRecepcionesPenBitGridControlador() {
		setCommandClass(SpeiRecepcionesPenBitBean.class);
		setCommandName("speiRecepcionesPenBitBean");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
							  HttpServletResponse response,
							  Object command,
							  BindException errors) throws Exception {
		
		SpeiRecepcionesPenBitBean consultaSpeiBean = (SpeiRecepcionesPenBitBean) command;
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		List consultaSpeiList = speiRecepcionesPenBitServicio.lista(tipoLista, consultaSpeiBean);
		System.out.println("Total registros:" + consultaSpeiList.size());
	
		List listaResultado = new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(consultaSpeiList);
		
		return new ModelAndView("spei/speiRecepcionesPenBitGridVista", "listaResultado", listaResultado);
	
	}

	public SpeiRecepcionesPenBitServicio getSpeiRecepcionesPenBitServicio() {
		return speiRecepcionesPenBitServicio;
	}

	public void setSpeiRecepcionesPenBitServicio(SpeiRecepcionesPenBitServicio speiRecepcionesPenBitServicio) {
		this.speiRecepcionesPenBitServicio = speiRecepcionesPenBitServicio;
	}
}

