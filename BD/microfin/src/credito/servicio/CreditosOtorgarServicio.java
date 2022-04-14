package credito.servicio;
 
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import herramientas.Utileria;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import credito.bean.CreditosOtorgarBean;
import credito.dao.CreditosOtorgarDAO;



public class CreditosOtorgarServicio extends BaseServicio {
	CreditosOtorgarDAO creditosOtorgarDAO= null;
	
	public static interface Enum_Con_Creditos{
		int principal =1;
		int productoCredito =1;
		int grabarLista = 6;
	}
	
	private CreditosOtorgarServicio(){
		super();
	}		

	
	public CreditosOtorgarBean consulta(int tipoConsulta, CreditosOtorgarBean creditosOtorgarBean){
		CreditosOtorgarBean creditos = null;
		switch(tipoConsulta){
		case Enum_Con_Creditos.principal:
			creditos = creditosOtorgarDAO.consultaPrincipal(creditosOtorgarBean, Enum_Con_Creditos.principal);
		break;		
		}
		
	return creditos;
		
	}
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion,	CreditosOtorgarBean creditosOtorgarBean ){		
		ArrayList listaCreditosOtorgar = (ArrayList) creaListaDetalle(creditosOtorgarBean);
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		switch (tipoTransaccion) {
			case Enum_Con_Creditos.grabarLista:		
				mensaje = creditosOtorgarDAO.grabaEstatus(creditosOtorgarBean,listaCreditosOtorgar, Enum_Con_Creditos.grabarLista);									
				break;			
		}
		return mensaje;
	}
	
	//Metodo que regresa una lista con un mapa de todos los campos de la consulta
		public List obtieneDatos(CreditosOtorgarBean creditos){
			
			List<Map<String, Object>> list = null;

			list = creditosOtorgarDAO.detalleCreditos(Utileria.convierteEntero(creditos.getTipoConsulta()), creditos.getProductoCredito(), creditos.getSucursal(), creditos.getEmpresaNomina());
			
			return list;
		}
		
		public List creaListaDetalle(CreditosOtorgarBean creditosOtorgarBean) {
			
			List<String> creditos  = creditosOtorgarBean.getCreditoID();
			List<String> estatus  = creditosOtorgarBean.getEstatus();			
			ArrayList listaDetalle = new ArrayList();
			CreditosOtorgarBean creditosOtorgar = null;	
			if(creditos != null){
				int tamanio = creditos.size();	

				for (int i = 0; i < tamanio; i++) {
					creditosOtorgar = new CreditosOtorgarBean();
					creditosOtorgar.setCredito(creditos.get(i));
					creditosOtorgar.setValor(estatus.get(i));
					

					listaDetalle.add(creditosOtorgar);
				}
			}
			return listaDetalle;
			
		}



	public CreditosOtorgarDAO getcreditosOtorgarDAO() {
		return creditosOtorgarDAO;
	}

	public void setcreditosOtorgarDAO(CreditosOtorgarDAO creditosOtorgarDAO) {
		this.creditosOtorgarDAO = creditosOtorgarDAO;
	}
	
	
}
