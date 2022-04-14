package tarjetas.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import com.google.gson.Gson;

import tarjetas.bean.TarBinParamsBean;
import tarjetas.servicio.TarBinParamsServicio;

public class TarParametrosBINListaControlador extends AbstractCommandController{
	
	TarBinParamsServicio tarjetaBinParamsServicio = null;
	
	public TarParametrosBINListaControlador(){
		setCommandClass(TarBinParamsBean.class);
		setCommandName("tarBinParamsBean");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {
		
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		String controlID = request.getParameter("controlID");
		
		TarBinParamsBean tarBinParamsBean = (TarBinParamsBean) command;
		List listTarBinParams = tarjetaBinParamsServicio.lista(tipoLista, tarBinParamsBean);
		
		List listaResultado = (List)new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(controlID);
		listaResultado.add(listTarBinParams);
		
		return new ModelAndView("tarjetas/tarParametrosBINListaVista", "listaResultado", listaResultado);
	}

	public TarBinParamsServicio getTarjetaBinParamsServicio() {
		return tarjetaBinParamsServicio;
	}

	public void setTarjetaBinParamsServicio(
			TarBinParamsServicio tarjetaBinParamsServicio) {
		this.tarjetaBinParamsServicio = tarjetaBinParamsServicio;
	}

}
