package soporte.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

import java.util.List;

import soporte.bean.BitacoraBatchBean;
import soporte.dao.BitacoraBatchDAO;

public class BitacoraBatchServicio extends BaseServicio {
	
	BitacoraBatchDAO bitacoraBatchDAO = null;
	
	public static interface Enum_Tra_BitacoraBatch {
		int	alta			= 1;
		int	modificacion	= 2;
	}
	
	public static interface Enum_Con_BitacoraBatch {
		int	principal		= 1;
		int	existeEjecucion	= 2;
	}
	
	public static interface Enum_Lis_BitacoraBatch {
		int	principal		= 1;
	}
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, BitacoraBatchBean bitacoraBatchBean) {
		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) {
			case Enum_Tra_BitacoraBatch.alta:
				mensaje = null;
				break;
			case Enum_Tra_BitacoraBatch.modificacion:
				mensaje = null;
				break;
		}
		return mensaje;
	}
	
	public BitacoraBatchBean consulta(int tipoConsulta, BitacoraBatchBean bitacoraBatchBean) {
		BitacoraBatchBean bitacoraBean = null;
		switch (tipoConsulta) {
			case Enum_Con_BitacoraBatch.existeEjecucion:
				bitacoraBean = bitacoraBatchDAO.consultaEjecucion(bitacoraBatchBean, tipoConsulta);
				break;
		}
		return bitacoraBean;
	}
	
	public List<BitacoraBatchBean> lista(int tipoLista, BitacoraBatchBean bitacoraBatchBean) {
		List<BitacoraBatchBean> lista = null;
		
		return lista;
	}

	public BitacoraBatchDAO getBitacoraBatchDAO() {
		return bitacoraBatchDAO;
	}

	public void setBitacoraBatchDAO(BitacoraBatchDAO bitacoraBatchDAO) {
		this.bitacoraBatchDAO = bitacoraBatchDAO;
	}
	
}