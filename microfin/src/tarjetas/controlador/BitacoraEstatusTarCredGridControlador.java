package tarjetas.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import tarjetas.bean.BitacoraEstatusTarCredBean;
import tarjetas.servicio.BitacoraEstatusTarCredServicio;





public class BitacoraEstatusTarCredGridControlador extends AbstractCommandController{
	
	BitacoraEstatusTarCredServicio bitacoraEstatusTarCredServicio = null;

	public BitacoraEstatusTarCredGridControlador() {
		setCommandClass(BitacoraEstatusTarCredBean.class);
		setCommandName("bitacoraEstatusTarDebBean");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
							  HttpServletResponse response,
							  Object command,
							  BindException errors) throws Exception {
	
		BitacoraEstatusTarCredBean bitacoraEstatusTarCredBean = (BitacoraEstatusTarCredBean) command;
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		List bitacoraEstTarDebList = bitacoraEstatusTarCredServicio.lista(tipoLista, bitacoraEstatusTarCredBean);
	
		List listaResultado = new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(bitacoraEstTarDebList);
		
		return new ModelAndView("tarjetas/bitacoraEstatusTarCredGridVista", "listaResultado", listaResultado);
	
	}
	
	

	public BitacoraEstatusTarCredServicio getBitacoraEstatusTarCredServicio() {
		return bitacoraEstatusTarCredServicio;
	}

	public void setBitacoraEstatusTarCredServicio(
			BitacoraEstatusTarCredServicio bitacoraEstatusTarCredServicio) {
		this.bitacoraEstatusTarCredServicio = bitacoraEstatusTarCredServicio;
	}



	

}