package regulatorios.dao;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;
 
import regulatorios.bean.RegulatorioB1524Bean;
import general.dao.BaseDAO;
import herramientas.Utileria;

public class RegulatorioB1524DAO extends BaseDAO {
	public RegulatorioB1524DAO() {
		super();
	}
	
	/*
	 * CSV
	 */
	public List <RegulatorioB1524Bean> reporteRegulatorioB1524Csv(final RegulatorioB1524Bean bean, int tipoReporte){	
		transaccionDAO.generaNumeroTransaccion();
		String query = "call REGULATORIOB1524REP(?,?,?,?,?, ?,?,?,?,?)";

		Object[] parametros ={
							Utileria.convierteEntero(bean.getAnio()),
							Utileria.convierteEntero(bean.getMes()),
							tipoReporte,
				    		parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							"RegulatorioB1522DAO.reporteRegulatorioB1524Csv",
							parametrosAuditoriaBean.getSucursal(),
							parametrosAuditoriaBean.getNumeroTransaccion()
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REGULATORIOB1524REP(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				
				RegulatorioB1524Bean beanResponse= new RegulatorioB1524Bean();
				beanResponse.setValor(resultSet.getString("Valor"));

				return beanResponse ;
			}
		});
		return matches;
	}
	
	
	
	/*
	 * SOFIPO
	 */
	public List <RegulatorioB1524Bean> reporteRegulatorioB1524SOFIPO(final RegulatorioB1524Bean bean, int tipoReporte){	
		transaccionDAO.generaNumeroTransaccion();
		String query = "call REGULATORIOB1524REP(?,?,?,?,?, ?,?,?,?,?)";

		Object[] parametros ={
							Utileria.convierteEntero(bean.getAnio()),
							Utileria.convierteEntero(bean.getMes()),
							tipoReporte,
				    		parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							"RegulatorioB1522DAO.reporteRegulatorioB1524SOFIPO",
							parametrosAuditoriaBean.getSucursal(),
							parametrosAuditoriaBean.getNumeroTransaccion()
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REGULATORIOB1524REP(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				
			RegulatorioB1524Bean beanResponse= new RegulatorioB1524Bean();
			
			beanResponse.setPeriodo(resultSet.getString("Periodo"));
			beanResponse.setClaveEntidad(resultSet.getString("ClaveEntidad"));
			beanResponse.setNumReporte(resultSet.getString("Subreporte"));
			beanResponse.setServicios(resultSet.getString("Servicios"));
			beanResponse.setPersJuridica(resultSet.getString("PersJuridica"));
			beanResponse.setTipoCliente(resultSet.getString("TipoCliente"));
			beanResponse.setNumClientes(resultSet.getString("NumClientes"));
			beanResponse.setNumFacultadas(resultSet.getString("NumFacultadas"));
			beanResponse.setNumOperaron(resultSet.getString("NumOperaron"));
			
			return beanResponse ;
			}
		});
		return matches;
	}
	
	
	
	
}
