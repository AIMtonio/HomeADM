package regulatorios.dao;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;
 
import regulatorios.bean.RegulatorioA3011Bean;
import general.dao.BaseDAO;
import herramientas.Utileria;

public class RegulatorioA3011DAO extends BaseDAO{

	public RegulatorioA3011DAO() {
		super();
	}
	
	
	/* =========== FUNCIONES PARA OBTENER INFORMACION PARA LOS REPORTES ============= */

	// Consulta para Reporte de  Razones Financieras Relevantes por Entidad A-3011
	public List <RegulatorioA3011Bean> reporteRegulatorioA3011(final RegulatorioA3011Bean bean, int tipoReporte){	
		transaccionDAO.generaNumeroTransaccion();
		String query = "call REGULATORIOA3011REP(?,?,?,?,?,   ?,?,?,?,?)";

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
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REGULATORIOA3011REP(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				
				RegulatorioA3011Bean beanResponse= new RegulatorioA3011Bean();
				
				beanResponse.setPeriodo(resultSet.getString("Periodo"));
				beanResponse.setClaveEntidad(resultSet.getString("ClaveEntidad"));
				beanResponse.setClaveFormulario(resultSet.getString("ClaveFormulario"));
				beanResponse.setEstadoID(resultSet.getString("EstadoID"));
				beanResponse.setMunicipioID(resultSet.getString("MunicipioID"));
				beanResponse.setNumSucursales(resultSet.getString("NumSucursales"));
				beanResponse.setNumCajerosATM(resultSet.getString("NumCajerosATM"));
				beanResponse.setNumMujeres(resultSet.getString("NumMujeres"));
				beanResponse.setNumHombres(resultSet.getString("NumHombres"));
				beanResponse.setParteSocial(resultSet.getString("ParteSocial"));
				beanResponse.setNumContrato(resultSet.getString("NumContrato"));
				beanResponse.setSaldoAcum(resultSet.getString("SaldoAcum"));
				beanResponse.setNumContratoPlazo(resultSet.getString("NumContratoPlazo"));
				beanResponse.setSaldoAcumPlazo(resultSet.getString("SaldoAcumPlazo"));
				beanResponse.setNumContratoTD(resultSet.getString("NumContratoTD"));
				beanResponse.setSaldoAcumTD(resultSet.getString("SaldoAcumTD"));
				beanResponse.setNumContratoTDRecar(resultSet.getString("NumContratoTDRecar"));
				beanResponse.setSaldoAcumTDRecar(resultSet.getString("SaldoAcumTDRecar"));
				beanResponse.setNumRemesas(resultSet.getString("NumRemesas"));
				beanResponse.setMontoRemesas(resultSet.getString("MontoRemesas"));				
				beanResponse.setNumCreditos(resultSet.getString("NumCreditos"));
				beanResponse.setSaldoVigenteCre(resultSet.getString("SaldoVigenteCre"));
				beanResponse.setSaldoVencidoCre(resultSet.getString("SaldoVencidoCre"));
				beanResponse.setNumMicroCreditos(resultSet.getString("NumMicroCreditos"));
				beanResponse.setSaldoVigenteMicroCre(resultSet.getString("SaldoVigenteMicroCre"));
				beanResponse.setSaldoVencidoMicroCre(resultSet.getString("SaldoVencidoMicroCre"));
				beanResponse.setNumContratoTC(resultSet.getString("NumContratoTC"));
				beanResponse.setSaldoVigenteTC(resultSet.getString("SaldoVigenteTC"));
				beanResponse.setSaldoVencidoTC(resultSet.getString("SaldoVencidoTC"));
				beanResponse.setNumCreConsumo(resultSet.getString("NumCreConsumo"));
				beanResponse.setSaldoVigenteCreConsumo(resultSet.getString("SaldoVigenteCreConsumo"));
				beanResponse.setSaldoVencidoCreConsumo(resultSet.getString("SaldoVencidoCreConsumo"));
				beanResponse.setNumCreVivienda(resultSet.getString("NumCreVivienda"));				
				beanResponse.setSaldoVigenteCreVivienda(resultSet.getString("SaldoVigenteCreVivienda"));
				beanResponse.setSaldoVencidoCreVivienda(resultSet.getString("SaldoVencidoCreVivienda"));

				return beanResponse ;
			}
		});
		return matches;
	}
	
	
	// Consulta para Reporte csv de  Razones Financieras Relevantes por Entidad A3011
	public List <RegulatorioA3011Bean> reporteRegulatorioA3011Csv(final RegulatorioA3011Bean bean, int tipoReporte){	
		transaccionDAO.generaNumeroTransaccion();
		String query = "call REGULATORIOA3011REP(?,?,?,?,?,   ?,?,?,?,?)";

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
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REGULATORIOA3011REP(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				
				RegulatorioA3011Bean beanResponse= new RegulatorioA3011Bean();
				
				beanResponse.setValor(resultSet.getString("Valor"));

				return beanResponse ;
			}
		});
		return matches;
	}

}
