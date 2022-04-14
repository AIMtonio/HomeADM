package pld.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import pld.bean.OpeInusualesBean;
import pld.bean.ParametrosAlertasBean;
import pld.servicio.OpeInusualesServicio;
import pld.servicio.ParametrosAlertasServicio;

public class OpeInusualesListaControlador  extends AbstractCommandController{
	
	OpeInusualesServicio opeInusualesServicio = null;

			public OpeInusualesListaControlador() {
					setCommandClass(OpeInusualesBean.class);
					setCommandName("opInusu");
			}

			protected ModelAndView handle(HttpServletRequest request,
						HttpServletResponse response,
						Object command,
						BindException errors) throws Exception {


			int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
				String controlID = request.getParameter("controlID");

				OpeInusualesBean inusuales = (OpeInusualesBean) command;
				List inusualesList =	opeInusualesServicio.lista(tipoLista, inusuales);

				List listaResultado = (List)new ArrayList();
				listaResultado.add(tipoLista);
				listaResultado.add(controlID);
				listaResultado.add(inusualesList);

		return new ModelAndView("pld/opeInusualesListaVista", "listaResultado", listaResultado);
		}

			public void setOpeInusualesServicio(OpeInusualesServicio opeInusualesServicio) {
				this.opeInusualesServicio = opeInusualesServicio;
			}
			
			/*public void setopInusualesServicio(
					OpeInusualesServicio opeInusualesServicio) {
				this.opeInusualesServicio = opeInusualesServicio;
			}*/
			
		
	}
