package tarjetas.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import tarjetas.bean.BitacoraEstatusTarDebBean;
import tarjetas.servicio.BitacoraEstatusTarDebServicio;



public class BitacoraEstatusTarDebGridControlador extends AbstractCommandController{
	
	BitacoraEstatusTarDebServicio bitacoraEstatusTarDebServicio = null;

	public BitacoraEstatusTarDebGridControlador() {
		setCommandClass(BitacoraEstatusTarDebBean.class);
		setCommandName("bitacoraEstatusTarDebBean");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
							  HttpServletResponse response,
							  Object command,
							  BindException errors) throws Exception {
	
		BitacoraEstatusTarDebBean bitacoraEstatusTarDebBean = (BitacoraEstatusTarDebBean) command;
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		List bitacoraEstTarDebList = bitacoraEstatusTarDebServicio.lista(tipoLista, bitacoraEstatusTarDebBean);
	
		List listaResultado = new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(bitacoraEstTarDebList);
		
		return new ModelAndView("tarjetas/biatcoraEstatusTarDebGridVista", "listaResultado", listaResultado);
	
	}

	public BitacoraEstatusTarDebServicio getBitacoraEstatusTarDebServicio() {
		return bitacoraEstatusTarDebServicio;
	}

	public void setBitacoraEstatusTarDebServicio(
			BitacoraEstatusTarDebServicio bitacoraEstatusTarDebServicio) {
		this.bitacoraEstatusTarDebServicio = bitacoraEstatusTarDebServicio;
	}

	

}