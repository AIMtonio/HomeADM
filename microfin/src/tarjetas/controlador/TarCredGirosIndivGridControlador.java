package tarjetas.controlador;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import tarjetas.bean.TarCredGirosAcepIndividualBean;
import tarjetas.servicio.TarCredGirosAcepIndividualServicio;


public class TarCredGirosIndivGridControlador extends AbstractCommandController{
	TarCredGirosAcepIndividualServicio  tarCredGirosAcepIndividualServicio= null;
	
	public TarCredGirosIndivGridControlador() {
		setCommandClass(TarCredGirosAcepIndividualBean.class);
		setCommandName("girosTarjeta");
	}
		
	protected ModelAndView handle(HttpServletRequest request,
								  HttpServletResponse response,
								  Object command,
								  BindException errors) throws Exception {	
		
		TarCredGirosAcepIndividualBean tarCredGirosAcepIndividualBean = (TarCredGirosAcepIndividualBean) command;
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		List listaResultado = tarCredGirosAcepIndividualServicio.lista(tipoLista, tarCredGirosAcepIndividualBean);

		return new ModelAndView("tarjetas/tarCredGirosIndGridVista", "listaResultado", listaResultado);
	}
//------------------setter-------------

	public TarCredGirosAcepIndividualServicio getTarCredGirosAcepIndividualServicio() {
		return tarCredGirosAcepIndividualServicio;
	}

	public void setTarCredGirosAcepIndividualServicio(
			TarCredGirosAcepIndividualServicio tarCredGirosAcepIndividualServicio) {
		this.tarCredGirosAcepIndividualServicio = tarCredGirosAcepIndividualServicio;
	}

	
	
	
}
