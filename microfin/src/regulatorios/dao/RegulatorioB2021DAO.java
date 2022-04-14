package regulatorios.dao;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;
 
import regulatorios.bean.RegulatorioB2021Bean;
import general.dao.BaseDAO;
import herramientas.Utileria;

public class RegulatorioB2021DAO extends BaseDAO{

	public RegulatorioB2021DAO() {
		super();
	}
	
	
	/* =========== FUNCIONES PARA OBTENER INFORMACION PARA LOS REPORTES ============= */

	// Consulta para Reporte de  Razones Financieras Relevantes por Entidad B 2021
	public List <RegulatorioB2021Bean> reporteRegulatorioB2021(final RegulatorioB2021Bean bean, int tipoReporte){	
		transaccionDAO.generaNumeroTransaccion();
		String query = "call REGULATORIOB2021REP(?,?,?,?,?,   ?,?,?,?,?)";

		Object[] parametros ={
							Utileria.convierteEntero(bean.getAnio()),
							Utileria.convierteEntero(bean.getMes()),
							tipoReporte,
				    		parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							parametrosAuditoriaBean.getNombrePrograma(),
							parametrosAuditoriaBean.getSucursal(),
							parametrosAuditoriaBean.getNumeroTransaccion()
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REGULATORIOB2021REP(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				
				RegulatorioB2021Bean beanResponse= new RegulatorioB2021Bean();
				beanResponse.setConsecutivo(resultSet.getString("TmpID"));
				beanResponse.setConcepto(resultSet.getString("Descripcion"));
				beanResponse.setClaveEntidad(resultSet.getString("ClaveEntidad"));
				beanResponse.setValorFijo1(resultSet.getString("ValorFijo1"));
				beanResponse.setNumClientes(resultSet.getString("NumClientes"));
				beanResponse.setSaldo(resultSet.getString("Saldo"));

				return beanResponse ;
			}
		});
		return matches;
	}
	

	// Consulta para Reporte csv de  Razones Financieras Relevantes por Entidad B 2021
	public List <RegulatorioB2021Bean> reporteRegulatorioB2021Csv(final RegulatorioB2021Bean bean, int tipoReporte){	
		transaccionDAO.generaNumeroTransaccion();
		String query = "call REGULATORIOB2021REP(?,?,?,?,?,   ?,?,?,?,?)";

		Object[] parametros ={
							Utileria.convierteEntero(bean.getAnio()),
							Utileria.convierteEntero(bean.getMes()),
							tipoReporte,
				    		parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							parametrosAuditoriaBean.getNombrePrograma(),
							parametrosAuditoriaBean.getSucursal(),
							parametrosAuditoriaBean.getNumeroTransaccion()
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REGULATORIOB2021REP(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				
				RegulatorioB2021Bean beanResponse= new RegulatorioB2021Bean();
				beanResponse.setValor(resultSet.getString("Valor"));

				return beanResponse ;
			}
		});
		return matches;
	}

}
