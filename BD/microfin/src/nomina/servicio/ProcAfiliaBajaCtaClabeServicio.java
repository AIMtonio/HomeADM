package nomina.servicio;

import java.util.List;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import nomina.bean.ProcAfiliaBajaCtaClabeBean;
import nomina.bean.ResultadoCargaArchivosAfiliacionBean;
import nomina.dao.ProcAfiliaBajaCtaClabeDAO;


public class ProcAfiliaBajaCtaClabeServicio extends BaseServicio{
	ProcAfiliaBajaCtaClabeDAO procAfiliaBajaCtaClabeDAO = null;

	public ProcAfiliaBajaCtaClabeServicio (){
		super();
	}
	
	// -------------- Tipo Transaccion ----------------
	public static interface Enum_Tipo_Transaccion{
		int procesar     = 1;
	}
	
	// -------------- Tipo Lista ----------------
	public static interface Enum_Lis_Afiliacion{
		int porProcesar	= 1;
	}
	
	/**
	 * 
	 * @param tipoTransaccion : Procesar Afiliacion/Bajas Cuenta Clabe
	 * @param procAfiliaBajaCtaClabeBean
	 * @return
	 */
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion,List procAfiliaBajaCtaClabeBean) {
	 	MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) {
		case Enum_Tipo_Transaccion.procesar:
				mensaje = procAfiliaBajaCtaClabeDAO.procesaAfiliacionBajasCuentaClabe(procAfiliaBajaCtaClabeBean);
			break;
		}
		return mensaje;
	}
	
	/**
	 * 
	 * @param rutaArchivo : Ruta de Alojamiento del Archivo de Afiliación
	 * @param procAfiliaBajaCtaClabeBean
	 * @return
	 */
	public ResultadoCargaArchivosAfiliacionBean cargaArchivoAfiliacion(String rutaArchivo, ProcAfiliaBajaCtaClabeBean procAfiliaBajaCtaClabeBean){
		
			ResultadoCargaArchivosAfiliacionBean resultadoCarga = new ResultadoCargaArchivosAfiliacionBean();
			resultadoCarga = procAfiliaBajaCtaClabeDAO.cargaArchivo(rutaArchivo, procAfiliaBajaCtaClabeBean);
			
			if(resultadoCarga.getNumero()==0){
				resultadoCarga.setNumero(0);
				resultadoCarga.setConsecutivoInt("123");
				resultadoCarga.setConsecutivoString("0000123");
				
				if(resultadoCarga.getExitosos() <= 0){
					resultadoCarga.setDescripcion(resultadoCarga.getDescripcion());
				}
				
				resultadoCarga.setDescripcion("Proceso Exitoso."+
						"\n"+resultadoCarga.getDescripcion());
				resultadoCarga.setNombreControl("0");
			}
		return resultadoCarga;	
	}
	
	/**
	 * 
	 * @param tipoLista : Lista para Procesar Afiliacion/Bajas Cuenta Clabe
	 * @param procAfiliaBajaCtaClabeBean
	 * @return
	 */
	public List lista(int tipoLista, ProcAfiliaBajaCtaClabeBean procAfiliaBajaCtaClabeBean){
		List afiliacionLista = null;
		 switch (tipoLista) {
		    case  Enum_Lis_Afiliacion.porProcesar:          
		    	afiliacionLista = procAfiliaBajaCtaClabeDAO.listaPorProcesar(procAfiliaBajaCtaClabeBean, tipoLista);
		    break;
		}
		return afiliacionLista;
	}
	
	// ====================== GETTER & SETTER ================ //
	
	public ProcAfiliaBajaCtaClabeDAO getProcAfiliaBajaCtaClabeDAO() {
		return procAfiliaBajaCtaClabeDAO;
	}

	public void setProcAfiliaBajaCtaClabeDAO(ProcAfiliaBajaCtaClabeDAO procAfiliaBajaCtaClabeDAO) {
		this.procAfiliaBajaCtaClabeDAO = procAfiliaBajaCtaClabeDAO;
	}
	
	
}
