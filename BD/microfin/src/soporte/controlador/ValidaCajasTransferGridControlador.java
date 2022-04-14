package soporte.controlador;

import java.util.ArrayList;
import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import herramientas.Utileria;
import soporte.bean.ValidaCajasTransferBean;
import soporte.servicio.ValidaCajasTransferServicio;

public class ValidaCajasTransferGridControlador extends SimpleFormController{
	
	ValidaCajasTransferServicio validaCajasTransferServicio = null;
	
	public ValidaCajasTransferGridControlador(){
		setCommandClass(ValidaCajasTransferBean.class);
		setCommandName("validaCajaTrans");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse response,
									Object command,
									BindException errors) throws Exception {
		
		ValidaCajasTransferBean validaCajasTransferBean = (ValidaCajasTransferBean) command;
		int tipoLista = Utileria.convierteEntero(request.getParameter("tipoLista"));
		
		List lista = validaCajasTransferServicio.lista(validaCajasTransferBean, tipoLista);
		List listaResultado = (List)new ArrayList();
		listaResultado.add(lista);

		if(tipoLista == 2) {
			return new ModelAndView("soporte/validaCajasTransCCGridVista", "listaResultado", listaResultado);
		}
		return new ModelAndView("soporte/validaCajasTransGridVista", "listaResultado", listaResultado);
	}
	
	public ValidaCajasTransferServicio getValidaCajasTransferServicio() {
		return validaCajasTransferServicio;
	}

	public void setValidaCajasTransferServicio(ValidaCajasTransferServicio validaCajasTransferServicio) {
		this.validaCajasTransferServicio = validaCajasTransferServicio;
	}
}
