package credito.servicio;

import java.io.ByteArrayOutputStream;
import java.util.List;

import reporte.ParametrosReporte;
import reporte.Reporte;
import credito.bean.RompimientoGrupoBean;
import credito.dao.RompimientoGrupoDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import herramientas.Utileria;
 
public class RompimientoGrupoServicio extends BaseServicio {
	
	
	/* Declaracion de Variables */
	RompimientoGrupoDAO rompimientoGrupoDAO = null;


	public RompimientoGrupoServicio() {
		super();
	}
	
	
	/*Enumera los tipo de transaccion */
	public static interface Enum_Transaccion {
		int procesar	  = 1;
		int rompimientoWS = 2;
		int bitacora 	  = 3;
	}
	
	/*Enumera los tipo de lista */
	public static interface Enum_Lista {
		int creditosGrid	 = 11;
	}

	public static interface Enum_Con_RompimientoGrupo{
		int funcionExibileGrupal = 2;
	}

	/* ========================== TRANSACCIONES ==============================  */


	/* Controla el tipo de transaccion que se debe ejecutar (alta,modifica,actualiza u otro que regrese datos(numError, MsjError,control y consecutivo))*/
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion,  RompimientoGrupoBean bean){
		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) {		
			case Enum_Transaccion.procesar:
				mensaje = rompimientoGrupoDAO.procesar(bean);					
			break;	
			case Enum_Transaccion.rompimientoWS:
				mensaje = rompimientoGrupoDAO.rompimientoWebService(bean);					
			break;	
			case Enum_Transaccion.bitacora:
				mensaje = rompimientoGrupoDAO.bitacoraRompimiento(bean);					
			break;
		}
		return mensaje;
	}
	
	public RompimientoGrupoBean consulta(int tipoConsulta, RompimientoGrupoBean rompimientoGrupoBean) {

		RompimientoGrupoBean RompimientoGrupo = null;
		try{
			switch(tipoConsulta){
				case Enum_Con_RompimientoGrupo.funcionExibileGrupal:
					RompimientoGrupo = rompimientoGrupoDAO.funcionExibileGrupal(rompimientoGrupoBean, tipoConsulta);
				break;
			}

		} catch(Exception exception){
			loggerSAFI.error("Ha ocurrido un Error al realizar la Consulta de Rompimiento de Grupos ", exception);
			exception.printStackTrace();
		}
		return RompimientoGrupo;
	}
	
	/* Controla el tipo de lista que se debe utilizar */ 
	public List lista(int tipoLista, RompimientoGrupoBean bean){		
		List listaResultado = null;
		switch (tipoLista) {
			case Enum_Lista.creditosGrid:		
				listaResultado = rompimientoGrupoDAO.listaIntegrantesGrupo(bean, tipoLista);	
			break;	
		}	
		
	return listaResultado;
	}
	
	//Se crea el Reporte de Rompimiento de Grupo
	public ByteArrayOutputStream creaRepRompimientoGrupoPDF(RompimientoGrupoBean rompimientoGrupo,String nomReporte) throws Exception{
		ParametrosReporte parametrosReporte = new ParametrosReporte();

		parametrosReporte.agregaParametro("Par_FechaInicio",rompimientoGrupo.getFechaInicio());
		parametrosReporte.agregaParametro("Par_FechaFin",rompimientoGrupo.getFechaVencimiento());
		parametrosReporte.agregaParametro("Par_GrupoID",Utileria.convierteEntero(rompimientoGrupo.getGrupoID()));
		parametrosReporte.agregaParametro("Par_SucursalID",Utileria.convierteEntero(rompimientoGrupo.getSucursalID()));
		parametrosReporte.agregaParametro("Par_UsuarioID",Utileria.convierteEntero(rompimientoGrupo.getUsuarioID()));
		parametrosReporte.agregaParametro("Par_FechaEmision",rompimientoGrupo.getFechaActual());

		parametrosReporte.agregaParametro("Par_NombreGrupo",(!rompimientoGrupo.getNombreGrupo().isEmpty())? rompimientoGrupo.getNombreGrupo():"TODOS");
		parametrosReporte.agregaParametro("Par_NombreSucursal",(!rompimientoGrupo.getNombreSucursal().isEmpty())? rompimientoGrupo.getNombreSucursal():"TODOS");
		parametrosReporte.agregaParametro("Par_NombreUsuario",(!rompimientoGrupo.getNombreUsuario().isEmpty())? rompimientoGrupo.getNombreUsuario():"TODOS");
		
		parametrosReporte.agregaParametro("Par_NomUsuario",(!rompimientoGrupo.getNomUsuario().isEmpty())? rompimientoGrupo.getNomUsuario():"TODOS");
	    parametrosReporte.agregaParametro("Par_NomInstitucion",(!rompimientoGrupo.getNombreInstitucion().isEmpty())? rompimientoGrupo.getNombreInstitucion():"TODOS");
				
		return Reporte.creaPDFReporte(nomReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}
	
	//* ============== GETTER & SETTER =============  //*	
	public RompimientoGrupoDAO getRompimientoGrupoDAO() {
		return rompimientoGrupoDAO;
	}
	
	public void setRompimientoGrupoDAO(RompimientoGrupoDAO rompimientoGrupoDAO) {
		this.rompimientoGrupoDAO = rompimientoGrupoDAO;
	}
		
}
