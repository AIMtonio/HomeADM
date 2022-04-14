package nomina.controlador;
import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.support.PagedListHolder;

import general.bean.MensajeTransaccionBean;
import herramientas.Constantes;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import nomina.bean.AplicaPagoInstBean;
import nomina.servicio.AplicaPagoInstServicio;
import nomina.servicio.AplicaPagoInstServicio.Enum_Tipo_Transaccion;

import org.jfree.report.function.bool.IsEmptyDataExpression;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

public class AplicaPagoInstControlador extends SimpleFormController{
	AplicaPagoInstServicio aplicaPagoInstServicio = null;

	public AplicaPagoInstControlador() {
		setCommandClass(AplicaPagoInstBean.class);
		setCommandName("pagoInstBean");
}
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
			
		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?		
				Integer.parseInt(request.getParameter("tipoTransaccion")):0;
		
		String Control = (request.getParameter("controlLista")!=null)?		
					(request.getParameter("controlLista")):"";
					
		AplicaPagoInstBean pagoInstBean = (AplicaPagoInstBean) command;
		pagoInstBean.setControlLista(Control);
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		aplicaPagoInstServicio.getAplicaPagoInstDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		
		List listaPagos = null;
		List listaPagosNoAplicados = new ArrayList();
		int contaReg = 0;
		
		if ( tipoTransaccion == Enum_Tipo_Transaccion.pagar){
			List listaResultado = new ArrayList();
			PagedListHolder listaPaginada;
			listaResultado = (List) request.getSession().getAttribute("ListaPaginadaPagoInstitucion");
			listaPaginada = (PagedListHolder) listaResultado.get(1);
			
			listaPagos = listaPaginada.getSource();
			AplicaPagoInstBean gridPagosInstBean =null;

			for(int i=0; i < listaPagos.size(); i++){
				gridPagosInstBean = (AplicaPagoInstBean) listaPagos.get(i);
				if( gridPagosInstBean.getEsSeleccionado().equalsIgnoreCase(Constantes.STRING_SI)){
					contaReg ++;				
				}
			}			
			
			if (request.getSession().getAttribute("ListaPaginadaNoAplicado") != null){
				List listaResultadoNoAplicados = new ArrayList();
				PagedListHolder listaPaginadaNoAplicados;
				listaResultadoNoAplicados = (List) request.getSession().getAttribute("ListaPaginadaNoAplicado");
				listaPaginadaNoAplicados = (PagedListHolder) listaResultadoNoAplicados.get(1);
				
				listaPagosNoAplicados = listaPaginadaNoAplicados.getSource();
			}
		}
		
		if(contaReg == 0 && tipoTransaccion == Enum_Tipo_Transaccion.pagar){
			mensaje.setNumero(999);
			mensaje.setDescripcion("No hay movimientos seleccionados pertenecientes al Folio de Carga");
			mensaje.setNombreControl(Constantes.STRING_VACIO);
			mensaje.setConsecutivoString(Constantes.STRING_CERO);
		}else{
			mensaje = aplicaPagoInstServicio.grabaTransaccion(tipoTransaccion,pagoInstBean, listaPagos, listaPagosNoAplicados );
		}
 		return new ModelAndView(getSuccessView(), "mensaje", mensaje);

	}
	
	/* Declaracion de getter y setters */
	public AplicaPagoInstServicio getAplicaPagoInstServicio() {
		return aplicaPagoInstServicio;
	}
	public void setAplicaPagoInstServicio(AplicaPagoInstServicio aplicaPagoInstServicio) {
		this.aplicaPagoInstServicio = aplicaPagoInstServicio;
	}
	
	
}
