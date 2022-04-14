package tarjetas.controlador;


import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;


import tarjetas.bean.TarjetaDebitoBean;
import tarjetas.servicio.TarjetaDebitoServicio;


public class TarjetaDebListaControlador extends AbstractCommandController{
	TarjetaDebitoServicio tarjetaDebitoServicio = null;
	

 	public TarjetaDebListaControlador(){
 		setCommandClass(TarjetaDebitoBean.class);
 		setCommandName("tarjetaDebitoBean");
 	}

 	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {


 		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
        String controlID = request.getParameter("controlID");
        
        TarjetaDebitoBean tarjetaDebitoBean = (TarjetaDebitoBean) command;
                 List tiposTarjeta = tarjetaDebitoServicio.lista(tipoLista, tarjetaDebitoBean);
                 List listaResultado = (List)new ArrayList();
                 listaResultado.add(tipoLista);
                 listaResultado.add(controlID);
                 listaResultado.add(tiposTarjeta);
 		return new ModelAndView("tarjetas/tarDebListaVista", "listaResultado", listaResultado);
 	}

	public TarjetaDebitoServicio getTarjetaDebitoServicio() {
		return tarjetaDebitoServicio;
	}

	public void setTarjetaDebitoServicio(TarjetaDebitoServicio tarjetaDebitoServicio) {
		this.tarjetaDebitoServicio = tarjetaDebitoServicio;
	}



	

 } 