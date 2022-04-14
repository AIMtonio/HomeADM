package regulatorios.dao;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;
 
import regulatorios.bean.RegulatorioB1523Bean;
import general.dao.BaseDAO;
import herramientas.Utileria;

public class RegulatorioB1523DAO extends BaseDAO {
	public RegulatorioB1523DAO() {
		super();
	}
	
	/*
	 * CSV
	 */
	public List <RegulatorioB1523Bean> reporteRegulatorioB1523Csv(final RegulatorioB1523Bean bean, int tipoReporte){	
		transaccionDAO.generaNumeroTransaccion();
		String query = "call REGULATORIOB1523REP(?,?,?,?,?, ?,?,?,?,?)";

		Object[] parametros ={
							Utileria.convierteEntero(bean.getAnio()),
							Utileria.convierteEntero(bean.getMes()),
							tipoReporte,
				    		parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							"RegulatorioB1522DAO.reporteRegulatorioB1523Csv",
							parametrosAuditoriaBean.getSucursal(),
							parametrosAuditoriaBean.getNumeroTransaccion()
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REGULATORIOB1523REP(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				
				RegulatorioB1523Bean beanResponse= new RegulatorioB1523Bean();
				beanResponse.setValor(resultSet.getString("Valor"));

				return beanResponse ;
			}
		});
		return matches;
	}
	
	
	
	/*
	 * SOFIPO
	 */
	public List <RegulatorioB1523Bean> reporteRegulatorioB1523SOFIPO(final RegulatorioB1523Bean bean, int tipoReporte){	
		transaccionDAO.generaNumeroTransaccion();
		String query = "call REGULATORIOB1523REP(?,?,?,?,?, ?,?,?,?,?)";

		Object[] parametros ={
							Utileria.convierteEntero(bean.getAnio()),
							Utileria.convierteEntero(bean.getMes()),
							tipoReporte,
				    		parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							"RegulatorioB1522DAO.reporteRegulatorioB1523SOFIPO",
							parametrosAuditoriaBean.getSucursal(),
							parametrosAuditoriaBean.getNumeroTransaccion()
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REGULATORIOB1523REP(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				
			RegulatorioB1523Bean beanResponse= new RegulatorioB1523Bean();
			
			beanResponse.setPeriodo(resultSet.getString("Periodo"));
			beanResponse.setClaveEntidad(resultSet.getString("ClaveEntidad"));
			beanResponse.setNumReporte(resultSet.getString("Subreporte"));
			beanResponse.setServicios(resultSet.getString("Servicios"));
			beanResponse.setPersJuridica(resultSet.getString("PersJuridica"));
			beanResponse.setTipoCliente(resultSet.getString("TipoCliente"));
			beanResponse.setNivelCuenta(resultSet.getString("NivelCuenta"));
			beanResponse.setTipoOperacion(resultSet.getString("TipoOperacion"));
			beanResponse.setNumClientes(resultSet.getString("NumClientes"));
			beanResponse.setNumOperaciones(resultSet.getString("NumOperaciones"));
			beanResponse.setImporte(resultSet.getString("Importe"));
			
			return beanResponse ;
			}
		});
		return matches;
	}
	
	
	
	
}
