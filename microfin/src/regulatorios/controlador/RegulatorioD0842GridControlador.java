package regulatorios.controlador;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import regulatorios.servicio.RegulatorioD0842Servicio;
import regulatorios.bean.RegulatorioD0842Bean;
;

public class RegulatorioD0842GridControlador extends AbstractCommandController{
	RegulatorioD0842Servicio	regulatorioD0842Servicio=null;
	protected final Logger loggerSAFI = Logger.getLogger("SAFI");
	
	public RegulatorioD0842GridControlador() {
		setCommandClass(RegulatorioD0842Bean.class);
		setCommandName("regulatorioD0842");
	}
		
	protected ModelAndView handle(HttpServletRequest request,
								  HttpServletResponse response,
								  Object command,
								  BindException errors) throws Exception {	
		
		RegulatorioD0842Bean regulatorioD0842Bean = (RegulatorioD0842Bean) command;
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		List listaResultado = regulatorioD0842Servicio.lista(tipoLista, regulatorioD0842Bean);
		
		
		return new ModelAndView("regulatorios/regulatorioD0842GridVista","listaResultado", listaResultado);
	}
//------------------setter-------------

	public RegulatorioD0842Servicio getRegulatorioD0842Servicio() {
		return regulatorioD0842Servicio;
	}

	public void setRegulatorioD0842Servicio(
			RegulatorioD0842Servicio regulatorioD0842Servicio) {
		this.regulatorioD0842Servicio = regulatorioD0842Servicio;
	}
	
}
