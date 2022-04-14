package regulatorios.dao;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import regulatorios.bean.RegulatorioB2421Bean;
import general.dao.BaseDAO;
import herramientas.Utileria;

public class RegulatorioB2421DAO extends BaseDAO{

	public RegulatorioB2421DAO() {
		super();
	}
	
	// Consulta para Reporte 
	public List <RegulatorioB2421Bean> reporteRegulatorioB2421Socap(final RegulatorioB2421Bean bean, int tipoReporte){	
		transaccionDAO.generaNumeroTransaccion();
		String query = "call REGULATORIOB2421REP(?,?,?,?,?,  ?,?,?,?,?)";

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
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REGULATORIOB2421REP(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				
			RegulatorioB2421Bean beanResponse= new RegulatorioB2421Bean();
			beanResponse.setPeriodo(resultSet.getString("Periodo"));
			beanResponse.setClaveEntidad(resultSet.getString("ClaveEntidad"));
			beanResponse.setSubreporte(resultSet.getString("Formulario"));
			
			beanResponse.setLocalidad(resultSet.getString("Localidad"));
			beanResponse.setMunicipio(resultSet.getString("MunicipioID"));
			beanResponse.setEstado(resultSet.getString("EstadoID"));
			beanResponse.setPais(resultSet.getString("CodigoPais"));
			beanResponse.setFechaContratacion(resultSet.getString("FechaContratacion"));
			beanResponse.setClasfContable(resultSet.getString("ClasfContable"));
			beanResponse.setTipoProducto(resultSet.getString("TipoProducto"));
			beanResponse.setMoneda(resultSet.getString("Moneda"));
			beanResponse.setPersJuridica(resultSet.getString("PersJuridica"));
			beanResponse.setGenero(resultSet.getString("Genero"));
			beanResponse.setSaldoFinal(resultSet.getString("SaldoFinal"));



				return beanResponse ;
			}
		});
		return matches;
	}
	
	
	
	// Consulta para Reporte 
		public List <RegulatorioB2421Bean> reporteRegulatorioB2421Sofipo(final RegulatorioB2421Bean bean, int tipoReporte){	
			transaccionDAO.generaNumeroTransaccion();
			String query = "call REGULATORIOB2421REP(?,?,?, ?,?,  ?,?,?,?,?)";

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
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REGULATORIOB2421REP(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					
				RegulatorioB2421Bean beanResponse= new RegulatorioB2421Bean();
				beanResponse.setPeriodo(resultSet.getString("Periodo"));
				beanResponse.setClaveEntidad(resultSet.getString("ClaveEntidad"));
				beanResponse.setSubreporte(resultSet.getString("Formulario"));
				
				beanResponse.setLocalidad(resultSet.getString("Localidad"));
				beanResponse.setMunicipio(resultSet.getString("MunicipioID"));
				beanResponse.setEstado(resultSet.getString("EstadoID"));
				beanResponse.setPais(resultSet.getString("CodigoPais"));
				beanResponse.setFechaContratacion(resultSet.getString("FechaContratacion"));
				beanResponse.setClasfContable(resultSet.getString("ClasfContable"));
				beanResponse.setTipoProducto(resultSet.getString("TipoProducto"));
				beanResponse.setMoneda(resultSet.getString("Moneda"));
				beanResponse.setPersJuridica(resultSet.getString("PersJuridica"));
				beanResponse.setGenero(resultSet.getString("Genero"));
				beanResponse.setSaldoFinal(resultSet.getString("SaldoFinal"));

					return beanResponse ;
				}
			});
			return matches;
		}

	
	// Consulta para Reporte 
	public List <RegulatorioB2421Bean> reporteRegulatorioB2421Csv(final RegulatorioB2421Bean bean, int tipoReporte){	
		transaccionDAO.generaNumeroTransaccion();
		String query = "call REGULATORIOB2421REP(?,?,?,?,?, ?,?,?,?,?)";

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
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REGULATORIOB2421REP(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				
				RegulatorioB2421Bean beanResponse= new RegulatorioB2421Bean();
				beanResponse.setValor(resultSet.getString("Valor"));

				return beanResponse ;
			}
		});
		return matches;
	}
	

}
