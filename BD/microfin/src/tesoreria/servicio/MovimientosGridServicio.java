package tesoreria.servicio;

import java.util.List;

import tesoreria.bean.MovimientosGridBean;
import tesoreria.dao.MovimientosGridDAO;
import general.servicio.BaseServicio;

public class MovimientosGridServicio extends BaseServicio{

	//---------- Variables ------------------------------------------------------------------------

	MovimientosGridDAO  movimientosGridDAO = null;
	
	public MovimientosGridServicio() {
		super();
	}

	//---------- Tipos de Consultas---------------------------------------------------------------

	public static interface Enum_Con_MovimientosGrid {
		int principal = 1;
		int foranea = 2;
	}
	
	//---------- Metodo Lista de movimientos en TESORERIAMOVS Y MOVSCONCILIA ---------------------------------------------------------------

	public List movimientos(int tipoLista, MovimientosGridBean movimientosGridBean){
		List listaMov = null;
		switch (tipoLista) {
			case Enum_Con_MovimientosGrid.principal:
		
				listaMov = movimientosGridDAO.listaConsultaMovs(movimientosGridBean,tipoLista);
			break;
		}
		return listaMov;
	}


	//------------------ Geters y Seters ------------------------------------------------------	

	public MovimientosGridDAO getMovimientosGridDAO() {
		return movimientosGridDAO;
	}

	public void setMovimientosGridDAO(MovimientosGridDAO movimientosGridDAO) {
		this.movimientosGridDAO = movimientosGridDAO;
	}
}
