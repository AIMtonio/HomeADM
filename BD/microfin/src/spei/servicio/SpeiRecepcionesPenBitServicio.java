package spei.servicio;

import java.util.List;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import spei.bean.SpeiRecepcionesPenBitBean;
import spei.dao.SpeiRecepcionesPenBitDAO;

public class SpeiRecepcionesPenBitServicio extends BaseServicio {
	private SpeiRecepcionesPenBitDAO speiRecepcionesPenBitDAO;
	
	public static interface Enum_RecepcionesPenBit_Lis{
		int Lis_FechaProc = 1;
	}
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, SpeiRecepcionesPenBitBean speiRecepcionesPenBitBean) {
		MensajeTransaccionBean mensaje = null;
		return mensaje;
	}
	
	public List lista(int tipoLista, SpeiRecepcionesPenBitBean speiRecepcionesPenBitBean){		
		List response = null;
		switch (tipoLista) {
			case Enum_RecepcionesPenBit_Lis.Lis_FechaProc:		
				response =  speiRecepcionesPenBitDAO.listaRecepcionesNoAplicadas(speiRecepcionesPenBitBean, tipoLista);	
				break;
		}		
		return response;
	}

	public SpeiRecepcionesPenBitDAO getSpeiRecepcionesPenBitDAO() {
		return speiRecepcionesPenBitDAO;
	}

	public void setSpeiRecepcionesPenBitDAO(SpeiRecepcionesPenBitDAO speiRecepcionesPenBitDAO) {
		this.speiRecepcionesPenBitDAO = speiRecepcionesPenBitDAO;
	}
}
