package originacion.controlador;


import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import originacion.bean.ConsolidacionCartaLiqBean;
import originacion.servicio.ConsolidacionCartaLiqServicio;

public class ConsolidacionListaControlador extends AbstractCommandController{
	ConsolidacionCartaLiqServicio consolidaCartaLiqServicio = null; 
	
	public ConsolidacionListaControlador (){
		setCommandClass(ConsolidacionCartaLiqBean.class);
		setCommandName("consolidaCartas");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
								HttpServletResponse response,
								Object command,
								BindException errors)throws Exception{
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		String controlID=request.getParameter("controlID");
		
		ConsolidacionCartaLiqBean consolida = (ConsolidacionCartaLiqBean) command;
		System.out.println("ConsolidacionID:"+consolida.getConsolidacionCartaID());
		List consolidaciones = consolidaCartaLiqServicio.listaCon(tipoLista, consolida);
		List listaResultado = (List)new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(controlID);
		listaResultado.add(consolidaciones); 
		
		return new ModelAndView("originacion/consolidacionListaVista", "listaResultado", listaResultado);	
	}
	
	public void setConsolidaCartaLiqServicio (ConsolidacionCartaLiqServicio consolidaServicio){
		this.consolidaCartaLiqServicio = consolidaServicio;
	}
}
