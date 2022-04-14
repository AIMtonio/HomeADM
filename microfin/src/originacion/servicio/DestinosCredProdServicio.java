package originacion.servicio;

import java.util.ArrayList;
import java.util.List;

import originacion.bean.DestinosCredProdBean;
import originacion.dao.DestinosCredProdDAO;
import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosAuditoriaBean;
import general.servicio.BaseServicio;

public class DestinosCredProdServicio  extends BaseServicio {
	DestinosCredProdDAO destinosCredProdDAO = null;
	ParametrosAuditoriaBean parametrosAuditoriaBean = null;
	
	//---------- Variables ------------------------------------------------------------------------
	// Enums para las transacciones
	public static interface Enum_Tra_DestinosCredProd{
		int grabar	= 1;
	}
	
	// Enums para las listas
	public static interface Enum_Lis_DestinosCredProd{
		int destinosCredPorProducto	= 1;
	}
	
	// proceso hacer la conciliacion manual
	public MensajeTransaccionBean grabaTransaccion( int tipoTransaccion, final DestinosCredProdBean destinosCredProdBea){
		MensajeTransaccionBean mensaje=new MensajeTransaccionBean();
		switch(tipoTransaccion){
			case Enum_Tra_DestinosCredProd.grabar:	
				mensaje = grabaDestinosPorProducto(destinosCredProdBea);
				break;					
		}
		return mensaje;
	}

	
	public List lista(int tipoLista, DestinosCredProdBean destinosCredProdBean){		
		List listaDestinosCredProd = null;
		switch (tipoLista) {
		case Enum_Lis_DestinosCredProd.destinosCredPorProducto:		
			listaDestinosCredProd = destinosCredProdDAO.listaDestinosPorProducto(destinosCredProdBean, tipoLista);				
			break;
		}
		return listaDestinosCredProd;
	}
		
	
	public MensajeTransaccionBean grabaDestinosPorProducto(final DestinosCredProdBean destinosCredProdBea){
		MensajeTransaccionBean resultado = new MensajeTransaccionBean();

		ArrayList listaDestinosPorProducto = (ArrayList) listaGridDestinosPorProducto(destinosCredProdBea);
		resultado = destinosCredProdDAO.grabaDestinosPorProducto(destinosCredProdBea, listaDestinosPorProducto);
		return resultado;
	}
	
	// metodo para leer la lista del grid
	public List<DestinosCredProdBean> listaGridDestinosPorProducto(DestinosCredProdBean destinosCredProdBean){

		List<String> listaDestinoCreID  	;
		List<String> listaAsignar   		;

		//listaDestinoCreID  	= destinosCredProdBean.getListaDestinoCreID();
		listaAsignar   		= destinosCredProdBean.getListaAsignar();

		ArrayList<DestinosCredProdBean> listaDetalle = new ArrayList();
		DestinosCredProdBean destinosCredProd	= null;
		try{
			if(listaAsignar != null){ // si la lista asignar no esta vacia
				int tamanio = listaAsignar.size();
				for(int i=0; i<tamanio; i++){
					destinosCredProd = new DestinosCredProdBean();
					destinosCredProd.setDestinoCreID(listaAsignar.get(i));
					//destinosCredProd.setAsignar(listaAsignar.get(i));
					listaDetalle.add(destinosCredProd);
				}
			}
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error al leer lista de destinos por producto de credito", e);
		}
		return listaDetalle;
	}


	public DestinosCredProdDAO getDestinosCredProdDAO() {
		return destinosCredProdDAO;
	}

	public void setDestinosCredProdDAO(DestinosCredProdDAO destinosCredProdDAO) {
		this.destinosCredProdDAO = destinosCredProdDAO;
	}

}
