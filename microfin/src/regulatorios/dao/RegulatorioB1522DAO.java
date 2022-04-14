package regulatorios.dao;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;
 
import regulatorios.bean.RegulatorioB1522Bean;
import general.dao.BaseDAO;
import herramientas.Utileria;

public class RegulatorioB1522DAO extends BaseDAO {
	public RegulatorioB1522DAO() {
		super();
	}
	
	/*
	 * CSV
	 */
	public List <RegulatorioB1522Bean> reporteRegulatorioB1522Csv(final RegulatorioB1522Bean bean, int tipoReporte){	
		transaccionDAO.generaNumeroTransaccion();
		String query = "call REGULATORIOB1522REP(?,?,?,?,?, ?,?,?,?,?)";

		Object[] parametros ={
							Utileria.convierteEntero(bean.getAnio()),
							Utileria.convierteEntero(bean.getMes()),
							tipoReporte,
				    		parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							"RegulatorioB1522DAO.reporteRegulatorioB1522Csv",
							parametrosAuditoriaBean.getSucursal(),
							parametrosAuditoriaBean.getNumeroTransaccion()
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REGULATORIOB1522REP(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				
				RegulatorioB1522Bean beanResponse= new RegulatorioB1522Bean();
				beanResponse.setValor(resultSet.getString("Valor"));

				return beanResponse ;
			}
		});
		return matches;
	}
	
	
	/*
	 * SOFIPO
	 */
	public List <RegulatorioB1522Bean> reporteRegulatorioB1522SOFIPO(final RegulatorioB1522Bean bean, int tipoReporte){	
		transaccionDAO.generaNumeroTransaccion();
		String query = "call REGULATORIOB1522REP(?,?,?,?,?, ?,?,?,?,?)";

		Object[] parametros ={
							Utileria.convierteEntero(bean.getAnio()),
							Utileria.convierteEntero(bean.getMes()),
							tipoReporte,
				    		parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							"RegulatorioB1522DAO.reporteRegulatorioB1522SOFIPO",
							parametrosAuditoriaBean.getSucursal(),
							parametrosAuditoriaBean.getNumeroTransaccion()
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REGULATORIOB1522REP(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				
			RegulatorioB1522Bean beanResponse= new RegulatorioB1522Bean();
			
			beanResponse.setPeriodo(resultSet.getString("Periodo"));
			beanResponse.setClaveEntidad(resultSet.getString("ClaveEntidad"));
			beanResponse.setNumReporte(resultSet.getString("Subreporte"));
			beanResponse.setTipoProducto(resultSet.getString("TipoProducto"));
			beanResponse.setServicios(resultSet.getString("Servicios"));
			beanResponse.setNumUsuarios(resultSet.getString("NumUsuarios"));
			beanResponse.setTipoOperacion(resultSet.getString("TipoOperacion"));
			beanResponse.setNumOperaciones(resultSet.getString("NumOperaciones"));
			beanResponse.setImporte(resultSet.getString("Importe"));
			
			return beanResponse ;
			}
		});
		return matches;
	}
	
	
	
	
}
