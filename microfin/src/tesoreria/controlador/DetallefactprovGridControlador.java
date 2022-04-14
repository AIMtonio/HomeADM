package tesoreria.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.support.PagedListHolder;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import tesoreria.bean.DetalleImpuestoBean;
import tesoreria.bean.DetallefactprovBean;
import tesoreria.servicio.DetalleImpuestoServicio;
import tesoreria.servicio.DetallefactprovServicio;


public class DetallefactprovGridControlador   extends AbstractCommandController{
	
	DetallefactprovServicio detallefactprovServicio = null;
	DetalleImpuestoServicio detalleImpuestoServicio = null;

public DetallefactprovGridControlador() {
	setCommandClass(DetallefactprovBean.class);
	setCommandName("detalleFactura");
}
	
protected ModelAndView handle(HttpServletRequest request,
							  HttpServletResponse response,
							  Object command,
							  BindException errors) throws Exception {
	

	
	int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
	int tipoListaImpuesto = 3;
	int tipoListaImporte = 1;
	
	detallefactprovServicio.getDetallefactprovDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
	detalleImpuestoServicio.getDetalleImpuestoDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
	
	DetallefactprovBean detallefactprovBean = (DetallefactprovBean) command;
	DetalleImpuestoBean detalleimpuestoBean = new DetalleImpuestoBean();
	detalleimpuestoBean.setNoFactura(detallefactprovBean.getNoFactura());
	detalleimpuestoBean.setProveedorID(detallefactprovBean.getProveedorID());
	
	List detalleFacturaList = detallefactprovServicio.lista(tipoLista, detallefactprovBean);
	List listaImpuesto = detallefactprovServicio.lista(tipoListaImpuesto, detallefactprovBean);
	List listaImportes = detalleImpuestoServicio.lista(tipoListaImporte, detalleimpuestoBean);
	
	List listaResultado = new ArrayList();
	
	listaResultado.add(detalleFacturaList);
    listaResultado.add(listaImpuesto);
    listaResultado.add(listaImportes);
	
	return new ModelAndView("tesoreria/detalleFacturaProvCatalogoVista", "listaResultado", listaResultado);
}

public void setDetallefactprovServicio(
		DetallefactprovServicio detallefactprovServicio) {
	this.detallefactprovServicio = detallefactprovServicio;
}

public DetallefactprovServicio getDetallefactprovServicio() {
	return detallefactprovServicio;
}

public DetalleImpuestoServicio getDetalleImpuestoServicio() {
	return detalleImpuestoServicio;
}

public void setDetalleImpuestoServicio(
		DetalleImpuestoServicio detalleImpuestoServicio) {
	this.detalleImpuestoServicio = detalleImpuestoServicio;
}


}

