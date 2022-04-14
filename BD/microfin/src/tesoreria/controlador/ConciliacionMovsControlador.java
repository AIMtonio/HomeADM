package tesoreria.controlador;

import java.util.ArrayList;
import java.util.List;

import general.bean.MensajeTransaccionBean;
import herramientas.Utileria;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import tesoreria.bean.TesoMovsConciliaBean;
import tesoreria.servicio.ConciliacionMovsServicio;

public class ConciliacionMovsControlador  extends SimpleFormController{
	
	ConciliacionMovsServicio conciliacionMovsServicio = null;
	
	public ConciliacionMovsControlador(){
		setCommandClass(TesoMovsConciliaBean.class);
		setCommandName("Conciliacion");
	}
		
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
		
		int tipoCierre = 1;
		
		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null) ? Integer.parseInt(request.getParameter("tipoTransaccion")) : 0;

		TesoMovsConciliaBean tesomovs = (TesoMovsConciliaBean) command;
		
		// Se rescata el tipo de lista para ver si es un cierre.
		int tipoLista = (request.getParameter("tipoLista")!=null) ? Utileria.convierteEntero(request.getParameter("tipoLista")) : 0;

		// Se valida que el tipo de lista sea 1 - Cierre
		if ( tipoLista == tipoCierre) {

			// Se rescata tanto la institucion como la cuenta Ahorro.
			int institucionID = (request.getParameter("institucionID")!=null) ? Utileria.convierteEntero(request.getParameter("institucionID")) : 0;
			String cuentaAhorroID = (request.getParameter("tipoLista")!=null) ? request.getParameter("cuentaAhorroID") : "";
			
			// Se insertan en el Bean los valores de la institucion y el de la Cuenta.
			tesomovs.setInstitucionID( Integer.toString( institucionID ) );
			tesomovs.setNumCtaInstit( cuentaAhorroID );
			
			// Se consulta todas las conciliaciones a cerrar
			List<TesoMovsConciliaBean> tesoMovsConciliaBeanList = conciliacionMovsServicio.lista(tipoLista, tesomovs);
			
			// Se genera una lista de los numerosMov
			List<String> listaNumeroMov = new ArrayList<String>();

			// Se insertan los valores obtenidos de la consulta en la lista
			for (TesoMovsConciliaBean tesoMovsConciliaBean : tesoMovsConciliaBeanList) {
				
				listaNumeroMov.add( tesoMovsConciliaBean.getListaFoliosMovs() );
			}

			// se setean en el Bean
			tesomovs.setListaConciliaciones( listaNumeroMov );
		}
		
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		
		mensaje = conciliacionMovsServicio.grabaTransaccion(tesomovs, tipoTransaccion);
		
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);	
	}

	public void setConciliacionMovsServicio(
			ConciliacionMovsServicio conciliacionMovsServicio) {
		this.conciliacionMovsServicio = conciliacionMovsServicio;
	}

	
}
