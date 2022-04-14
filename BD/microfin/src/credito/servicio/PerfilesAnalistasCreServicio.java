 
package credito.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import herramientas.Constantes;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.StringTokenizer;

import credito.bean.PerfilesAnalistasCreBean;
import credito.bean.ProductosCreditoBean;
import credito.beanWS.request.ListaProdCreditoRequest;
import credito.beanWS.response.ListaProdCreditoResponse;
import credito.dao.PerfilesAnalistasCreDAO;





import credito.dao.PerfilesAnalistasCreDAO;
import credito.dao.ProductosCreditoDAO;
import credito.servicio.ProductosCreditoServicio.Enum_Lis_ProductosCredito;
import credito.servicio.ProductosCreditoServicio.Enum_Tra_ProductosCredito;

public class PerfilesAnalistasCreServicio  extends BaseServicio {

	
	//---------- Variables ------------------------------------------------------------------------
	PerfilesAnalistasCreDAO perfilesAnalistasCreDAO;
	String codigo= "";
	int entero_uno=1;

	private PerfilesAnalistasCreServicio(){
		super();
	}
	//---------- Tipos de Listas---------------------------------------------------------------

	public static interface Enum_Transaccion {
		int altaAnalistas = 1;
		int altaEjecutivos = 2;
	}
	
	

	
	public static interface Enum_Lis_perfilesAnalistasCre {
         int listaAnalistas = 1;
		int listaEjecutivos = 2;

	}
	//------------ Tipo de Consulta ------------
	public static interface Enum_Con_Perfiles{
		int consultaAnalista = 1;
		int consultaEjecutivos = 2;
	}

	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, PerfilesAnalistasCreBean perfilesAnalistasCreBean,String detalles){
		MensajeTransaccionBean mensaje = null;
		switch(tipoTransaccion){
		case Enum_Transaccion.altaAnalistas:
		case Enum_Transaccion.altaEjecutivos:
			mensaje = grabaDetalle(tipoTransaccion, perfilesAnalistasCreBean, detalles);
			break;
		}

		return mensaje;
	}

	private MensajeTransaccionBean grabaDetalle(int tipoTransaccion, PerfilesAnalistasCreBean perfilesAnalistasCreBean, String detalles) {
		MensajeTransaccionBean mensaje = null;
		try{
			switch (tipoTransaccion) {
			case Enum_Lis_perfilesAnalistasCre.listaAnalistas:
				detalles = perfilesAnalistasCreBean.getDetalleAnalistas();
				break;
			case Enum_Lis_perfilesAnalistasCre.listaEjecutivos:
				detalles = perfilesAnalistasCreBean.getDetalleEjecutivos();
				break;
			}
			List<PerfilesAnalistasCreBean> listaDetalle = creaListaDetalle(detalles);
			mensaje=perfilesAnalistasCreDAO.grabaDetalle(perfilesAnalistasCreBean, listaDetalle);
		} catch (Exception e){
			e.printStackTrace();
			return null;
		}
		return mensaje;
	}
	
	private List<PerfilesAnalistasCreBean> creaListaDetalle(String detalles) {
		StringTokenizer tokensBean = new StringTokenizer(detalles, "[");
		String stringCampos;
		String tokensCampos[];
		List<PerfilesAnalistasCreBean> listaDetalle = new ArrayList<PerfilesAnalistasCreBean>();
		PerfilesAnalistasCreBean detalle;
		try {
		while (tokensBean.hasMoreTokens()) {
			detalle = new PerfilesAnalistasCreBean();
			stringCampos = tokensBean.nextToken();
			
			tokensCampos = herramientas.Utileria.divideString(stringCampos, "]");
			detalle.setPerfilID(tokensCampos[0]);
			detalle.setNombreRol(tokensCampos[1]);
			detalle.setTipoPerfil(tokensCampos[2]);
			detalle.setPerfilExpediente(tokensCampos[3]);
			

			listaDetalle.add(detalle);
		}
		} catch (Exception e){
			e.printStackTrace();
		}
		return listaDetalle;
	}

	public List lista(int tipoLista, PerfilesAnalistasCreBean perfilesAnalistasCre){
		List productosCreditoLista = null;

		switch (tipoLista) {
	        case  Enum_Lis_perfilesAnalistasCre.listaEjecutivos:
	        	productosCreditoLista = perfilesAnalistasCreDAO.lista(perfilesAnalistasCre,tipoLista);
	        break;
	        case  Enum_Lis_perfilesAnalistasCre.listaAnalistas:
	        	productosCreditoLista = perfilesAnalistasCreDAO.lista(perfilesAnalistasCre,tipoLista);
	        break;

		}
		return productosCreditoLista;
	}
	
	//Metodo para consulta el perfil del analista
	public PerfilesAnalistasCreBean consulta(int tipoConsulta, PerfilesAnalistasCreBean perfilesAnalistaBean) {
		PerfilesAnalistasCreBean perfilesBean = null;
		switch (tipoConsulta) {
		case Enum_Con_Perfiles.consultaAnalista:
			perfilesBean = perfilesAnalistasCreDAO.consultaPerfiles(perfilesBean, tipoConsulta);
			break;
		case Enum_Con_Perfiles.consultaEjecutivos:
			perfilesBean = perfilesAnalistasCreDAO.consultaPerfiles(perfilesBean, tipoConsulta);
			break;	

		default:
			break;
		}
		return perfilesBean;
		
	}
	
	//------------------ Geters y Seters ------------------------------------------------------	
	public void setPerfilesAnalistasCreDAO(PerfilesAnalistasCreDAO perfilesAnalistasCreDAO) {
		this.perfilesAnalistasCreDAO = perfilesAnalistasCreDAO;
	}

	public PerfilesAnalistasCreDAO getPerfilesAnalistasCreDAO() {
		return perfilesAnalistasCreDAO;
	}	
}
