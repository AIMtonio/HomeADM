package contabilidad.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import contabilidad.servicio.ProrrateoContableServicio;
import contabilidad.bean.ProrrateoContableBean;

public class ProrrateoContableListaControlador extends AbstractCommandController{
		ProrrateoContableServicio prorrateoContableServicio = null;
		
		public ProrrateoContableListaControlador(){
			setCommandClass(ProrrateoContableBean.class);
			setCommandName("prorrateoContab");
		}
		
		protected ModelAndView handle(HttpServletRequest request, HttpServletResponse response, Object command,BindException errors)
									throws Exception{
			int tipoLista=Integer.parseInt(request.getParameter("tipoLista"));
			String controlID=request.getParameter("controlID");
			
			ProrrateoContableBean prorrateoContableBean= (ProrrateoContableBean) command;
			List prorrateoConta=prorrateoContableServicio.lista(tipoLista, prorrateoContableBean);
			List listaResultado = (List)new ArrayList();
			
			listaResultado.add(tipoLista);
			listaResultado.add(controlID);
			listaResultado.add(prorrateoConta);
			
			return new ModelAndView("contabilidad/prorrateoContableListaVista", "listaResultado", listaResultado);
		}

		public void setProrrateoContableServicio(ProrrateoContableServicio prorrateoContableServicio) {
			this.prorrateoContableServicio = prorrateoContableServicio;
		}
		
}
