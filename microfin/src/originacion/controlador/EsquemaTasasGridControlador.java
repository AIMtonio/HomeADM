package originacion.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import  originacion.bean.EsquemaTasasBean;
import originacion.servicio.EsquemaTasasServicio;

public class EsquemaTasasGridControlador extends AbstractCommandController {

	EsquemaTasasServicio esquemaTasasServicio = null;
	
	public EsquemaTasasGridControlador(){
		setCommandClass(EsquemaTasasBean.class);
		setCommandName("presSucursalBean");
		
	}
	
	
	@Override
	protected ModelAndView handle(HttpServletRequest request,HttpServletResponse response, Object command, BindException errors)throws Exception {
		// TODO Auto-generated method stub
		EsquemaTasasBean esquemaTasasBean = new EsquemaTasasBean();
		//PARAMETROS DE PANTALLA
		String  sucursalID = (request.getParameter("sucursalID")!=null) ? request.getParameter("sucursalID") : "";
        String  productoCreditoID = (request.getParameter("productoCreditoID")!=null) ?  request.getParameter("productoCreditoID")  : "0";
        String productoNomina = request.getParameter("productoNomina")!=null ?request.getParameter("productoNomina"):"N" ;//El producto es de tipo nomina S o N
		int tipoLista = (request.getParameter("tipoLista")!=null) ? Integer.parseInt(request.getParameter("tipoLista")) : 0;
		//FIN
		esquemaTasasBean.setSucursalID(sucursalID);
		esquemaTasasBean.setProductoCreditoID(productoCreditoID);
		List listaResul =null;
		listaResul = esquemaTasasServicio.lista(tipoLista, esquemaTasasBean);
		List listaResultado = (List)new ArrayList();
		listaResultado.add(listaResul);
		listaResultado.add(productoNomina);//Enviar para que se muestre las columnas de institucion de nomina

		return new ModelAndView("originacion/esquemaTasasGridVista", "listaResultado", listaResultado);
	}
	
	
	
	//Getters y Setters
	public EsquemaTasasServicio getEsquemaTasasServicio() {
		return esquemaTasasServicio;
	}
	public void setEsquemaTasasServicio(EsquemaTasasServicio esquemaTasasServicio) {
		this.esquemaTasasServicio = esquemaTasasServicio;
	}
	
}
