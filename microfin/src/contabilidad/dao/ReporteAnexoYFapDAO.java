package contabilidad.dao;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;

import contabilidad.bean.ReporteAnexoYFapBean;

import general.dao.BaseDAO;
import herramientas.Utileria;

public class ReporteAnexoYFapDAO extends BaseDAO{
	
	public ReporteAnexoYFapDAO() {
		super();
	}
	public List <ReporteAnexoYFapBean> reporteAnexoYFapCSV(final ReporteAnexoYFapBean bean, int tipoReporte){	
		transaccionDAO.generaNumeroTransaccion();
		String query = "call REGANEXOYFAPREP(?,?,?,?,?, ?,?,?,?,?)";

		Object[] parametros ={
							bean.getFecha(),
							tipoReporte,
							Utileria.convierteEntero("2"),
				    		parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							"reporteAnexoYFapDAO.reporteAnexoYFapCsv",
							parametrosAuditoriaBean.getSucursal(),
							parametrosAuditoriaBean.getNumeroTransaccion()
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REGANEXOYFAPREP(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				
				ReporteAnexoYFapBean beanResponse= new ReporteAnexoYFapBean();
				beanResponse.setValor(resultSet.getString("Valor"));

				return beanResponse ;
			}
		});
		return matches;
	}
	
	public List <ReporteAnexoYFapBean> reporteAnexoYFapExcel(final ReporteAnexoYFapBean bean, int tipoReporte){	
		transaccionDAO.generaNumeroTransaccion();
		String query = "call REGANEXOYFAPREP(?,?,?,?,?, ?,?,?,?,?)";

		Object[] parametros ={
							bean.getFecha(),
							tipoReporte,
							Utileria.convierteEntero("2"),
				    		parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							"reporteAnexoYFapDAO.reporteAnexoYFapExcel",
							parametrosAuditoriaBean.getSucursal(),
							parametrosAuditoriaBean.getNumeroTransaccion()
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REGANEXOYFAPREP(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ReporteAnexoYFapBean bean = new ReporteAnexoYFapBean();
				
				bean.setNombre(resultSet.getString("Nombre"));
				bean.setApellidoPat(resultSet.getString("ApellidoPat"));
				bean.setApellidoMat(resultSet.getString("ApellidoMat"));
				bean.setClienteID(String.valueOf(resultSet.getInt("ClienteID")));
				bean.setNumeroCuenta(String.valueOf(resultSet.getString("NumeroCuenta")));
				
				bean.setTipoPersona(String.valueOf(resultSet.getInt("TipoPersona")));
				bean.setActividadEconomica(resultSet.getString("ActividadEconomica"));
				bean.setNacionalidad(String.valueOf(resultSet.getInt("Nacionalidad")));
				bean.setFechaNac(resultSet.getString("FechaNac"));
				bean.setRFC(resultSet.getString("RFC"));
				
				bean.setCURP(resultSet.getString("CURP"));
				bean.setCalle(resultSet.getString("Calle"));
				bean.setNumeroExt(resultSet.getString("NumeroExt"));
				bean.setColoniaID(resultSet.getString("ColoniaID"));
				bean.setCodigoPostal(resultSet.getString("CodigoPostal"));
				
				bean.setMunicipioID(String.valueOf(resultSet.getInt("MunicipioID")));
				bean.setLocalidad(resultSet.getString("Localidad"));
				bean.setEstadoID(String.valueOf(resultSet.getInt("EstadoID")));
				bean.setCodigoPais(resultSet.getString("CodigoPais"));
				bean.setDireccion(resultSet.getString("Direccion"));
				
				bean.setTelefonoCasa(resultSet.getString("TelefonoCasa"));
				bean.setTelefonoCelular(resultSet.getString("TelefonoCelular"));
				bean.setTelefonoOficina(resultSet.getString("TelefonoOficina"));
				bean.setTelefonoLocalizacion(resultSet.getString("TelefonoLocalizacion"));
				bean.setRelacionLocalizacion(resultSet.getString("RelacionLocalizacion"));
				
				bean.setCorreo(resultSet.getString("Correo"));
				bean.setClaveSucursal(String.valueOf(resultSet.getInt("ClaveSucursal")));
				bean.setNombreSucursal(resultSet.getString("NombreSucursal"));
				bean.setDireccionSucursal(resultSet.getString("DireccionSucursal"));
				bean.setClasfContable(resultSet.getString("ClasfContable"));
				
				bean.setTipoCuenta(resultSet.getString("TipoCuenta"));
				bean.setNumContrato(resultSet.getString("NumContrato"));
				bean.setFechaContrato(resultSet.getString("FechaContrato"));
				bean.setFechaVencimiento(resultSet.getString("FechaVencimiento"));
				bean.setPlazoDeposito(String.valueOf(resultSet.getInt("PlazoDeposito")));
				
				bean.setPeriodicidad(String.valueOf(resultSet.getInt("Periodicidad")));
				bean.setTasaPactada(String.valueOf(resultSet.getDouble("TasaPactada")));
				bean.setFechaUltimoDeposito(resultSet.getString("FechaUltimoDeposito"));
				bean.setSaldoUltimoDepostito(String.valueOf(resultSet.getDouble("SaldoUltimoDepostito")));
				bean.setPorcFondoPro(resultSet.getString("PorcFondoPro"));
				
				bean.setSaldoCapital(String.valueOf(resultSet.getDouble("SaldoCapital")));
				bean.setIntDevNoPago(String.valueOf(resultSet.getDouble("IntDevNoPago")));
				bean.setSaldoFinal(String.valueOf(resultSet.getDouble("SaldoFinal")));

				return bean ;
			}
		});
		return matches;
}
}
