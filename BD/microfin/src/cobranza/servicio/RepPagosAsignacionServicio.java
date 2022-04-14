package cobranza.servicio;

import general.servicio.BaseServicio;

import java.util.ArrayList;
import java.util.List;

import cobranza.bean.RepPagosAsignacionBean;
import cobranza.dao.RepPagosAsignacionDAO;

public class RepPagosAsignacionServicio extends BaseServicio{
	RepPagosAsignacionDAO repPagosAsignacionDAO = null;

	public static interface Enum_Rep_AsignaCartera{
			int excelRep = 1;		// Reporte Pagos por Asignacion
		}


	// Reporte de Pagos Asignados
	public List listaPagosAsignados(int tipoLista,RepPagosAsignacionBean pagoAsignacion){		
			List listaCred = null;
			switch(tipoLista){
			case Enum_Rep_AsignaCartera.excelRep:
				listaCred = repPagosAsignacionDAO.reportePagosAsignados(tipoLista,pagoAsignacion);
				break;
			}

			return listaCred;
		}
		
	// Gertter y Setter
	public RepPagosAsignacionDAO getRepPagosAsignacionDAO() {
		return repPagosAsignacionDAO;
	}

	public void setRepPagosAsignacionDAO(RepPagosAsignacionDAO repPagosAsignacionDAO) {
		this.repPagosAsignacionDAO = repPagosAsignacionDAO;
	}

}
