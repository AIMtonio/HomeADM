package tarjetas.servicio;

import java.util.List;

import tarjetas.bean.TarDebMovsGridBean;
import tarjetas.dao.TarDebMovsGridDAO;
import general.servicio.BaseServicio;

public class TarDebMovsGridServicio extends BaseServicio{

	TarDebMovsGridDAO tarDebMovsGridDAO = null;
	public TarDebMovsGridServicio(){
		super();
	}
	
	public static interface Enum_Con_MovsGrid {
		int principal = 1;
		int foranea = 2;
	}
	//---------- Metodo Lista de movimientos en TESORERIAMOVS Y MOVSCONCILIA ---------------------------------------------------------------

	public List movsTarjetas(int tipoLista, TarDebMovsGridBean tarDebMovsBean){
		List listaMov = null;
		switch (tipoLista) {
			case Enum_Con_MovsGrid.principal:		
				listaMov = tarDebMovsGridDAO.listaConsultaMovs(tarDebMovsBean,tipoLista);
			break;
		}
		return listaMov;
	}


	public final TarDebMovsGridDAO getTarDebMovsGridDAO() {
		return tarDebMovsGridDAO;
	}
	public final void setTarDebMovsGridDAO(TarDebMovsGridDAO tarDebMovsGridDAO) {
		this.tarDebMovsGridDAO = tarDebMovsGridDAO;
	}
	
}
