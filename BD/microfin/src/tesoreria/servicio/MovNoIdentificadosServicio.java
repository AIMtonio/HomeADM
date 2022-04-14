package tesoreria.servicio;

import tesoreria.bean.MovNoIdentificadosBean;
import tesoreria.dao.MovNoIdentificadosDAO;
import tesoreria.dao.TesoMovimientosDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

public class MovNoIdentificadosServicio extends BaseServicio{
	
	MovNoIdentificadosDAO movNoIdentificadosDAO;
	TesoMovimientosDAO tesoMovimientosDAO;		
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, MovNoIdentificadosBean movimientos){
		MensajeTransaccionBean mensaje = null;
		int longitud = movimientos.getDescripcion().size();
		for(int i=0; i<longitud ; i++){
			mensaje = tesoMovimientosDAO.generaAltaMovimiento(movimientos, i);	
		}
		return mensaje;
	}
	
	public MovNoIdentificadosDAO getMovNoIdentificadosDAO() {
		return movNoIdentificadosDAO;
	}
	public void setMovNoIdentificadosDAO(MovNoIdentificadosDAO movNoIdentificadosDAO) {
		this.movNoIdentificadosDAO = movNoIdentificadosDAO;
	}
	public TesoMovimientosDAO getTesoMovimientosDAO() {
		return tesoMovimientosDAO;
	}
	public void setTesoMovimientosDAO(TesoMovimientosDAO tesoMovimientosDAO) {
		this.tesoMovimientosDAO = tesoMovimientosDAO;
	}
}
