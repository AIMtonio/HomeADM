package tesoreria.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;

import tesoreria.bean.RepDIOTBean;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

public class RepDIOTDAO extends BaseDAO{

	
	public RepDIOTDAO() {
		super();
	}	
	
		/**
		 * Consulta para generar el reporte en Excel regulatorio A1713
		 * @param bean
		 * @param tipoReporte
		 * @return
		 */
		public List <RepDIOTBean> reporteDIOT(final RepDIOTBean bean, int tipoReporte){	
			transaccionDAO.generaNumeroTransaccion();
			String query = "call `CONSULTADIOTREP`(?,?,?,?,?,  ?,?,?,?,?);";
			
			Object[] parametros ={
								bean.getAnio(),
								bean.getMes(),
								tipoReporte,
					    		parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								parametrosAuditoriaBean.getNombrePrograma(),
								parametrosAuditoriaBean.getSucursal(),
								parametrosAuditoriaBean.getNumeroTransaccion()
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CONSULTADIOTREP(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					
				RepDIOTBean beanResponse= new RepDIOTBean();

					
					
					beanResponse.setTipoTercero(resultSet.getString("TipoTercero"));					
					beanResponse.setTipoOperacion(resultSet.getString("TipoOperacionID"));
					beanResponse.setRfc(resultSet.getString("RFC"));
					beanResponse.setNumeroIDFiscal(resultSet.getString("NumIDFiscal"));
					beanResponse.setNombreExtranjero(resultSet.getString("NomExtranjero"));
					
					beanResponse.setPaisResidencia(resultSet.getString("PaisResidencia"));
					beanResponse.setNacionalidad(resultSet.getString("Nacionalidad"));
					beanResponse.setValAcPagQuincePorc(resultSet.getString("ValActPagQuince"));
					beanResponse.setActosPagQuince(resultSet.getString("ActosPagQuince"));
					beanResponse.setMontIvaPagNAQuincePorc(resultSet.getString("MontoIVAPagQuince"));
					
					beanResponse.setValAcPagDiezPorc(resultSet.getString("ValActPagDiez"));
					beanResponse.setActosPagDiez(resultSet.getString("ActosPagDiez"));
					beanResponse.setMontIvaPagNADiezPorc(resultSet.getString("MontoIVAPagDiez"));
					beanResponse.setValAcPagImBienQuincePorc(resultSet.getString("ValActPagImpBienQuince"));					
					beanResponse.setMontIvaPagImpNAQuincePorc(resultSet.getString("MontoIVAImpQuince"));
					
					beanResponse.setValAcPagImBienDiezPorc(resultSet.getString("ValActPagImpBienDiez"));
					beanResponse.setMontIvaPagImpNADiezPorc(resultSet.getString("MontoIVAImpDiez"));
					beanResponse.setValAcPagImpBienExento(resultSet.getString("ValActPagImpBienExentos"));
					beanResponse.setValActPagIVACeroPorc(resultSet.getString("ValActPagCeroIVA"));
					beanResponse.setValActPagExentos(resultSet.getString("ValActPagSinIVA"));
					
					beanResponse.setIVARetenido(resultSet.getString("IVARetenido"));
					beanResponse.setIVADevDescBonif(resultSet.getString("IVADevDescBon"));
					
		
				

					return beanResponse ;
				}
			});
			return matches;
		}
		/**
		 * Consulta del reporte regulatorio A1713 version CSV
		 * @param bean
		 * @param tipoReporte
		 * @return
		 */
		public List <RepDIOTBean> reporteDIOTCsv(final RepDIOTBean bean, int tipoReporte){	
			transaccionDAO.generaNumeroTransaccion();
			String query = "call `CONSULTADIOTREP`(?,?,?,?,?,  ?,?,?,?,?);";

			Object[] parametros ={
								bean.getAnio(),
								bean.getMes(),
								tipoReporte,
					    		parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								parametrosAuditoriaBean.getNombrePrograma(),
								parametrosAuditoriaBean.getSucursal(),
								parametrosAuditoriaBean.getNumeroTransaccion()
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CONSULTADIOTREP(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					
					RepDIOTBean beanResponse= new RepDIOTBean();
					beanResponse.setRenglon(resultSet.getString("Valor"));

					return beanResponse ;
				}
			});
			return matches;
		}
		
		
	
		
		
		
}