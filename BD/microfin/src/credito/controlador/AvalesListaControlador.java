package credito.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import credito.bean.AvalesBean;
import credito.servicio.AvalesServicio;

public class AvalesListaControlador  extends AbstractCommandController{
	
	AvalesServicio avalesServicio = null;

			public AvalesListaControlador() {
					setCommandClass(AvalesBean.class);
					setCommandName("avalesLis");
			}

			protected ModelAndView handle(HttpServletRequest request,
						HttpServletResponse response,
						Object command,
						BindException errors) throws Exception {


			int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
				String controlID = request.getParameter("controlID");

				AvalesBean avales = (AvalesBean) command;
				List avalesList =	avalesServicio.lista(tipoLista, avales);

				List listaResultado = (List)new ArrayList();
				listaResultado.add(tipoLista);
				listaResultado.add(controlID);
				listaResultado.add(avalesList);

		return new ModelAndView("credito/avalesListaVista", "listaResultado", listaResultado);
		}

			public void setAvalesServicio(AvalesServicio avalesServicio) {
				this.avalesServicio = avalesServicio;
			}

			


		
	}
