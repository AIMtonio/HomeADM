package seguimiento.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;


import seguimiento.bean.SegtoRecomendasBean;
import seguimiento.servicio.SegtoRecomendasServicio;


	public class SegtoRecomendaListaControlador  extends AbstractCommandController {

		SegtoRecomendasServicio segtoRecomendasServicio= null;

		public SegtoRecomendaListaControlador(){
	 		setCommandClass(SegtoRecomendasBean.class);
			setCommandName("segtoRecomendasBean");
		}
		protected ModelAndView handle(HttpServletRequest request,
				  HttpServletResponse response,
				  Object command,
				  BindException errors) throws Exception {

	 		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
	        String controlID = request.getParameter("controlID");
	        
	        SegtoRecomendasBean segtoRecomendasBean = (SegtoRecomendasBean) command;
	        List listaRecomendaSegto = segtoRecomendasServicio.lista(tipoLista, segtoRecomendasBean);
	        
	        List listaResultado = (List)new ArrayList();
	        listaResultado.add(tipoLista);
	        listaResultado.add(controlID);
	        listaResultado.add(listaRecomendaSegto);
	        return new ModelAndView("seguimiento/segtoRecomendaListaVista", "listaResultado", listaResultado);
	 	}
		

	 	public SegtoRecomendasServicio getSegtoRecomendasServicio() {
			return segtoRecomendasServicio;
		}
		public void setSegtoRecomendasServicio(
				SegtoRecomendasServicio segtoRecomendasServicio) {
			this.segtoRecomendasServicio = segtoRecomendasServicio;
		}
	}