package tarjetas.servicio;

import java.io.BufferedReader;
import java.io.FileReader;

import tarjetas.bean.TarDebConciliaATMBean;
import tarjetas.dao.TarDebConciliaATMDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import herramientas.Constantes;

public class TarDebConciliaATMServicio extends BaseServicio{

	TarDebConciliaATMDAO tarDebConciliaATMDAO = null;

	public static interface Enum_Tra_ConciATM {
		int altaDetalleATM = 1;	
	};
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, TarDebConciliaATMBean tarDebConciATMBean){
		MensajeTransaccionBean mensaje = null;
		switch(tipoTransaccion){
			case Enum_Tra_ConciATM.altaDetalleATM:
			mensaje = altaConciliacionATM(tarDebConciATMBean);
			break;
		}
		return mensaje;
	}

	public MensajeTransaccionBean altaConciliacionATM(TarDebConciliaATMBean tarDebConciATMBean){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = tarDebConciliaATMDAO.altaConciliacionATM(tarDebConciATMBean);
		
		return mensaje;
	}
	
	
	
	
	public TarDebConciliaATMDAO getTarDebConciliaATMDAO() {
		return tarDebConciliaATMDAO;
	}

	public void setTarDebConciliaATMDAO(TarDebConciliaATMDAO tarDebConciliaATMDAO) {
		this.tarDebConciliaATMDAO = tarDebConciliaATMDAO;
	}
}
