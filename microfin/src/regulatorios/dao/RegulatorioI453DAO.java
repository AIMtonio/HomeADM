package regulatorios.dao;

import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import regulatorios.bean.RegulatorioI453Bean;
import general.dao.BaseDAO;
import herramientas.Utileria;

public class RegulatorioI453DAO extends BaseDAO{

	public RegulatorioI453DAO() {
		super();
	}
	
	
	/* =========== FUNCIONES PARA OBTENER INFORMACION PARA LOS REPORTES ============= */

	/**
	 * Consulta para generar el reporte regulatorio I0453
	 * @param bean
	 * @param tipoReporte
	 * @return
	 */
	public List <RegulatorioI453Bean> reporteRegulatorioI453(final RegulatorioI453Bean bean, int tipoReporte){	
		transaccionDAO.generaNumeroTransaccion();
		String query = "call REGULATORIOI0453REP(?,?,?,?,?  ,?,?,?,?,?,  ?)";
		
		int NumeroDecimales = 2;
		
		Object[] parametros ={
							Utileria.convierteEntero(bean.getAnio()),
							Utileria.convierteEntero(bean.getMes()),
							tipoReporte,
							NumeroDecimales,
				    		parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							parametrosAuditoriaBean.getNombrePrograma(),
							parametrosAuditoriaBean.getSucursal(),
							parametrosAuditoriaBean.getNumeroTransaccion()
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REGULATORIOI0453REP(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				
				RegulatorioI453Bean beanResponse= new RegulatorioI453Bean();

				beanResponse.setClaveEntidad(resultSet.getString("ClaveEntidad"));
				beanResponse.setPeriodo(resultSet.getString("Periodo"));
				beanResponse.setFormulario(resultSet.getString("Formulario"));
				beanResponse.setClienteID(resultSet.getString("ClienteID"));
				beanResponse.setTipoPersona(resultSet.getString("TipoPersona"));
				beanResponse.setDenominacion(resultSet.getString("Denominacion"));
				beanResponse.setApellidoPat(resultSet.getString("ApellidoPat"));
				beanResponse.setApellidoMat(resultSet.getString("ApellidoMat"));
				beanResponse.setRfc(resultSet.getString("RFC"));
				beanResponse.setCurp(resultSet.getString("CURP"));
				beanResponse.setGenero(resultSet.getString("Genero"));
				beanResponse.setCreditoID(resultSet.getString("CreditoID"));
				beanResponse.setClaveSucursal(resultSet.getString("ClaveSucursal"));
				beanResponse.setClasifConta(resultSet.getString("ClasifConta"));
				beanResponse.setProductoCredito(resultSet.getString("ProductoCredito"));
				beanResponse.setFechaDisp(resultSet.getString("FechaDisp"));
				beanResponse.setFechaVencim(resultSet.getString("FechaVencim"));
				beanResponse.setTipoAmorti(resultSet.getString("TipoAmorti"));
				beanResponse.setMontoCredito(resultSet.getString("MontoCredito"));
				beanResponse.setFecUltPagoCap(resultSet.getString("FecUltPagoCap"));
				beanResponse.setMonUltPagoCap(resultSet.getString("MonUltPagoCap"));
				beanResponse.setFecUltPagoInt(resultSet.getString("FecUltPagoInt"));
				beanResponse.setMonUltPagoInt(resultSet.getString("MonUltPagoInt"));
				beanResponse.setFecPrimAtraso(resultSet.getString("FecPrimAtraso"));
				beanResponse.setNumDiasAtraso(resultSet.getString("NumDiasAtraso"));
				beanResponse.setTipoCredito(resultSet.getString("TipoCredito"));
				beanResponse.setSalCapital(resultSet.getString("SalCapital"));
				beanResponse.setSalIntOrdin(resultSet.getString("SalIntOrdin"));
				beanResponse.setSalIntMora(resultSet.getString("SalIntMora"));
				beanResponse.setIntereRefinan(resultSet.getString("IntereRefinan"));
				beanResponse.setSaldoInsoluto(resultSet.getString("SaldoInsoluto"));
				beanResponse.setMontoCastigo(resultSet.getString("MontoCastigo"));
				beanResponse.setMontoCondona(resultSet.getString("MontoCondona"));
				beanResponse.setMontoBonifi(resultSet.getString("MontoBonifi"));
				beanResponse.setFechaCastigo(resultSet.getString("FechaCastigo"));
				beanResponse.setTipoRelacion(resultSet.getString("TipoRelacion"));
				beanResponse.setePRCTotal(resultSet.getString("EPRCTotal"));
				beanResponse.setClaveSIC(resultSet.getString("ClaveSIC"));
				beanResponse.setFecConsultaSIC(resultSet.getString("FecConsultaSIC"));
				beanResponse.setTipoCobranza(resultSet.getString("TipoCobranza"));
				beanResponse.setTotGtiaLiquida(resultSet.getString("TotGtiaLiquida"));
				beanResponse.setGtiaHipotecaria(resultSet.getString("GtiaHipotecaria"));

				return beanResponse ;
			}
		});
		return matches;
	}
	/**
	 * Consulta del reporte regulatorio Desagregado Cartera Castigada I0453 version CSV
	 * @param bean
	 * @param tipoReporte
	 * @return
	 */
	public List <RegulatorioI453Bean> reporteRegulatorioI453Csv(final RegulatorioI453Bean bean, int tipoReporte){	
		transaccionDAO.generaNumeroTransaccion();
		String query = "call REGULATORIOI0453REP(?,?,?,?,?  ,?,?,?,?,?,  ?)";
		int NumeroDecimales = 2;
		Object[] parametros ={
							Utileria.convierteEntero(bean.getAnio()),
							Utileria.convierteEntero(bean.getMes()),
							tipoReporte,
							NumeroDecimales,
				    		parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							parametrosAuditoriaBean.getNombrePrograma(),
							parametrosAuditoriaBean.getSucursal(),
							parametrosAuditoriaBean.getNumeroTransaccion()
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REGULATORIOI0453REP(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				
				RegulatorioI453Bean beanResponse= new RegulatorioI453Bean();
				beanResponse.setValor(resultSet.getString("Valor"));

				return beanResponse ;
			}
		});
		return matches;
	}

}
