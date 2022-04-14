package arrendamiento.servicio;

import general.servicio.BaseServicio;

import java.util.List;

import arrendamiento.bean.SubtipoActivoBean;
import arrendamiento.dao.SubtipoActivoDAO;

public class SubtipoActivoServicio extends BaseServicio {

	//---------- Variables ------------------------------------------------------------------------
	SubtipoActivoDAO subtipoActivoDAO = null;
	
	//---------- Tipo de Transacciones ----------------------------------------------------------------	
	public static interface Enum_Tra_SubtipoActivo {
	}
		
	//---------- Tipo de Consulta ----------------------------------------------------------------
	public static interface Enum_Con_SubtipoActivo {
		int subtiposPrincipal = 1;
	}
	//---------- Tipo de Lista ----------------------------------------------------------------
	public static interface Enum_Lis_SubtipoActivo {
		int subtipos = 1;
	}
	
	public SubtipoActivoServicio (){
		super();
	}
	
	/**
	 * Metodo de Consulta
	 * @param tipoConsulta
	 * @param subtipoActivoBean
	 * @return
	 */
	public SubtipoActivoBean consulta(int tipoConsulta,  SubtipoActivoBean subtipoActivoBean){
		SubtipoActivoBean subtipo = null;
		switch (tipoConsulta) {
			case Enum_Con_SubtipoActivo.subtiposPrincipal:	
				subtipo = subtipoActivoDAO.consultaSubtipoActivo(subtipoActivoBean, tipoConsulta);
				break;
		}
		return subtipo;
	}
	
	
	/**
	 * Metodo de listas
	 * @param tipoLista
	 * @param subtipoActivoBean
	 * @return
	 */
	public List lista(int tipoLista, SubtipoActivoBean subtipoActivoBean){
		List subtipos = null;
		switch (tipoLista) {
			case Enum_Lis_SubtipoActivo.subtipos:
				subtipos = subtipoActivoDAO.listaSubtiposActivo(subtipoActivoBean, tipoLista);
				
				break;
		}		
		return subtipos;
	}
	
	//---------- Getter y Setters ------------------------------------------------------------------------
	public SubtipoActivoDAO getSubtipoActivoDAO() {
		return subtipoActivoDAO;
	}

	public void setSubtipoActivoDAO(SubtipoActivoDAO subtipoActivoDAO) {
		this.subtipoActivoDAO = subtipoActivoDAO;
	}
	
}
