package arrendamiento.servicio;

import general.servicio.BaseServicio;

import java.util.List;

import arrendamiento.bean.AseguradoraActivoBean;
import arrendamiento.dao.AseguradoraActivoDAO;
import arrendamiento.servicio.SubtipoActivoServicio.Enum_Con_SubtipoActivo;
import arrendamiento.servicio.SubtipoActivoServicio.Enum_Lis_SubtipoActivo;

public class AseguradoraActivoServicio extends BaseServicio {

	//---------- Variables ------------------------------------------------------------------------
	AseguradoraActivoDAO AseguradoraActivoDAO = null;
	
	//---------- Tipo de Transacciones ----------------------------------------------------------------	
	public static interface Enum_Tra_AseguradoraActivo {
	}
		
	//---------- Tipo de Consulta ----------------------------------------------------------------
	public static interface Enum_Con_AseguradoraActivo {
		int principalAseguradora = 1;
	}
	//---------- Tipo de Lista ----------------------------------------------------------------
	public static interface Enum_Lis_AseguradoraActivo {
		int aseguradoraLis = 1;
	}
	
	public AseguradoraActivoServicio (){
		super();
	}
	
	/**
	 *  Metodo de Consulta
	 * @param tipoConsulta
	 * @param aseguradoraActivoBean
	 * @return
	 */
	public AseguradoraActivoBean consulta(int tipoConsulta,  AseguradoraActivoBean aseguradoraActivoBean){
		AseguradoraActivoBean aseguradoraActivo = null;
		switch (tipoConsulta) {
			case Enum_Con_SubtipoActivo.subtiposPrincipal:	
				aseguradoraActivo = AseguradoraActivoDAO.consultaAseguradoraActivo(aseguradoraActivoBean, tipoConsulta);
				break;
		}
		return aseguradoraActivo;
	}
	
	
	/**
	 * Metodo de listas
	 * @param tipoLista
	 * @param aseguradoraActivoBean
	 * @return
	 */
	public List lista(int tipoLista, AseguradoraActivoBean aseguradoraActivoBean){
		List aseguradorasLis = null;
		switch (tipoLista) {
			case Enum_Lis_SubtipoActivo.subtipos:
				aseguradorasLis = AseguradoraActivoDAO.listaAseguradorasActivo(aseguradoraActivoBean, tipoLista);
				
				break;
		}		
		return aseguradorasLis;
	}

	//---------- Getter y Setters ------------------------------------------------------------------------
	public AseguradoraActivoDAO getAseguradoraActivoDAO() {
		return AseguradoraActivoDAO;
	}

	public void setAseguradoraActivoDAO(AseguradoraActivoDAO aseguradoraActivoDAO) {
		AseguradoraActivoDAO = aseguradoraActivoDAO;
	}	
}
