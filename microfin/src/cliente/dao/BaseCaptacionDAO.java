package cliente.dao;

import general.dao.BaseDAO;
import herramientas.Constantes;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;

import cliente.bean.BaseCaptacionBean;


public class BaseCaptacionDAO extends BaseDAO{
	
	/*------------Alta de Operaciones-------------*/		
	public List consultaCaptacionExcel(BaseCaptacionBean baseCaptacionBean, int tipoReporte){
		List matches = null;
		try{
			String query = "call BASECAPTACIONREP(?,?,?,?,?, ?,?,?,?);";
			Object[] parametros = { 	
									baseCaptacionBean.getFechaReporte(),									
									tipoReporte,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									Constantes.STRING_VACIO,								
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};
			
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call BASECAPTACIONREP(" + Arrays.toString(parametros) +")");
		matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					BaseCaptacionBean baseCaptacionBean = new BaseCaptacionBean();
					
					baseCaptacionBean.setNumCliente(String.valueOf(resultSet.getInt("NumCliente")));
					baseCaptacionBean.setNumCuenta(resultSet.getString("NumCuenta"));					
					baseCaptacionBean.setNombreCliente(resultSet.getString("NombreCliente"));
					baseCaptacionBean.setNombreSucursal(resultSet.getString("NombreSucursal"));
					baseCaptacionBean.setNumeroSucursal(String.valueOf(resultSet.getInt("NumeroSucursal")));
					baseCaptacionBean.setProducto(resultSet.getString("Producto"));
					baseCaptacionBean.setTipoPersona(resultSet.getString("TipoPersona"));
					baseCaptacionBean.setGradoRiesgo(resultSet.getString("GradoRiesgo"));
					baseCaptacionBean.setActividad(resultSet.getString("Actividad"));
					baseCaptacionBean.setLocalidad(resultSet.getString("Localidad"));
					baseCaptacionBean.setNacionalidad(resultSet.getString("Nacionalidad"));
					baseCaptacionBean.setFechaNacimiento(resultSet.getString("FechaNacimiento"));
					baseCaptacionBean.setRFC(resultSet.getString("RFC"));
					baseCaptacionBean.setTipoDeposito(resultSet.getString("TipoDeposito"));
					baseCaptacionBean.setTipoInversion(resultSet.getString("TipoInversion"));
					baseCaptacionBean.setFechaApertura(resultSet.getString("FechaApertura"));
					baseCaptacionBean.setFechaVencimiento(resultSet.getString("FechaVencimiento"));		
					baseCaptacionBean.setPlazo(String.valueOf(resultSet.getInt("Plazo")));
					baseCaptacionBean.setFormaPagRend(resultSet.getString("FormaPagRendimientos"));
					baseCaptacionBean.setTasaAnual(String.valueOf(resultSet.getString("TasaAnual")));
					baseCaptacionBean.setDiasPorVencer(String.valueOf(resultSet.getString("DiasPorVencer")));
					baseCaptacionBean.setFechaUltDep(resultSet.getString("FechaUltDeposito"));
					baseCaptacionBean.setMontoUltDep(resultSet.getString("MontoUltDeposito"));
					baseCaptacionBean.setCapital(String.valueOf(resultSet.getDouble("Capital")));
					baseCaptacionBean.setIntDevengados(String.valueOf(resultSet.getDouble("IntDevengados")));
					baseCaptacionBean.setIntDevengadosMes(String.valueOf(resultSet.getDouble("IntDevengadosMes")));
					baseCaptacionBean.setSaldoPromedio(String.valueOf(resultSet.getDouble("SaldoPromedio")));
					baseCaptacionBean.setSaldoTotalCMes(String.valueOf(resultSet.getDouble("SaldoTotalCieMes")));
					baseCaptacionBean.setGarantiaLiquida(resultSet.getString("GarantiaLiquida"));
					baseCaptacionBean.setPorcentajeGta(resultSet.getString("PorcentajeGarantia"));
					return baseCaptacionBean;
				}
			});
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en consulta de REPFOCOOP", e);
		}
		return matches;
	}
	
	/*------------Alta de Operaciones-------------*/		
	public List consultaCaptacionCSV(BaseCaptacionBean baseCaptacionBean, int tipoReporte){
		List matches = null;
		try{
			String query = "call BASECAPTACIONREP(?,?,?,?,?, ?,?,?,?);";
			Object[] parametros = { 	
									baseCaptacionBean.getFechaReporte(),									
									tipoReporte,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									Constantes.STRING_VACIO,								
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};
			
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call BASECAPTACIONREP(" + Arrays.toString(parametros) +")");
		matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					BaseCaptacionBean baseCaptacionBean = new BaseCaptacionBean();
					
					baseCaptacionBean.setValor(resultSet.getString("Valor"));
					return baseCaptacionBean;
				}
			});
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en consulta de REPFOCOOP", e);
		}
		return matches;
	}

}

