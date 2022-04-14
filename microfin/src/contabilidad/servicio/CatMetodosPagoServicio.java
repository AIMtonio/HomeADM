package contabilidad.servicio;

import java.io.ByteArrayOutputStream;
import java.util.ArrayList;
import java.util.List;
import java.util.StringTokenizer;

import javax.servlet.http.HttpServletResponse;

import contabilidad.bean.CatIngresosEgresosBean;
import contabilidad.bean.CatMetodosPagoBean;
import contabilidad.dao.CatMetodosPagoDAO;
import contabilidad.servicio.CatIngresosEgresosServicio.Enum_Lis_CatTipoLista;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import herramientas.Constantes;
import reporte.ParametrosReporte;
import reporte.Reporte;


public class CatMetodosPagoServicio extends BaseServicio {
	
	CatMetodosPagoDAO	catMetodosPagoDAO;
	
	public static interface Enum_Tra_CatMetodoPago{
		int	alta			= 1;
		int	modificacion	= 2;
	}
	
	public static interface Enum_Con_CatMetodoPago {
		int	principal	= 1;
	}
	
	public static interface Enum_Lis_CatMetodoPago {
		int	principal	= 1;
		int	listaCombo	= 2;
	}
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, CatMetodosPagoBean catMetodosPagoBean) {
		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) {
			case Enum_Tra_CatMetodoPago.alta:
				
				mensaje = catMetodosPagoDAO.alta(catMetodosPagoBean);			
				
				break;
			case Enum_Tra_CatMetodoPago.modificacion:			
				
				mensaje = catMetodosPagoDAO.modifica(catMetodosPagoBean);
			
				
				break;
		}
		return mensaje;
	}
	public CatMetodosPagoBean consulta(int tipoConsulta, CatMetodosPagoBean catMetodosPagoBean) {
		CatMetodosPagoBean catMetodosPago = null;
		switch (tipoConsulta) {
			case Enum_Con_CatMetodoPago.principal:
				
				catMetodosPago = catMetodosPagoDAO.consultaPrincipal(catMetodosPagoBean, tipoConsulta);
				break;
		}
		return catMetodosPago;
	}
	
	public List<CatMetodosPagoBean> lista(int tipoLista, CatMetodosPagoBean catMetodosPagoBean) {
		List<CatMetodosPagoBean> lista = null;
		switch (tipoLista) {
			case Enum_Lis_CatMetodoPago.principal:
				lista = catMetodosPagoDAO.lista(catMetodosPagoBean, tipoLista);
				break;
		}
		return lista;
	}
	
	
	public  Object[] listaCombo(int tipoLista) {
		List listaConceptos = null;
		switch(tipoLista){			
		case Enum_Lis_CatMetodoPago.listaCombo: 			

			listaConceptos = catMetodosPagoDAO.listaCombo(tipoLista);

			break;
			
			
		}
		return listaConceptos.toArray();		
	}
	
	
	

	public CatMetodosPagoDAO getCatMetodosPagoDAO() {
		return catMetodosPagoDAO;
	}

	public void setCatMetodosPagoDAO(CatMetodosPagoDAO catMetodosPagoDAO) {
		this.catMetodosPagoDAO = catMetodosPagoDAO;
	}

	
	
	
}
