package regulatorios.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import regulatorios.bean.RegulatorioD0842Bean;
import regulatorios.servicio.RegulatorioD0842Servicio;

public class RegistrosReg0842ListaControlador extends AbstractCommandController{
	RegulatorioD0842Servicio	regulatorioD0842Servicio=null;

	public RegistrosReg0842ListaControlador(){
		setCommandClass(RegulatorioD0842Bean.class);
		setCommandName("regulatorioD0842");
	}

	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {

		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		String controlID = request.getParameter("controlID");
		
		RegulatorioD0842Bean regulatorioD0842Bean = (RegulatorioD0842Bean) command;
                List listaRegistros = regulatorioD0842Servicio.lista(tipoLista, regulatorioD0842Bean);
                
                List listaResultado = (List)new ArrayList();
                listaResultado.add(tipoLista);
                listaResultado.add(controlID);
                listaResultado.add(listaRegistros);
		return new ModelAndView("regulatorios/registrosD0842ListaVista", "listaResultado", listaResultado);
	}

	public RegulatorioD0842Servicio getRegulatorioD0842Servicio() {
		return regulatorioD0842Servicio;
	}

	public void setRegulatorioD0842Servicio(
			RegulatorioD0842Servicio regulatorioD0842Servicio) {
		this.regulatorioD0842Servicio = regulatorioD0842Servicio;
	}

	

}
