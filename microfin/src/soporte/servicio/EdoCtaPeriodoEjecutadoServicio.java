package soporte.servicio;

import general.servicio.BaseServicio;
import herramientas.Utileria;

import java.util.List;

import cliente.bean.ClienteBean;
import cliente.servicio.ActividadesFRServicio.Enum_Lis_Actividad;
import cliente.servicio.ClienteServicio.Enum_Con_Cliente;

import soporte.bean.EdoCtaPerEjecutadoBean;
import soporte.dao.EdoCtaPeriodoEjecutadoDAO;

public class EdoCtaPeriodoEjecutadoServicio extends BaseServicio{
	EdoCtaPeriodoEjecutadoDAO edoCtaPeriodoEjecutadoDAO = new EdoCtaPeriodoEjecutadoDAO();
	
	public EdoCtaPeriodoEjecutadoServicio(){
		super();
	}
				
	public static interface Enum_Lis_PerEjecutado{
		int listaMeses = 1;	
		int listaSemestres = 2;		
		int listaPorMes = 3;	
	}
	
	public static interface Enum_Con_PerEjecutado{
		int conPeriodo = 2 ;	
			
	}
	// listas para comboBox Periodo
	public  Object[] listaCombo(int tipoLista) {	
		List listaBean = null;
		switch(tipoLista){
			case Enum_Lis_PerEjecutado.listaMeses: 
				listaBean =  edoCtaPeriodoEjecutadoDAO.listaMesesEjecutados(tipoLista);
				break;
			case Enum_Lis_PerEjecutado.listaSemestres: 
				listaBean =  edoCtaPeriodoEjecutadoDAO.listaSemestresEjecutados(tipoLista);
				break;
			
		}
		
		return listaBean.toArray();		
	}
	
	// listas para comboBox
	public  List  lista(EdoCtaPerEjecutadoBean periodo, int tipoLista ) {
		
		List listaPeriodo = null;
		try{
		switch(tipoLista){
		case Enum_Lis_PerEjecutado.listaPorMes: 
			listaPeriodo =  edoCtaPeriodoEjecutadoDAO.listaPorMeses(periodo,tipoLista);
			break;

		}
		
		// listaActividadesCombo.toArray();
		 }
		catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error("Error en la lista de periodo mensual" + e);
			
		}
		return listaPeriodo; 
	}
	
	public EdoCtaPerEjecutadoBean consulta(int tipoConsulta, EdoCtaPerEjecutadoBean edoCtaPerEjecutadoBean){
		EdoCtaPerEjecutadoBean edoCtaPerEjecutado = null;
		switch (tipoConsulta) {
			case Enum_Con_PerEjecutado.conPeriodo:		
				edoCtaPerEjecutado = edoCtaPeriodoEjecutadoDAO.consultaPeriodo(edoCtaPerEjecutadoBean, tipoConsulta);				
				break;		
		}
		
		return edoCtaPerEjecutado;
	}
	

	public EdoCtaPeriodoEjecutadoDAO getEdoCtaPeriodoEjecutadoDAO() {
		return edoCtaPeriodoEjecutadoDAO;
	}

	public void setEdoCtaPeriodoEjecutadoDAO(
			EdoCtaPeriodoEjecutadoDAO edoCtaPeriodoEjecutadoDAO) {
		this.edoCtaPeriodoEjecutadoDAO = edoCtaPeriodoEjecutadoDAO;
	}

}
