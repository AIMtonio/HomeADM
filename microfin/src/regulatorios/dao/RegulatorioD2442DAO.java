package regulatorios.dao;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import regulatorios.bean.RegulatorioD2442Bean;
import general.dao.BaseDAO;
import herramientas.Utileria;

public class RegulatorioD2442DAO extends BaseDAO{

	public RegulatorioD2442DAO() {
		super();
	}
	
	// Consulta para Reporte
	public List <RegulatorioD2442Bean> reporteRegulatorioD2442Socap(final RegulatorioD2442Bean bean, int tipoReporte){	
		transaccionDAO.generaNumeroTransaccion();
		String query = "call REGULATORIOD2442REP(?,?,?,?,?, ?,?,?,?,?)";

		Object[] parametros ={
							Utileria.convierteEntero(bean.getAnio()),
							Utileria.convierteEntero(bean.getPeriodo()),
							tipoReporte,
				    		parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							parametrosAuditoriaBean.getNombrePrograma(),
							parametrosAuditoriaBean.getSucursal(),
							parametrosAuditoriaBean.getNumeroTransaccion()
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REGULATORIOD2442REP(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				
				RegulatorioD2442Bean beanResponse= new RegulatorioD2442Bean();
				beanResponse.setPeriodo(resultSet.getString("Periodo"));
				beanResponse.setClaveEntidad(resultSet.getString("ClaveEntidad"));
				beanResponse.setSubreporte(resultSet.getString("Subreporte"));
				beanResponse.setTipoCuentaTrans(resultSet.getString("TipoCuentaTrans"));
				beanResponse.setCanalTransaccion(resultSet.getString("CanalTransaccion"));
				beanResponse.setTipoOperacion(resultSet.getString("TipoOperacion"));
				beanResponse.setFrecuencia(resultSet.getString("Frecuencia"));
				beanResponse.setNumeroCuentas(resultSet.getString("NumeroCuentas"));

				return beanResponse ;
			}
		});
		return matches;
	}

	
	
	// Consulta para Reporte
		public List <RegulatorioD2442Bean> reporteRegulatorioD2442Sofipo(final RegulatorioD2442Bean bean, int tipoReporte){	
			transaccionDAO.generaNumeroTransaccion();
			String query = "call REGULATORIOD2442REP(?,?,?,?,?, ?,?,?,?,?)";

			Object[] parametros ={
								Utileria.convierteEntero(bean.getAnio()),
								Utileria.convierteEntero(bean.getPeriodo()),
								tipoReporte,
					    		parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								parametrosAuditoriaBean.getNombrePrograma(),
								parametrosAuditoriaBean.getSucursal(),
								parametrosAuditoriaBean.getNumeroTransaccion()
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REGULATORIOD2442REP(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					
					RegulatorioD2442Bean beanResponse= new RegulatorioD2442Bean();
					beanResponse.setPeriodo(resultSet.getString("Periodo"));
					beanResponse.setClaveEntidad(resultSet.getString("ClaveEntidad"));
					beanResponse.setSubreporte(resultSet.getString("Subreporte"));
					beanResponse.setTipoCuentaTrans(resultSet.getString("TipoCuentaTrans"));
					beanResponse.setCanalTransaccion(resultSet.getString("CanalTransaccion"));
					beanResponse.setTipoOperacion(resultSet.getString("TipoOperacion"));
					beanResponse.setFrecuencia(resultSet.getString("Frecuencia"));
					beanResponse.setNumeroCuentas(resultSet.getString("NumeroCuentas"));

					return beanResponse ;
				}
			});
			return matches;
		}

	
	// Consulta para Reporte Csv
	public List <RegulatorioD2442Bean> reporteRegulatorioD2442Csv(final RegulatorioD2442Bean bean, int tipoReporte){	
		transaccionDAO.generaNumeroTransaccion();
		String query = "call REGULATORIOD2442REP(?,?,?,?,?, ?,?,?,?,?)";

		Object[] parametros ={
							Utileria.convierteEntero(bean.getAnio()),
							Utileria.convierteEntero(bean.getPeriodo()),
							tipoReporte,
				    		parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							parametrosAuditoriaBean.getNombrePrograma(),
							parametrosAuditoriaBean.getSucursal(),
							parametrosAuditoriaBean.getNumeroTransaccion()
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REGULATORIOD2442REP(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				
				RegulatorioD2442Bean beanResponse= new RegulatorioD2442Bean();
				beanResponse.setValor(resultSet.getString("Valor"));

				return beanResponse ;
			}
		});
		return matches;
	}
	

}
