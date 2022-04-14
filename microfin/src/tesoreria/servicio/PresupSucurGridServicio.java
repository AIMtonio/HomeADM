package tesoreria.servicio;

import java.util.List;

import credito.servicio.ProductosCreditoServicio.Enum_Lis_ProductosCredito;
import general.servicio.BaseServicio;
import tesoreria.bean.PresupuestoSucursalBean;
import tesoreria.dao.PresupuestoSucursalDAO;

public class PresupSucurGridServicio extends BaseServicio {
	
	PresupuestoSucursalDAO presupSucursalDAO = null;
	
	
	public static interface Enum_Con_DispersionGrid {
		int principal = 1;
		int foranea = 2;
	}
	
	public PresupSucurGridServicio(){
		
		super();
	}

	//---------- Tipos de Consultas---------------------------------------------------------------
	
	public List listaGrid(int tipoLista, PresupuestoSucursalBean presupuestoSucursalBean){
		List presupSucursalLista = null;

		switch (tipoLista) {
	        case  Enum_Lis_ProductosCredito.principal:
	        	presupSucursalLista = presupSucursalDAO.listaGrid(tipoLista, presupuestoSucursalBean );
	        break;        
		}
		return presupSucursalLista;
	}

	//Getters y Setters
	public PresupuestoSucursalDAO getPresupSucursalDAO() {
		return presupSucursalDAO;
	}

	public void setPresupSucursalDAO(PresupuestoSucursalDAO presupSucursalDAO) {
		this.presupSucursalDAO = presupSucursalDAO;
	}

}
