package arrendamiento.servicio;

import general.servicio.BaseServicio;

import java.util.List;

import arrendamiento.bean.MarcaActivoBean;
import arrendamiento.dao.MarcaActivoDAO;

public class MarcaActivoServicio extends BaseServicio {

	//---------- Variables ------------------------------------------------------------------------
	MarcaActivoDAO marcaActivoDAO = null;
	
	//---------- Tipo de Transacciones ----------------------------------------------------------------	
	public static interface Enum_Tra_MarcaActivo {
	}
		
	//---------- Tipo de Consulta ----------------------------------------------------------------
	public static interface Enum_Con_MarcaActivo {
		int marcasPrincipalCon = 1;
	}
	//---------- Tipo de Lista ----------------------------------------------------------------
	public static interface Enum_Lis_MarcaActivo {
		int marcasPrincipalLis = 1;
	}
	
	public MarcaActivoServicio (){
		super();
	}
	
	/**
	 *  Metodo de Consulta
	 * @param tipoConsulta
	 * @param marcaActivoBean
	 * @return
	 */
	public MarcaActivoBean consulta(int tipoConsulta,  MarcaActivoBean marcaActivoBean){
		MarcaActivoBean marcaActivo = null;
		switch (tipoConsulta) {
			case Enum_Con_MarcaActivo.marcasPrincipalCon:	
				marcaActivo = marcaActivoDAO.consultaMarcaActivo(marcaActivoBean, tipoConsulta);
				break;
		}
		return marcaActivo;
	}
	
	
	/**
	 *  Metodo de Listas
	 * @param tipoLista
	 * @param marcaActivoBean
	 * @return
	 */
	public List lista(int tipoLista, MarcaActivoBean marcaActivoBean){
		List marcasActivo = null;
		switch (tipoLista) {
			case Enum_Lis_MarcaActivo.marcasPrincipalLis:
				marcasActivo = marcaActivoDAO.listaMarcasActivo(marcaActivoBean, tipoLista);
				
				break;
		}		
		return marcasActivo;
	}

	//---------- Getter y Setters ------------------------------------------------------------------------
	public MarcaActivoDAO getMarcaActivoDAO() {
		return marcaActivoDAO;
	}

	public void setMarcaActivoDAO(MarcaActivoDAO marcaActivoDAO) {
		this.marcaActivoDAO = marcaActivoDAO;
	}	
}
