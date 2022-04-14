package nomina.servicio;

import java.util.List;


import nomina.bean.DetalleArchivoInstalBean;
import nomina.dao.DetalleArchivoInstalDAO;
import nomina.servicio.ArchivoInstalServicio.Enum_Lis_ArchivoInstal;
import general.servicio.BaseServicio;

public class DetalleArchivoInstalServicio extends BaseServicio{

	DetalleArchivoInstalDAO detalleArchivoInstalDAO = null;

	public static interface Enum_Lis_ArchivoInstal {
		int principal = 1;
	}
	
	/**
	 * Método que realiza una determinada consulta con el objetivo de obtener un listado de registros coincidentes a un determinado filtro.
	 * @param tipoLista Parámetro que determina el tipo de lista que se realizará.
	 * @param bean Objeto que almacena el filtro por el cual se realizará la consulta.
	 * @return Lista que almacena los registros coincidentes.
	 */
	public List<DetalleArchivoInstalBean> lista(int tipoLista, DetalleArchivoInstalBean bean){
		List<DetalleArchivoInstalBean> listaArchivos = null;
		switch(tipoLista){
			case Enum_Lis_ArchivoInstal.principal:
				listaArchivos = detalleArchivoInstalDAO.listaPrincipal(Enum_Lis_ArchivoInstal.principal, bean);
			break;
		}
		return listaArchivos;
	}
	
	public DetalleArchivoInstalDAO getDetalleArchivoInstalDAO() {
		return detalleArchivoInstalDAO;
	}

	public void setDetalleArchivoInstalDAO(
			DetalleArchivoInstalDAO detalleArchivoInstalDAO) {
		this.detalleArchivoInstalDAO = detalleArchivoInstalDAO;
	}
		
}
