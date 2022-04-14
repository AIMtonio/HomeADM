package pld.servicio;

import general.bean.MensajeTransaccionArchivoBean;
import general.servicio.BaseServicio;

import java.util.List;

import pld.bean.ArchAdjuntosPLDBean;
import pld.dao.ArchivosPLDDAO;

public class ArchAdjuntosPLDServicio extends BaseServicio {
	ArchivosPLDDAO	archivosPLDDAO	= null;
	
	public static interface Enum_Tra_ArchAdjuntosPLD {
		int	alta	= 1;
		int	baja	= 2;
	}
	
	public static interface Enum_Lis_ArchAdjuntosPLD {
		int	inusuales	= 1;
		int intPreocupantes = 2;
	}
	
	public MensajeTransaccionArchivoBean grabaTransaccion(int tipoTransaccion, ArchAdjuntosPLDBean archAdjuntosPLDBean) {
		MensajeTransaccionArchivoBean mensaje = null;
		
		switch (tipoTransaccion) {
			case Enum_Tra_ArchAdjuntosPLD.alta :
				mensaje = archivosPLDDAO.alta(archAdjuntosPLDBean);
				break;
			case Enum_Tra_ArchAdjuntosPLD.baja :
				mensaje = archivosPLDDAO.baja(archAdjuntosPLDBean);
				break;
		}
		
		return mensaje;
	}
	
	public MensajeTransaccionArchivoBean baja(ArchAdjuntosPLDBean archAdjuntosPLDBean) {
		MensajeTransaccionArchivoBean mensaje = null;
		mensaje = archivosPLDDAO.baja(archAdjuntosPLDBean);
		return mensaje;
	}

	public List<ArchAdjuntosPLDBean> lista(int tipoLista, ArchAdjuntosPLDBean archAdjuntosPLDBean) {
		List<ArchAdjuntosPLDBean> lista = null;
		switch (tipoLista) {
			case Enum_Lis_ArchAdjuntosPLD.inusuales :
			case Enum_Lis_ArchAdjuntosPLD.intPreocupantes :
				lista = archivosPLDDAO.lista(archAdjuntosPLDBean, tipoLista);
				break;
		}
		return lista;
	}
	
	public ArchivosPLDDAO getArchivosPLDDAO() {
		return archivosPLDDAO;
	}
	
	public void setArchivosPLDDAO(ArchivosPLDDAO archivosPLDDAO) {
		this.archivosPLDDAO = archivosPLDDAO;
	}
}
