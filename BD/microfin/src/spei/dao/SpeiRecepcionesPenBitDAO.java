package spei.dao;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;

import general.dao.BaseDAO;
import herramientas.Constantes;
import spei.bean.SpeiRecepcionesPenBitBean;

public class SpeiRecepcionesPenBitDAO extends BaseDAO {
	
		/**
		 * Medotodo que consulta de bitacora las recepciones pendientes no aplicadas en un rango de fechas.
		 * 
		 * @param speiRecepcionesPenBitBean
		 * @param numReporte
		 * @return
		 */
		public List listaRecepcionesNoAplicadas(final SpeiRecepcionesPenBitBean speiRecepcionesPenBitBean, int numReporte){	
			List ListaResultado=null;
			
			try{
			String query = "CALL SPEIRECEPCIONESPENBITLIS(?,?,?,  ?,?,?,?,?,?,?)";

			Object[] parametros ={
					speiRecepcionesPenBitBean.getFechaInicio(),
					speiRecepcionesPenBitBean.getFechaFin(),
					
					numReporte,
					
		    		parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					parametrosAuditoriaBean.getNombrePrograma(),
					parametrosAuditoriaBean.getSucursal(),
					Constantes.ENTERO_CERO
			};
			
			
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"CALL SPEIRECEPCIONESPENBITLIS(  " + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					SpeiRecepcionesPenBitBean speiRecepcionesPenBitBeanResponse = new SpeiRecepcionesPenBitBean();
					speiRecepcionesPenBitBeanResponse.setTipoPagoID(resultSet.getString("TipoPagoID"));
					speiRecepcionesPenBitBeanResponse.setTipoCuentaOrd(resultSet.getString("TipoCuentaOrd"));
					speiRecepcionesPenBitBeanResponse.setCuentaOrd(resultSet.getString("CuentaOrd"));
					speiRecepcionesPenBitBeanResponse.setNombreOrd(resultSet.getString("NombreOrd"));
					speiRecepcionesPenBitBeanResponse.setTipoOperacion(resultSet.getString("TipoOperacion"));
					speiRecepcionesPenBitBeanResponse.setInstiRemitenteID(resultSet.getString("InstiRemitenteID"));
					speiRecepcionesPenBitBeanResponse.setMontoTransferir(resultSet.getString("MontoTransferir"));
					speiRecepcionesPenBitBeanResponse.setRFCOrd(resultSet.getString("RFCOrd"));
					speiRecepcionesPenBitBeanResponse.setCuentaBeneficiario(resultSet.getString("CuentaBeneficiario"));
					speiRecepcionesPenBitBeanResponse.setNombreBeneficiario(resultSet.getString("NombreBeneficiario"));
					speiRecepcionesPenBitBeanResponse.setConceptoPago(resultSet.getString("ConceptoPago"));
					speiRecepcionesPenBitBeanResponse.setClaveRastreo(resultSet.getString("ClaveRastreo"));
					speiRecepcionesPenBitBeanResponse.setCodigoError(resultSet.getString("CodigoError"));
					speiRecepcionesPenBitBeanResponse.setMensajeError(resultSet.getString("MensajeError"));
					speiRecepcionesPenBitBeanResponse.setFechaProceso(resultSet.getString("FechaProceso"));
					speiRecepcionesPenBitBeanResponse.setFechaCaptura(resultSet.getString("FechaCaptura"));
					speiRecepcionesPenBitBeanResponse.setEstatus(resultSet.getString("Estatus"));
					
					return speiRecepcionesPenBitBeanResponse ;
				}
			});
			ListaResultado= matches;
			}catch(Exception e){
				 e.printStackTrace();
				 loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error al consultar las recepciones no aplicadas.", e);
			}
			return ListaResultado;
		}
}
