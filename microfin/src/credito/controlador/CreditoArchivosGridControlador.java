package credito.controlador;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;



import credito.bean.CreditosArchivoBean;
import credito.servicio.CreditoArchivoServicio;

public class CreditoArchivosGridControlador extends AbstractCommandController{
	
	CreditoArchivoServicio creditoArchivoServicio = null;
	
public CreditoArchivosGridControlador() {
	setCommandClass(CreditosArchivoBean.class);
	setCommandName("archivoGrid");
}
	
protected ModelAndView handle(HttpServletRequest request,
							  HttpServletResponse response,
							  Object command,
							  BindException errors) throws Exception {	
	
	CreditosArchivoBean creditosArchivoBean = (CreditosArchivoBean) command;
	int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
	
	List credArchivoList = creditoArchivoServicio.listaArchivosCredito(tipoLista, creditosArchivoBean);

	return new ModelAndView("credito/creditoArchivoGridVista", "listaResultado", credArchivoList);
}

public void setCreditoArchivoServicio(
		CreditoArchivoServicio creditoArchivoServicio) {
	this.creditoArchivoServicio = creditoArchivoServicio;
}



}
