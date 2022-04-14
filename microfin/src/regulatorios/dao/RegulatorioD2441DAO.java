package regulatorios.dao;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import regulatorios.bean.RegulatorioD2441Bean;
import general.dao.BaseDAO;
import herramientas.Utileria;

public class RegulatorioD2441DAO extends BaseDAO{

	public RegulatorioD2441DAO() {
		super();
	}
	
	// Consulta para Reporte 
	public List <RegulatorioD2441Bean> reporteRegulatorioD2441Socap(final RegulatorioD2441Bean bean, int tipoReporte){	
		transaccionDAO.generaNumeroTransaccion();
		String query = "call REGULATORIOD2441REP(?,?,?,?,?, ?,?,?,?,?)";

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
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REGULATORIOD2441REP(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				
				RegulatorioD2441Bean beanResponse= new RegulatorioD2441Bean();
				beanResponse.setPeriodo(resultSet.getString("Periodo"));
				beanResponse.setClaveEntidad(resultSet.getString("ClaveEntidad"));
				beanResponse.setSubreporte(resultSet.getString("Subreporte"));
				beanResponse.setTipoCuentaTrans(resultSet.getString("TipoCuentaTrans"));
				beanResponse.setCanalTransaccion(resultSet.getString("CanalTransaccion"));
				beanResponse.setTipoOperacion(resultSet.getString("TipoOperacion"));
				beanResponse.setMontoOperacion(resultSet.getString("MontoOperacion"));
				beanResponse.setNumeroOperaciones(resultSet.getString("NumeroOperaciones"));
				beanResponse.setNumeroClientes(resultSet.getString("NumeroClientes"));


				return beanResponse ;
			}
		});
		return matches;
	}
	
	// Consulta para Reporte 
		public List <RegulatorioD2441Bean> reporteRegulatorioD2441Sofipo(final RegulatorioD2441Bean bean, int tipoReporte){	
			transaccionDAO.generaNumeroTransaccion();
			String query = "call REGULATORIOD2441REP(?,?,?,?,?, ?,?,?,?,?)";

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
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REGULATORIOD2441REP(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					
					RegulatorioD2441Bean beanResponse= new RegulatorioD2441Bean();
					beanResponse.setPeriodo(resultSet.getString("Periodo"));
					beanResponse.setClaveEntidad(resultSet.getString("ClaveEntidad"));
					beanResponse.setSubreporte(resultSet.getString("Subreporte"));
					beanResponse.setTipoCuentaTrans(resultSet.getString("TipoCuentaTrans"));
					beanResponse.setCanalTransaccion(resultSet.getString("CanalTransaccion"));
					beanResponse.setTipoOperacion(resultSet.getString("TipoOperacion"));
					beanResponse.setMontoOperacion(resultSet.getString("MontoOperacion"));
					beanResponse.setNumeroOperaciones(resultSet.getString("NumeroOperaciones"));
					beanResponse.setNumeroClientes(resultSet.getString("NumeroClientes"));


					return beanResponse ;
				}
			});
			return matches;
		}

	
	// Consulta para Reporte 
	public List <RegulatorioD2441Bean> reporteRegulatorioD2441Csv(final RegulatorioD2441Bean bean, int tipoReporte){	
		transaccionDAO.generaNumeroTransaccion();
		String query = "call REGULATORIOD2441REP(?,?,?,?,?, ?,?,?,?,?)";

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
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REGULATORIOD2441REP(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				
				RegulatorioD2441Bean beanResponse= new RegulatorioD2441Bean();
				beanResponse.setValor(resultSet.getString("Valor"));

				return beanResponse ;
			}
		});
		return matches;
	}
	

}
