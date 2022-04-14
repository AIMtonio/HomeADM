package tarjetas.controlador;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import tarjetas.bean.TarDebGirosAcepIndividualBean;
import tarjetas.servicio.TarDebGirosAcepIndividualServicio;

public class TarDebGirosIndivGridControlador extends AbstractCommandController{
	TarDebGirosAcepIndividualServicio  tarDebGirosAcepIndividualServicio= null;
	
	public TarDebGirosIndivGridControlador() {
		setCommandClass(TarDebGirosAcepIndividualBean.class);
		setCommandName("girosTarjeta");
	}
		
	protected ModelAndView handle(HttpServletRequest request,
								  HttpServletResponse response,
								  Object command,
								  BindException errors) throws Exception {	
		
		TarDebGirosAcepIndividualBean tarDebGirosAcepIndividualBean = (TarDebGirosAcepIndividualBean) command;
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		List listaResultado = tarDebGirosAcepIndividualServicio.lista(tipoLista, tarDebGirosAcepIndividualBean);

		return new ModelAndView("tarjetas/tarDebGirosIndGridVista", "listaResultado", listaResultado);
	}
//------------------setter-------------
	public void setTarDebGirosAcepIndividualServicio(
			TarDebGirosAcepIndividualServicio tarDebGirosAcepIndividualServicio) {
		this.tarDebGirosAcepIndividualServicio = tarDebGirosAcepIndividualServicio;
	}
	
	
	
}
