package tesoreria.servicio;

import java.util.ArrayList;
import java.util.List;

import general.bean.MensajeTransaccionBean;
import herramientas.Utileria;
import tesoreria.bean.DispersionMasivaBean;
import tesoreria.dao.DispersionMasivaDAO;

public class DispersionMasivaServicio {
	
	DispersionMasivaDAO dispersionMasivaDAO;
	
	public interface Enum_Tran_DispersionMasiva{
		int validacion = 1;
		int procesar = 2;
		int baja = 3;
	}
	
	public interface Enum_Lis_DispersionMasiva{
		int validacion = 1;
	}
	
	public MensajeTransaccionBean valida(int tipoTransaccion,DispersionMasivaBean dispersionMasivaBean){
		MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean(); 
		switch(tipoTransaccion){
			case Enum_Tran_DispersionMasiva.validacion:
				mensajeBean = dispersionMasivaDAO.validaCargaArchivo(dispersionMasivaBean);
				break;
			case Enum_Tran_DispersionMasiva.baja:
				//mensajeBean = dispersionMasivaDAO.bajaCargaArchivo(Utileria.convierteLong(dispersionMasivaBean.getNumTransaccion()));
					dispersionMasivaDAO.eliminaArchivo(dispersionMasivaBean.getRutaArchivo());
				break;
		}
		return mensajeBean;
	}
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion,DispersionMasivaBean dispersionMasivaBean){
		MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean(); 
		switch(tipoTransaccion){
			case Enum_Tran_DispersionMasiva.procesar:
				mensajeBean = dispersionMasivaDAO.procesaArchivoCarga(dispersionMasivaBean);
				break;
		}
		return mensajeBean;
	}
	
	
	public List<DispersionMasivaBean> lista(int numLista, DispersionMasivaBean dispersionMasivaBean){
		List lista = new ArrayList<DispersionMasivaBean>();
			switch(numLista){
				case Enum_Lis_DispersionMasiva.validacion:
					lista = dispersionMasivaDAO.listaValidacion(dispersionMasivaBean, numLista);
			}
		return lista;
	}
	
	public DispersionMasivaDAO getDispersionMasivaDAO() {
		return dispersionMasivaDAO;
	}

	public void setDispersionMasivaDAO(DispersionMasivaDAO dispersionMasivaDAO) {
		this.dispersionMasivaDAO = dispersionMasivaDAO;
	}
	
	
}
