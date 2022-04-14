package regulatorios.dao;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import regulatorios.bean.RegulatorioB2422Bean;
import general.dao.BaseDAO;
import herramientas.Utileria;

public class RegulatorioB2422DAO extends BaseDAO{

	public RegulatorioB2422DAO() {
		super();
	}
	
	// Consulta para Reporte 
	public List <RegulatorioB2422Bean> reporteRegulatorioB2422Socap(final RegulatorioB2422Bean bean, int tipoReporte){	
		transaccionDAO.generaNumeroTransaccion();
		String query = "call REGULATORIOB2422REP(?,?,?,?,?,  ?,?,?,?,?)";

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
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REGULATORIOB2422REP(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				
			RegulatorioB2422Bean beanResponse= new RegulatorioB2422Bean();
			beanResponse.setPeriodo(resultSet.getString("Periodo"));
			beanResponse.setClaveEntidad(resultSet.getString("ClaveEntidad"));
			beanResponse.setSubreporte(resultSet.getString("Subreporte"));

			beanResponse.setMunicipio(resultSet.getString("Municipio"));
			beanResponse.setEstado(resultSet.getString("Estado"));
			beanResponse.setTipoInformacion(resultSet.getString("TipoInformacion"));
			beanResponse.setDato(resultSet.getString("Dato"));



				return beanResponse ;
			}
		});
		return matches;
	}
	
	
	
	// Consulta para Reporte 
		public List <RegulatorioB2422Bean> reporteRegulatorioB2422Sofipo(final RegulatorioB2422Bean bean, int tipoReporte){	
			transaccionDAO.generaNumeroTransaccion();
			String query = "call REGULATORIOB2422REP(?,?,?,?,?,  ?,?,?,?,?)";

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
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REGULATORIOB2422REP(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					
				RegulatorioB2422Bean beanResponse= new RegulatorioB2422Bean();
				beanResponse.setPeriodo(resultSet.getString("Periodo"));
				beanResponse.setClaveEntidad(resultSet.getString("ClaveEntidad"));
				beanResponse.setSubreporte(resultSet.getString("Subreporte"));
				
				beanResponse.setLocalidad(resultSet.getString("Localidad"));
				beanResponse.setPais(resultSet.getString("Pais"));
				beanResponse.setMunicipio(resultSet.getString("Municipio"));
				beanResponse.setEstado(resultSet.getString("Estado"));
				beanResponse.setTipoInformacion(resultSet.getString("TipoInformacion"));
				beanResponse.setDato(resultSet.getString("Dato"));



					return beanResponse ;
				}
			});
			return matches;
		}

	
	// Consulta para Reporte 
	public List <RegulatorioB2422Bean> reporteRegulatorioB2422Csv(final RegulatorioB2422Bean bean, int tipoReporte){	
		transaccionDAO.generaNumeroTransaccion();
		String query = "call REGULATORIOB2422REP(?,?,?,?,?, ?,?,?,?,?)";

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
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REGULATORIOB2422REP(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				
				RegulatorioB2422Bean beanResponse= new RegulatorioB2422Bean();
				beanResponse.setValor(resultSet.getString("Valor"));

				return beanResponse ;
			}
		});
		return matches;
	}
	

}
