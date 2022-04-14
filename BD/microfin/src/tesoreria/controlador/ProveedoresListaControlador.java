package tesoreria.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import tesoreria.bean.ProveedoresBean;
import tesoreria.bean.TipoGasBean;
import tesoreria.servicio.ProveedoresServicio;
import tesoreria.servicio.TipoGasServicio;

public class ProveedoresListaControlador extends AbstractCommandController{
	
	ProveedoresServicio proveedoresServicio = null;

			public ProveedoresListaControlador() {
					setCommandClass(ProveedoresBean.class);
					setCommandName("proveedores");
			}

			protected ModelAndView handle(HttpServletRequest request,
						HttpServletResponse response,
						Object command,
						BindException errors) throws Exception {


			int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
				String controlID = request.getParameter("controlID");

				ProveedoresBean proveedores = (ProveedoresBean) command;
				List proveedoresList =	proveedoresServicio.lista(tipoLista, proveedores);

				List listaResultado = (List)new ArrayList();
				listaResultado.add(tipoLista);
				listaResultado.add(controlID);
				listaResultado.add(proveedoresList);

		return new ModelAndView("tesoreria/proveedoresListaVista", "listaResultado", listaResultado);
		}


		public void setProveedoresServicio(
				ProveedoresServicio proveedoresServicio) {
				this.proveedoresServicio = proveedoresServicio;
		}

	}
