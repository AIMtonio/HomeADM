package pld.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import pld.bean.MotivosPreoBean;
import pld.bean.ProcInternosBean;
import pld.servicio.MotivosPreoServicio;
import pld.servicio.ProcInternosServicio;

public class ProcInternosListaControlador extends AbstractCommandController{
	
	ProcInternosServicio procInternosServicio = null;

			public ProcInternosListaControlador() {
					setCommandClass(ProcInternosBean.class);
					setCommandName("procInternos");
			}

			protected ModelAndView handle(HttpServletRequest request,
						HttpServletResponse response,
						Object command,
						BindException errors) throws Exception {


			int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
				String controlID = request.getParameter("controlID");

				ProcInternosBean procInternos = (ProcInternosBean) command;
				List procInternosList =	procInternosServicio.lista(tipoLista, procInternos);

				List listaResultado = (List)new ArrayList();
				listaResultado.add(tipoLista);
				listaResultado.add(controlID);
				listaResultado.add(procInternosList);

		return new ModelAndView("pld/procInternosListaVista", "listaResultado", listaResultado);
		}


		public void setProcInternosServicio(
				ProcInternosServicio procInternosServicio) {
				this.procInternosServicio = procInternosServicio;
		}

	}

